//
//  Question.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

public struct Question {
    public init(id: Int, questionType: QuestionType, sectionId: Int, position: Int, text: String, expectedTimeInSec: Int, selectableOptions: [SelectableOption], correctAnswer: Int? = nil) {
        self.id = id
        self.questionType = questionType
        self.sectionId = sectionId
        self.position = position
        self.text = text
        self.expectedTimeInSec = expectedTimeInSec
        self.selectableOptions = selectableOptions
        self.correctAnswer = correctAnswer
        self.parentSection = nil
    }
    
    public let id: Int
    public let questionType: QuestionType
    public let sectionId: Int
    public let position: Int
    public let text: String
    public let expectedTimeInSec: Int
    public let selectableOptions: [SelectableOption]
    public let correctAnswer: Int? // references selectableOption
    public let parentSection: Section?
}
