//
//  MockTokenStore.swift
//  YapperTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
@testable import Yapper

final class MockTokenStore: TokenStore {
    var saveInvocations = 0
    var lastSavedTokens = [String]()
    var saveError: Error?
    func save(_ token: String) throws {
        saveInvocations += 1
        lastSavedTokens.append(token)
        if let saveError { throw saveError }
    }

    var loadInvocations = 0
    var nextToken: String?
    var loadError: Error?
    func load() throws -> String? {
        loadInvocations += 1
        if let loadError { throw loadError }
        return nextToken
    }

    var deleteInvocations = 0
    var deleteError: Error?
    func delete() throws {
        deleteInvocations += 1
        if let deleteError { throw deleteError }
    }
}
