//
//  IncomingDM.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct IncomingDM: Decodable {
    let type: String
    let text: String
    let from: String
    let ts: Int64
}
