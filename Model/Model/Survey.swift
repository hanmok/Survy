//
//  Survey.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation

public typealias SurveyId = Int
public typealias TagId = Int

public struct Survey: Hashable, Decodable {
    
    // API 호출 시 여기에서 생성되는게 아니구나?
    
    public init(id: Int,
                numOfParticipation: Int,
                participationGoal: Int,
                title: String,
                rewardRange: String?
    )
    {
        self.id = id
        self.title = title
        self.numOfParticipation = numOfParticipation
        self.participationGoal = participationGoal
        self.rewardRange = rewardRange
        print("survey init called")
    }
    
//    public mutating func setCategories(categories: [String]) {
    
    public mutating func setCategories(tags: [Tag]) {
        self.tags = tags
    }
    
    public mutating func appendTags(tag: Tag) {
        if self.tags == nil { // 아예 받아오지 않은 경우 아님?
            self.tags = []
        }
        guard self.tags != nil else { return }
        self.tags!.append(tag)
    }
    
    public let id: Int
    public let title: String
    public let numOfParticipation: Int
    public let participationGoal: Int
    public let rewardRange: String?
//    public var createdAt: Date? = nil
    
    // need to get from Survey-Tag API
    
    // FIXME: 처리하기..
    public var tags: [Tag]?
    
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case numOfParticipation
        case participationGoal
//        case createdAt = "created_at"
        case rewardRange = "reward_range"
        case tags
    }
}

extension Survey {
        public var participants: [Int] {
            return [self.numOfParticipation ?? 0, participationGoal ?? 1]
        }
        
        public var rewardString: String? {
        
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
