//
//  ChildSECObject.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import Foundation

struct ChildSECObject: Codable {
    let childChannels: [String]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case childChannels = "ChildChannels"
        case name = "Name"
    }
}
