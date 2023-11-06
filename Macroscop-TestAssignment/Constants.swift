//
//  Constants.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import Foundation

enum Constants {
    static let serverRoot = "http://demo.macroscop.com"
    static let serverConfigEndpoint = "/configex"
    static let serverMobileEndpoint = "/mobile"
    
    static let startOfImageMarker = Data([0xFF, 0xD8])
    static let endOfImageMarker = Data([0xFF, 0xD9])
}
