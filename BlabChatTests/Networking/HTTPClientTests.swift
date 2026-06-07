//
//  HTTPClientTests.swift
//  BlabChatTests
//
//  Created by Michael Pace on 5/5/26.
//

import Foundation
import Testing

@testable import BlabChat

@Suite("HTTPClient")
struct HTTPClientTests {
    @Suite("make(:URLRequest, :retries)")
    struct MakeRequest {
        private let getRequest: URLRequest = {
            var request = URLRequest(url: URL(string: "https://www.google.com")!)
            request.httpMethod = "GET"
            return request
        }()

        private let subject: DefaultHTTPClient
        private let mockURLSession: MockURLSession
        private let mockDecoder: MockJSONDecoder

        init() {
            mockURLSession = MockURLSession()
            mockDecoder = MockJSONDecoder()

            subject = DefaultHTTPClient(
                urlSession: mockURLSession,
                decoder: mockDecoder
            )
        }

        @Test
        func `get - 2XX happy path`() async throws {
            mockURLSession.nextDataForRequest = [(validJSON, url200Response, nil)]
            let expectedCodable = CodableExample()
            mockDecoder.nextDecodables = [expectedCodable]

            let result: CodableExample = try await subject.makeRequest(getRequest)

            #expect(result == expectedCodable)
            #expect(mockURLSession.dataForRequestInvocations == 1)
            let lastRequest = try #require(mockURLSession.lastURLRequest.last)
            #expect(lastRequest.httpMethod == "GET")
            #expect(lastRequest.url == URL(string: "https://www.google.com")!)
            #expect(mockDecoder.decodeInvocations == 1)
        }

        @Test
        func `get - 2XX decoder throws`() async throws {
            mockURLSession.nextDataForRequest = [(validJSON, url200Response, nil)]
            mockDecoder.decodeShouldThrow = true

            await #expect {
                let _: CodableExample = try await subject.makeRequest(getRequest)
            } throws: { error in
                (error as NSError).domain == "MockJSONDecoder is throwing on purpose"
            }

            #expect(mockURLSession.dataForRequestInvocations == 1)
            let lastRequest = try #require(mockURLSession.lastURLRequest.last)
            #expect(lastRequest.httpMethod == "GET")
            #expect(lastRequest.url == URL(string: "https://www.google.com")!)
            #expect(mockDecoder.decodeInvocations == 1)
        }

        @Test
        func `get - 4XX is never retried`() async throws {
            mockURLSession.nextDataForRequest = [(validJSON, url400Response, nil)]

            await #expect(throws: NetworkError.badRequest) {
                let _: CodableExample = try await subject.makeRequest(getRequest, 3)
            }

            #expect(mockURLSession.dataForRequestInvocations == 1)
            let lastRequest = try #require(mockURLSession.lastURLRequest.last)
            #expect(lastRequest.httpMethod == "GET")
            #expect(lastRequest.url == URL(string: "https://www.google.com")!)
            #expect(mockDecoder.decodeInvocations == 0)
        }

        @Test
        func `get - 5XX, out of retries`() async throws {
            mockURLSession.nextDataForRequest = [
                (validJSON, url500Response, nil),
                (validJSON, url500Response, nil),
                (validJSON, url500Response, nil)
            ]

            await #expect(throws: NetworkError.serverError) {
                let _: CodableExample = try await subject.makeRequest(getRequest, 2)
            }

            #expect(mockURLSession.dataForRequestInvocations == 3)
            let lastRequest = try #require(mockURLSession.lastURLRequest.last)
            #expect(lastRequest.httpMethod == "GET")
            #expect(lastRequest.url == URL(string: "https://www.google.com")!)
            #expect(mockDecoder.decodeInvocations == 0)
        }

        @Test
        func `get - retry logic, scenario 1`() async throws {
            // Scenario 1: network-level errors (urlSession throws) are retried until success
            mockURLSession.nextDataForRequest = [
                (validJSON, url200Response, networkError),
                (validJSON, url200Response, networkError),
                (validJSON, url200Response, networkError),
                (validJSON, url200Response, networkError),
                (validJSON, url200Response, nil)
            ]
            let expectedCodable = CodableExample()
            mockDecoder.nextDecodables = [expectedCodable]

            let result: CodableExample = try await subject.makeRequest(getRequest, 4)

            #expect(result == expectedCodable)
            #expect(mockURLSession.dataForRequestInvocations == 5)
            let lastRequest = try #require(mockURLSession.lastURLRequest.last)
            #expect(lastRequest.httpMethod == "GET")
            #expect(lastRequest.url == URL(string: "https://www.google.com")!)
            #expect(mockDecoder.decodeInvocations == 1)
        }

        @Test
        func `get - retry logic, scenario 2`() async throws {
            // Scenario 2: 5XX responses are retried until success
            mockURLSession.nextDataForRequest = [
                (validJSON, url500Response, nil),
                (validJSON, url500Response, nil),
                (validJSON, url500Response, nil),
                (validJSON, url500Response, nil),
                (validJSON, url200Response, nil)
            ]
            let expectedCodable = CodableExample()
            mockDecoder.nextDecodables = [expectedCodable]

            let result: CodableExample = try await subject.makeRequest(getRequest, 4)

            #expect(result == expectedCodable)
            #expect(mockURLSession.dataForRequestInvocations == 5)
            let lastRequest = try #require(mockURLSession.lastURLRequest.last)
            #expect(lastRequest.httpMethod == "GET")
            #expect(lastRequest.url == URL(string: "https://www.google.com")!)
            #expect(mockDecoder.decodeInvocations == 1)
        }
    }
}

struct CodableExample: Codable, Equatable {}

fileprivate let validJSON = "{}".data(using: .utf8)!
fileprivate let networkError = NSError(domain: "network error", code: -1)

fileprivate let url200Response = HTTPURLResponse(
    url: URL(string: "www.not.matter")!,
    statusCode: 200,
    httpVersion: nil,
    headerFields: [:]
)!
fileprivate let url400Response = HTTPURLResponse(
    url: URL(string: "www.not.matter")!,
    statusCode: 400,
    httpVersion: nil,
    headerFields: [:]
)!
fileprivate let url500Response = HTTPURLResponse(
    url: URL(string: "www.not.matter")!,
    statusCode: 500,
    httpVersion: nil,
    headerFields: [:]
)!
