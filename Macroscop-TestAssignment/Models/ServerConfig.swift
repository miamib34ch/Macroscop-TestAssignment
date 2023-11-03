//
//  ServerConfig.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import Foundation

struct ServerConfig: Codable {
    let channels: [Channel]
    let rootSECObject: RootSECObject

    enum CodingKeys: String, CodingKey {
        case channels = "Channels"
        case rootSECObject = "RootSecObject"
    }
}
