//
//  HTTPClient.swift
//  BlabChat
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation

enum NetworkError: Equatable, Error {
    case internalError
    case badRequest // 4xx
    case serverError // 5xx
    case disconnected
}

protocol HTTPClient {
    func makeRequest<T: Decodable>(
        _ request: URLRequest,
        _ retries: Int
    ) async throws -> T
}

final class DefaultHTTPClient: HTTPClient {
    private let urlSession: ScaffoldURLSession
    private let decoder: ScaffoldJSONDecoder
    private let logger: any ScaffoldLogger

    init(
        urlSession: ScaffoldURLSession = URLSession.shared,
        decoder: ScaffoldJSONDecoder = JSONDecoder(),
        logger: any ScaffoldLogger = DefaultLogger(category: "HTTP")
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.logger = logger
    }

    func makeRequest<T: Decodable>(
        _ request: URLRequest,
        _ retries: Int = 0
    ) async throws -> T {
        var attempt = 0

        while true {
            do {
                logger.debug("→ \(request.httpMethod ?? "?") \(request.url?.absoluteString ?? "?")")
                let (data, response) = try await urlSession.data(for: request)
                guard let response = response as? HTTPURLResponse else { throw NetworkError.internalError }
                logger.debug("← \(response.statusCode) \(request.url?.absoluteString ?? "?")")

                switch response.statusCode {
                    case 200...299: return try decoder.decode(T.self, from: data)
                    case 400...499: throw NetworkError.badRequest
                    case 500...599: throw NetworkError.serverError
                    default: throw NetworkError.internalError
                }
            } catch NetworkError.badRequest {
                throw NetworkError.badRequest
            } catch {
                logger.error("✗ \(request.url?.absoluteString ?? "?") — \(error)")
                if attempt >= retries || error is DecodingError { throw error }

                attempt += 1
            }
        }
    }
}
