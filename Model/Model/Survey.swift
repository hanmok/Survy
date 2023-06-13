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
                title: String
//                ,rewardRange: String?
                ,categories: [String]?
    )
    {
        self.id = id
        self.title = title
        self.numOfParticipation = numOfParticipation
        self.participationGoal = participationGoal
//        self.rewardRange = rewardRange
        self.categories = ["테스트1", "테스트2"]
    }
    
    public let id: Int?
    public let title: String?
    public let numOfParticipation: Int?
    public let participationGoal: Int?
//    public var endedAt: Date? = nil
//    public var createdAt: Date? = nil
    
//    public let rewardRange: String?
    
    // need to get from Survey-Tag API
    public var categories: [String]?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case numOfParticipation
        case participationGoal
//        case endedAt = "ended_at"
//        case createdAt = "created_at"
//        case rewardRange = "reward_range"
        case categories
    }
}

extension Survey {
        public var participants: [Int] {
            return [self.numOfParticipation ?? 0, participationGoal ?? 1]
        }
        
//        public var rewardString: String? {
//            guard let rewardRange = rewardRange else { fatalError() }
//            if rewardRange.count == 1 {
//                return "\(rewardRange.first!)"
//            }
//            if let min = rewardRange.min(),
//               let max = rewardRange.max() {
//                return "\(min) ~ \(max)"
//            } else { return nil }
//        }
    
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
    public var surveys: [Survey]
//    var count: Int
}
