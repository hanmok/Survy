//
//  SurveyService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation
import Model

protocol SurveyServiceType: AnyObject {
    var currentSurvey: Survey? { get set }
    var currentSection: Section? { get set }
    var currentQuestion: Question? { get }
    var questionIndex: Int? { get set }
    var questionsToConduct: [Question]? { get set }
}

class SurveyService: SurveyServiceType {
    var currentSurvey: Survey?
    var currentSection: Section?
    
    var currentQuestion: Question? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return nil }
        return questionsToConduct[questionIndex]
    }
    
    var questionsToConduct: [Question]?
    
    var questionIndex: Int?
    var percentage: CGFloat? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return 0 }
        return CGFloat(questionIndex) / CGFloat(questionsToConduct.count)
    }
}
