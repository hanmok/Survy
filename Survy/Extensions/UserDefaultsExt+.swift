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
        case lastSelectedCategories
    }
    
    public var isIndivisualSelected: Bool {
        get {
            return self.bool(forKey: .isIndivisualSelected)
        }
        set {
            set(newValue, forKey: .isIndivisualSelected)
        }
    }
    
    public var lastSelectedCategories: String {
        get {
            return self.string(forKey: .lastSelectedCategories) ?? ""
        }
        set {
            set(newValue, forKey: .lastSelectedCategories)
        }
    }
    
    public var lastSelectedCategoriesSet: Set<Int> {
        return lastSelectedCategories.makeIntSet() // set of tag Id
    }
    
    private func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    private func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    private func set(_ value: Any?, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
}
