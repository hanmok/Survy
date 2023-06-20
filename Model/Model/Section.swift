//
//  Section.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

public struct Section {
    public init(surveyId: Int, numOfQuestions: Int) {
        self.surveyId = surveyId
        self.numOfQuestions = numOfQuestions
    }
    public let sequence: Int = 0
//    public let id: Int = Int.random(in: 0 ... 10000)
    public var id: Int?
    public let surveyId: Int
    public let expectedTimeInSec: Int = 5
    public let reward: Int = 100
    public let title: String = ""
    public let numOfQuestions: Int
    
    mutating public func setId(_ id: Int) {
        self.id = id
    }
}
