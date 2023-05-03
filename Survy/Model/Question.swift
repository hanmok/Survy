//
//  Question.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

struct Question {
    let id: Int
//    let questionTypeId: Int
    let questionType: QuestionType
    let sectionId: Int
    let position: Int
    let text: String
    let expectedTimeInSec: Int
    let selectableOptions: [SelectableOption]
    let correctAnswer: Int? // references selectableOption
//    let
}


struct Section {
    let id: Int = Int.random(in: 0 ... 10000)
    let surveyId: Int
    let expectedTimeInSec: Int = 5
    let reward: Int = 100
    let title: String = ""
    let numOfQuestions: Int
}


