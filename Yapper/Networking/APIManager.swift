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
        var urlRequest = URLRequest(url: YapperEndpoint.login.url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: LoginResponse = try await httpClient.makeRequest(urlRequest, 0)
        return response.token
    }
}

private struct LoginResponse: Decodable {
    let token: String
}
