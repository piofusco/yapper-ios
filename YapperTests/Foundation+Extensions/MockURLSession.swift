//
//  MockURLSession.swift
//  YapperTests
//
//  Created by Michael Pace on 5/5/26.
//

import Foundation

@testable import Yapper

final class MockURLSession: ScaffoldURLSession {
    var dataForRequestInvocations = 0
    var nextDataForRequest = [(Data, URLResponse, errorToThrow: Error?)]()
    var lastURLRequest = [URLRequest]()

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataForRequestInvocations += 1
        lastURLRequest.append(request)

        guard let _ = nextDataForRequest.first else {
            throw NSError(domain: "nextDataForRequest is empty", code: -1)
        }

        let (data, response, errorToThrow) = nextDataForRequest.removeFirst()

        guard errorToThrow == nil else { throw errorToThrow! }

        return (data, response)
    }
}
