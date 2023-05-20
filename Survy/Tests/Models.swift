//
//  Models.swift
//  Survy
//
//  Created by Mac mini on 2023/05/18.
//

import Foundation

enum Gender {
    case male, female, unspecified
}

class Person {
    let name: String
    let username: String = "Kanye West"
    let birthdate: Date?
    let middleName: String?
    let address: String?
    let gender: Gender
    var currentlyFollowing: Bool
    
    public init(name: String, currentlyFollowing: Bool, birthdate: Date? = nil, middleName: String? = nil, address: String? = nil, gender: Gender = .unspecified) {
        self.name = name
        self.currentlyFollowing = currentlyFollowing
        self.birthdate = birthdate
        self.middleName = middleName
        self.address = address
        self.gender = gender
    }
    
    func followingChange() {
        self.currentlyFollowing = !self.currentlyFollowing
    }
}

