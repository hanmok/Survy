//
//  Survey.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation


public struct Survey: Hashable, Decodable {
    
    // API 호출 시 여기에서 생성되는게 아니구나?
    
    public init(id: Int,
                numOfParticipation: Int,
                participationGoal: Int,
                title: String,
                rewardRange: String?,
                categories: [String]?
    )
    {
        self.id = id
        self.title = title
        self.numOfParticipation = numOfParticipation
        self.participationGoal = participationGoal
        self.rewardRange = rewardRange
        self.categories = ["운동", "테스트2"]
        print("survey init called")
    }
    
    public mutating func setCategories(categories: [String]) {
        self.categories = categories
    }
    
    public let id: Int
    public let title: String
    public let numOfParticipation: Int
    public let participationGoal: Int
    public let rewardRange: String?
//    public var createdAt: Date? = nil
    
    // need to get from Survey-Tag API
    
    // FIXME: 처리하기..
    public var categories: [String]? = ["운동", "애견"]
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case numOfParticipation
        case participationGoal
//        case createdAt = "created_at"
        case rewardRange = "reward_range"
        case categories
    }
}

extension Survey {
        public var participants: [Int] {
            return [self.numOfParticipation ?? 0, participationGoal ?? 1]
        }
        
        public var rewardString: String? {
//            let rewardRange = rewardRange ?? "100"
//
////            guard let components = rewardRange.split(separator: ","), components.count <= 2 else { return }
//
////            switch components.count {
////                case
////            }
//
//
//
//            if rewardRange.count == 1 {
//                return "\(rewardRange.first!)"
//            }
//            if let min = rewardRange.min(),
//               let max = rewardRange.max() {
//                return "\(min) ~ \(max)"
//            } else { return nil }
            
            
            guard let rewardRange = rewardRange else { return nil }
            return separateRange(rewardRange)
        }
    
    func separateRange(_ range: String) -> String {
        
        let components = range.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        guard components.count <= 2 else { fatalError() }
                
        switch components.count {
            case 1:
                if components[0] == "0" { return "Free" }
                return String(components[0])
            case 2:
                return "\(components[0]) ~ \(components[1])"
            default:
                fatalError()
        }
    }
}


public struct SurveyResponse: Decodable {
    public var surveys: [Survey]
//    var count: Int
}
