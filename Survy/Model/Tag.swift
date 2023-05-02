//
//  Tag.swift
//  Survy
//
//  Created by Mac mini on 2023/04/28.
//

import Foundation

struct Tag: Decodable {
    let id: Int
    let name: String
}

struct TagResponse: Decodable {
    let tags: [Tag]?
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
