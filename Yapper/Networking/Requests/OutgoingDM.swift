//
//  OutgoingDM.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct OutgoingDM: Encodable {
    let type = "dm"
    let text: String
    let to: String
    let ts: Int64
}
