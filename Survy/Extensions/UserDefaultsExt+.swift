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
        case myGenres
        case isAddingSelectableOption
        case defaultUsername
        case autoLoginEnabled
    }
    
    public var autoLoginEnabled: Bool {
        get {
            return self.bool(forKey: .autoLoginEnabled)
        }
        set {
            set(newValue, forKey: .autoLoginEnabled)
        }
    }
    

    public var defaultUsername: String {
        get {
            return self.string(forKey: .defaultUsername) ?? ""
        }
        set {
            set(newValue, forKey: .defaultUsername)
        }
    }
    
//    public var defaultPassword: String {
//        get {
//            return self.string(forKey: .defaultPassword) ?? ""
//        }
//        set {
//            set(newValue, forKey: .defaultPassword)
//        }
//    }
    
    
    public var isAddingSelectableOption: Bool {
        get {
            return self.bool(forKey: .isAddingSelectableOption)
        }
        set {
            set(newValue, forKey: .isAddingSelectableOption)
        }
    }
    
    public var isIndivisualSelected: Bool {
        get {
            return self.bool(forKey: .isIndivisualSelected)
        }
        set {
            set(newValue, forKey: .isIndivisualSelected)
        }
    }
    
    public var myGenres: [Genre] {
        get {
            guard  let data = object(forKey: Key.myGenres.rawValue) as? Data,
                   let genres = try? JSONDecoder().decode([Genre].self, from: data) else {
                return []
            }
            return genres
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: .myGenres)
            }
        }
    }
    
    func array(forKey key: Key) -> [Genre]? {
        return array(forKey: key.rawValue) as? [Genre]
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
