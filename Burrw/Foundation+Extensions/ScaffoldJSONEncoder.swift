//
//  ScaffoldJSONEncoder.swift
//  Burrw
//
//  Created by Michael Pace on 6/7/26.
//

import Foundation

protocol ScaffoldJSONEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: ScaffoldJSONEncoder {}
