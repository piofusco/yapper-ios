//
//  MockHTTPClient.swift
//  BurrwTests
//
//  Created by Michael Pace on 5/5/26.
//

import Foundation

@testable import Burrw

final class MockHTTPClient: HTTPClient {
    var nextError: Error?
    var nextDecodables = [Decodable]()
    var makeRequestInvocations = 0

    func makeRequest<T>(
        _ request: URLRequest,
        _ retries: Int
    ) async throws -> T where T: Decodable {
        makeRequestInvocations += 1

        if let nextError { throw nextError }

        guard !nextDecodables.isEmpty,
              let nextDecodable = nextDecodables.removeFirst() as? T else {
            throw NSError(domain: "MockHTTPClient.nextDecodables is empty or wrong type", code: -1)
        }

        return nextDecodable
    }
}
