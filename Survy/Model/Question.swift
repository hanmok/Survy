//
//  Question.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

struct Question {
    let id: Int
    let questionTypeId: Int
    let sectionId: Int
    let position: Int
    let text: String
    let expectedTimeInSec: Int
    let correctAnswer: Int? // references selectableOption
}


