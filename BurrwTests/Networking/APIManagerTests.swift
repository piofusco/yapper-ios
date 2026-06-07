//
//  APIManagerTests.swift
//  BurrwTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Testing
@testable import Burrw

@Suite("DefaultAPIManager")
struct APIManagerTests {

    private func makeSubject(urlSession: MockURLSession = MockURLSession()) -> DefaultAPIManager {
        DefaultAPIManager(httpClient: DefaultHTTPClient(urlSession: urlSession))
    }

    @Test
    func `login - success - returns token`() async throws {
        let mockURLSession = MockURLSession()
        mockURLSession.nextDataForRequest = [(tokenResponseJSON("abc123"), ok200, nil)]
        let subject = makeSubject(urlSession: mockURLSession)

        let token = try await subject.login(with: AuthRequest(username: "pace", password: "secret"))

        #expect(token == "abc123")
    }

    @Test
    func `login - success - sends POST to login URL`() async throws {
        let mockURLSession = MockURLSession()
        mockURLSession.nextDataForRequest = [(tokenResponseJSON("abc123"), ok200, nil)]
        let subject = makeSubject(urlSession: mockURLSession)

        _ = try await subject.login(with: AuthRequest(username: "pace", password: "secret"))

        let request = try #require(mockURLSession.lastURLRequest.last)
        #expect(request.httpMethod == "POST")
        #expect(request.url == BurrwEndpoint.login.url)
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test
    func `login - success - encodes credentials in body`() async throws {
        let mockURLSession = MockURLSession()
        mockURLSession.nextDataForRequest = [(tokenResponseJSON("abc123"), ok200, nil)]
        let subject = makeSubject(urlSession: mockURLSession)

        _ = try await subject.login(with: AuthRequest(username: "pace", password: "secret"))

        let body = try #require(mockURLSession.lastURLRequest.last?.httpBody)
        let json = try #require(try JSONSerialization.jsonObject(with: body) as? [String: String])
        #expect(json["username"] == "pace")
        #expect(json["password"] == "secret")
    }

    @Test
    func `login - 4xx response - throws badRequest`() async {
        let mockURLSession = MockURLSession()
        mockURLSession.nextDataForRequest = [(Data(), url400, nil)]
        let subject = makeSubject(urlSession: mockURLSession)

        await #expect(throws: NetworkError.badRequest) {
            _ = try await subject.login(with: AuthRequest(username: "pace", password: "wrong"))
        }
    }

    @Test
    func `login - network error - rethrows`() async {
        let mockURLSession = MockURLSession()
        mockURLSession.nextDataForRequest = [(Data(), ok200, NSError(domain: "network", code: -1))]
        let subject = makeSubject(urlSession: mockURLSession)

        await #expect(throws: (any Error).self) {
            _ = try await subject.login(with: AuthRequest(username: "pace", password: "secret"))
        }
    }
}

private func tokenResponseJSON(_ token: String) -> Data {
    Data(#"{"token":"\#(token)"}"#.utf8)
}

private let ok200 = HTTPURLResponse(
    url: URL(string: "https://network.devan.chat")!,
    statusCode: 200,
    httpVersion: nil,
    headerFields: [:]
)!

private let url400 = HTTPURLResponse(
    url: URL(string: "https://network.devan.chat")!,
    statusCode: 400,
    httpVersion: nil,
    headerFields: [:]
)!
