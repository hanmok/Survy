//
//  SelectableOption.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

public struct SelectableOption: Decodable {
    public init(position: Int, value: String? = nil
                ,placeHolder: String? = nil
    ) {
        self.position = position
        self.value = value
        self.placeHolder = placeHolder
    }
    public var id: Int?
    public var position: Int
    public var questionId: Int?
    public var value: String?
    public var placeHolder: String?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case position
        case questionId = "question_id"
        case value
        case placeHolder = "placeholder"
    }
}
