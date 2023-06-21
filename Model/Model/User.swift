//
//  User.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

public struct User {
    public init(id: Int, username: String, collectedReward: Int, fatigue: Int, creditAmount: Int, deviceToken: String, age: Int, isMale: Bool, nickname: String) {
        self.id = id
        self.username = username
        self.collectedReward = collectedReward
        self.fatigue = fatigue
        self.creditAmount = creditAmount
        self.deviceToken = deviceToken
        self.age = age
        self.isMale = isMale
        self.nickname = nickname
    }
    
    public let id: Int
    public let username: String
    public let collectedReward: Int
    public let fatigue: Int
    public let creditAmount: Int
    public let deviceToken: String
    public let age: Int
    public let isMale: Bool
    public let nickname: String
    public let genres: [String] = []
}
