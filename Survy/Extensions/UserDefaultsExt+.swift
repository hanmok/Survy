//
//  UserDefaults.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case isIndivisualSelected
    }
    
    public var isIndivisualSelected: Bool {
        get {
            return self.bool(forKey: .isIndivisualSelected)
        }
        set {
            set(newValue, forKey: .isIndivisualSelected)
        }
    }
    
    private func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    private func set(_ value: Any?, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
}
