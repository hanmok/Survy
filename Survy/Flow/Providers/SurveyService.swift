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
    var isLastQuestion: Bool { get }
    func moveToNextQuestion()
    func initializeSurvey()
}

class SurveyService: SurveyServiceType {
    func initializeSurvey() {
        currentSurvey = nil
        currentSection = nil
        questionIndex = nil
        questionsToConduct = nil
    }
    var currentSurvey: Survey?
    var currentSection: Section?
    var currentQuestion: Question? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return nil }
        if questionsToConduct.count != questionIndex {
            return questionsToConduct[questionIndex]
        }
        return nil
    }
    
    var isLastQuestion: Bool {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return false }
        return questionsToConduct.count - 1 == questionIndex
    }
    
    var questionsToConduct: [Question]?
    
    func moveToNextQuestion() {
        if questionIndex != nil {
            questionIndex! += 1
        } else {
            questionIndex = 0
        }
    }
    var questionIndex: Int?
    var percentage: CGFloat? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return 0 }
        return CGFloat(questionIndex) / CGFloat(questionsToConduct.count)
    }
}
