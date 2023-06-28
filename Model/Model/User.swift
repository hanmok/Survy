//
//  User.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

public struct User: Decodable {
    public init(id: Int,
                username: String,
                collectedReward: Int,
                fatigue: Int,
                deviceToken: String,
                isMale: Int,
                nickname: String) {
        self.id = id
        self.username = username
        self.collectedReward = collectedReward
        self.fatigue = fatigue
        self.deviceToken = deviceToken
        self.isMale = isMale
        self.nickname = nickname
    }
    
    public var id: Int
    public var collectedReward: Int
    public var fatigue: Int
    public var birthDate: Date?
    public var nickname: String?
    public var isMale: Int
    public var deviceToken: String?
    public var username: String
}
