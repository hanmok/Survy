//
//  User.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let collectedReward: Int
    let fatigue: Int
    let creditAmount: Int
    let deviceToken: String
    let age: Int
    let isMale: Bool
    let nickname: String
    
    let categories: [String] = []
}
