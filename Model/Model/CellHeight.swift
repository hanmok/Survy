//
//  CellHeight.swift
//  Model
//
//  Created by Mac mini on 2023/05/22.
//

import Foundation

public struct CellHeight: Hashable {
    public let index: Int
    public let height: CGFloat
    
    public static func == (lhs: CellHeight, rhs: CellHeight) -> Bool {
        return lhs.index == rhs.index
    }
    
    public init(index: Int, height: CGFloat) {
        self.index = index
        self.height = height
    }
}
