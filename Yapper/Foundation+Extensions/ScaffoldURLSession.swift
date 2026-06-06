//
//  ScaffoldURLSession.swift
//  HatchTakeHome
//
//  Created by Michael Pace on 5/5/26.
//

import Foundation

protocol ScaffoldURLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: ScaffoldURLSession {}
