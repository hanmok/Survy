//
//  Section.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

public struct Section {
    
//    public init(surveyId: Int, numOfQuestions: Int) {
//        self.surveyId = surveyId
//        self.numOfQuestions = numOfQuestions
//    }
    
    public init(surveyId: Int, numOfQuestions: Int, sequence: Int = 0, title: String) {
        self.surveyId = surveyId
        self.sequence = sequence
        self.numOfQuestions = numOfQuestions
        self.title = title
    }
    
    public let sequence: Int
    public var id: Int?
    public let surveyId: Int
    public let expectedTimeInSec: Int = 5
    public let reward: Int = 100
    public var title: String = ""
    public let numOfQuestions: Int
    
    mutating public func setTitle(_ title: String) {
        self.title = title
    }
    
    mutating public func setId(_ id: Int) {
        self.id = id
    }
}
