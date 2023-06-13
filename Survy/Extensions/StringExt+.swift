//
//  StringExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/05/23.
//

import Foundation

extension String {
    public static let optionPlaceholder = "옵션"
}

extension String {
    public func cutStringInOrder() -> [String] {
        let split = self.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        return split.sorted()
    }
}
