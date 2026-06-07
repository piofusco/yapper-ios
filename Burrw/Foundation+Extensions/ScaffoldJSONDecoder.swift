//
//  ScaffoldJSONDecoder.swift
//  HatchTakeHome
//
//  Created by Michael Pace on 5/5/26.
//

import Foundation

protocol ScaffoldJSONDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: ScaffoldJSONDecoder {}
