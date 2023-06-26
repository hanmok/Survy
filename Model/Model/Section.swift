//
//  Section.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

public struct Section: Decodable {
    public init(title: String, sequence: Int = 0) {
        self.title = title
        self.sequence = sequence
    }
    
    public enum CodingKeys: String, CodingKey {
        case title
        case sequence
        case id
        case surveyId = "survey_id"
        case expectedTimeInSec
        case reward
    }
    
    public var title: String = ""
    public let sequence: Int
    public var id: Int? = nil
    public var surveyId: Int? = nil
    public let expectedTimeInSec: Int = 5
    public let reward: Int = 100
    
    public var postingQuestions: [PostingQuestion]?
    public var questions: [Question]?
    
    mutating public func setQuestions(_ questions: [Question]) {
        self.questions = questions
    }
    mutating public func setTitle(_ title: String) {
        self.title = title
    }
    
    mutating public func setId(_ id: Int) {
        self.id = id
    }
}
