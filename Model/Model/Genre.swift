//
//  Genre.swift
//  Survy
//
//  Created by Mac mini on 2023/04/28.
//

import Foundation

public struct Genre: Codable {
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    public let id: Int
    public let name: String
}

//extension Genre: Hashable {
//    public static func == (lhs: Genre, rhs: Genre) -> Bool {
//        return lhs.id == rhs.id
//    }
//}

public struct GenreResponse: Decodable {
    public let genres: [Genre]?
}

extension Genre: Hashable {
    public static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Genre: Comparable {
    public static func < (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.name < rhs.name
    }
}


//extension Genre:

// 이거 먼저 Decode 해보기.

//{
//    "genres": [
//        {
//            "id": 4,
//            "name": "운동"
//        }
//    ]
//}
