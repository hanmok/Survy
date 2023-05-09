//
//  Survey.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation


public struct Survey: Hashable {
    public init(id: Int, numOfParticipation: Int, participationGoal: Int, title: String, rewardRange: [Int], categories: [String]) {
        self.id = id
        self.numOfParticipation = numOfParticipation
        self.participationGoal = participationGoal
        self.title = title
        self.rewardRange = rewardRange
        self.categories = categories
    }
    
    public let id: Int
    public let numOfParticipation: Int
    public let participationGoal: Int
    public let ended_at: Date? = nil
    public let title: String
    public let rewardRange: [Int]
    
    // need to get from Survey-Tag API
    public var categories: [String]
    
    public var participants: [Int] {
        return [self.numOfParticipation, participationGoal]
    }
    
    public var rewardString: String? {
        if rewardRange.count == 1 {
            return "\(rewardRange.first!)"
        }
        if let min = rewardRange.min(),
           let max = rewardRange.max() {
            return "\(min) ~ \(max)"
        } else { return nil }
    }
}
