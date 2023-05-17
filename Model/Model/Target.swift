//
//  Tag.swift
//  Survy
//
//  Created by Mac mini on 2023/04/28.
//

import Foundation



public struct Target {
    public init(id: Int, name: String, section: TargetSection) {
        self.id = id
        self.name = name
    }
    
    public let id: Int
    public let name: String
}

extension Target: Decodable { }

extension Target: Hashable {
    public static func == (lhs: Target, rhs: Target) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Target: Comparable {
    public static func < (lhs: Target, rhs: Target) -> Bool {
        return lhs.name < rhs.name
    }
}

public struct TargetResponse: Decodable {
    public let targets: [Target]?
}

// 이거 먼저 Decode 해보기.

//{
//    "tags": [
//        {
//            "id": 4,
//            "name": "운동"
//        }
//    ]
//}

