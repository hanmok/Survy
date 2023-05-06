//
//  SetExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/05/02.
//

import Foundation

extension Set {
    public typealias Element = String
    mutating func toggle(_ element: Element) {
        if self.contains(element) {
            self.remove(element)
        } else {
            self.insert(element)
        }
    }
}


