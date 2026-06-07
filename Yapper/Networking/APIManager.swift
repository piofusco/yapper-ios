//
//  APIManager.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

protocol APIManager: Sendable {
    func login(
        with request: AuthRequest
    ) async throws -> String
    func register(
        with request: RegisterRequest
    ) async throws -> String
}

final class DefaultAPIManager: APIManager, @unchecked Sendable {
    private let httpClient: any HTTPClient

    init(
        httpClient: any HTTPClient = DefaultHTTPClient()
    ) {
        self.httpClient = httpClient
    }

    func login(
        with request: AuthRequest
    ) async throws -> String {
        let response: AuthResponse = try await httpClient.makeRequest(
            try urlRequest(for: YapperEndpoint.login.url, body: request),
            0
        )
        return response.token
    }

    func register(
        with request: RegisterRequest
    ) async throws -> String {
        let response: AuthResponse = try await httpClient.makeRequest(
            try urlRequest(for: YapperEndpoint.register.url, body: request),
            0
        )
        return response.token
    }

    private func urlRequest(
        for url: URL,
        body: some Encodable
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
}
