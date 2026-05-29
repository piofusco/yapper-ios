//
//  main.swift
//  Yapper
//
//  Created by Michael Pace on 5/28/26.
//

import SwiftUI

let isTesting = ProcessInfo.processInfo.environment["XCTestBundlePath"] != nil
|| ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

if isTesting {
    TestingApp.main()
} else {
    YapperApp.main()
}
