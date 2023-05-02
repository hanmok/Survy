//
//  Survey.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation


struct Survey {
    let id: Int
    let numOfParticipation: Int
    let participationGoal: Int
    let ended_at: Date? = nil
    let title: String
    let rewardRange: [Int]
    
    // need to get from Survey-Tag API
    var categories: [String]
    
    var participants: [Int] {
        return [self.numOfParticipation, participationGoal]
    }
    
    var rewardString: String? {
        if rewardRange.count == 1 {
            return "\(rewardRange.first!)"
        }
        if let min = rewardRange.min(),
           let max = rewardRange.max() {
            return "\(min) ~ \(max)"
        } else { return nil }
    }
}
