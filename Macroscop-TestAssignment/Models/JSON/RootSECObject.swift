//
//  RootSECObject.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import Foundation

struct RootSECObject: Codable {
    let childSECObjects: [ChildSECObject]
    
    enum CodingKeys: String, CodingKey {
        case childSECObjects = "ChildSecObjects"
    }
}
