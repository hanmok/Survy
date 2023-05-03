//
//  Tag.swift
//  Survy
//
//  Created by Mac mini on 2023/04/28.
//

import Foundation

public struct Tag: Decodable {
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    public let id: Int
    public let name: String
}

public struct TagResponse: Decodable {
    public let tags: [Tag]?
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
