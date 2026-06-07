//
//  MockJSONDecoder.swift
//  BlabChatTests
//
//  Created by Michael Pace on 5/5/26.
//

import Foundation

@testable import BlabChat

final class MockJSONDecoder: ScaffoldJSONDecoder {
    var decodeShouldThrow = false
    var nextDecodables = [Decodable]()
    var decodeInvocations = 0

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        decodeInvocations += 1

        guard !decodeShouldThrow else {
            throw NSError(domain: "MockJSONDecoder is throwing on purpose", code: -1)
        }

        guard !nextDecodables.isEmpty,
              let nextDecodable = nextDecodables.removeFirst() as? T else {
            throw NSError(domain: "MockJSONDecoder.nextDecodable is nil", code: -1)
        }

        return nextDecodable
    }
}
