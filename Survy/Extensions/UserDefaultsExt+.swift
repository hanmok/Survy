//
//  UserDefaults.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation
import Model

extension UserDefaults {
    enum Key: String {
        case isIndivisualSelected
        case myCategories
    }
    
    public var isIndivisualSelected: Bool {
        get {
            return self.bool(forKey: .isIndivisualSelected)
        }
        set {
            set(newValue, forKey: .isIndivisualSelected)
        }
    }
    
    public var myCategories: [Tag] {
        get {
            guard  let data = object(forKey: Key.myCategories.rawValue) as? Data,
                   let categories = try? JSONDecoder().decode([Tag].self, from: data) else {
                return []
            }
            return categories
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: .myCategories)
            }
        }
    }
    
    func array(forKey key: Key) -> [Tag]? {
        return array(forKey: key.rawValue) as? [Tag]
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
