//
//  Tag.swift
//  Survy
//
//  Created by Mac mini on 2023/04/28.
//

import Foundation

public struct Tag: Codable {
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    public let id: Int
    public let name: String
}

//extension Tag: Hashable {
//    public static func == (lhs: Tag, rhs: Tag) -> Bool {
//        return lhs.id == rhs.id
//    }
//}

public struct TagResponse: Decodable {
    public let tags: [Tag]?
}

extension Tag: Hashable {
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name < rhs.name
    }
}


//extension Tag:

// 이거 먼저 Decode 해보기.

//{
//    "tags": [
//        {
//            "id": 4,
//            "name": "운동"
//        }
//    ]
//}
