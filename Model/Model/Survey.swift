//
//  Survey.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation


public struct Survey: Hashable, Decodable {
    public init(id: Int,
                numOfParticipation: Int,
                participationGoal: Int,
                title: String,
                rewardRange: [Int]?
                ,categories: [String]?
    )
    {
        self.id = id
        self.numOfParticipation = numOfParticipation
        self.participationGoal = participationGoal
        self.title = title
        self.rewardRange = rewardRange ?? [0, 100]
        self.categories = ["테스트1", "테스트2"]
//        self.participants = [0, participationGoal]
    }
    
    public let id: Int
    public let numOfParticipation: Int
    public let participationGoal: Int
//    public let ended_at: Date? = nil
    public let title: String
    public let rewardRange: [Int]?
    
    // need to get from Survey-Tag API
    public var categories: [String]?
    
//    public var participants: [Int] {
//        return [self.numOfParticipation, participationGoal]
//    }
    
//    public var rewardString: String? {
//        if rewardRange.count == 1 {
//            return "\(rewardRange.first!)"
//        }
//        if let min = rewardRange.min(),
//           let max = rewardRange.max() {
//            return "\(min) ~ \(max)"
//        } else { return nil }
//    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case numOfParticipation
        case participationGoal
        case title
        case rewardRange = "reward_range"
        case categories
    }
//    }
}

extension Survey {
    
        public var participants: [Int] {
            return [self.numOfParticipation, participationGoal]
        }
        
        public var rewardString: String? {
//            rewardRange = [0, 100]
            guard let rewardRange = rewardRange else { fatalError() }
            if rewardRange.count == 1 {
                return "\(rewardRange.first!)"
            }
            if let min = rewardRange.min(),
               let max = rewardRange.max() {
                return "\(min) ~ \(max)"
            } else { return nil }
        }
    
//    public func getRewardString() -> String? {
//        if rewardRange.count == 1 {
//            return "\(rewardRange.first!)"
//        }
//        if let min = rewardRange.min(),
//           let max = rewardRange.max() {
//            return "\(min) ~ \(max)"
//        } else { return nil }
//    }
}


public struct SurveyResponse: Decodable {
    var surveys: [Survey]
    var count: Int
}
