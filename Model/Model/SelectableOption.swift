//
//  SelectableOption.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

public struct SelectableOption {
    public init(position: Int, value: String? = nil, placeHolder: String? = nil) {
        self.position = position
        self.value = value
        self.placeHolder = placeHolder
    }
    
    public let id: Int = Int.random(in: 0 ... 10000)
    public let position: Int
    public var value: String? = nil
    public var placeHolder: String? = nil
}
