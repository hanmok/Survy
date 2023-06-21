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
    
    public func makeIntSet() -> Set<Int> {
        let split = self.split(separator: ",").map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        if split.count == 0 { return Set([-1]) }
        let intArr = split.map { Int($0) ?? -1 }
        return Set(intArr)
    }
}

extension String {
    public func getLastCharacter() -> String? {
        guard self.count > 1 else { return nil }
        let endIndex = self.endIndex
        let lastIndex = self.index(endIndex, offsetBy: -1)
        let character = String(self[lastIndex])
        return character
    }
}
