//
//  SurveyService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation
import Model
import API

protocol ParticipationServiceType: AnyObject {
    var currentSurvey: Survey? { get set }
    var currentSection: Section? { get set }
    var currentQuestion: Question? { get }
    var questionIndex: Int? { get set }
    var questionsToConduct: [Question]? { get set }
    var isLastQuestion: Bool { get }
    var selectedIndexes: Set<Int>? { get set }
    var selectedIndex: Int? { get set }
    var textAnswer: String? { get set }
    var allSurveys: [Survey] { get set }
    var allGenres: [Genre] { get set }
    var surveysToShow: [Survey] { get }
    var selectedGenres: Set<Int> { get set }
    
    func moveToNextQuestion()
    func initializeSurvey()
}

class ParticipationService: ParticipationServiceType {
    var allGenres = [Genre]()
    
    var selectedIndexes: Set<Int>?

    var selectedIndex: Int?
    
    var textAnswer: String?
    
    var allSurveys: [Survey] = []
    
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
    var percengenree: CGFloat? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return 0 }
        return CGFloat(questionIndex) / CGFloat(questionsToConduct.count)
    }
    
    var selectedGenres = Set<Int>() // Genre Id
    
    var surveysToShow: [Survey] {
        return allSurveys
        
        if selectedGenres.isEmpty == true {
            var ret = [Survey]()
            for survey in allSurveys {
                if let surveyGenres = survey.genres {
                    let something = surveyGenres.map { $0.id }
                    let some = Set(UserDefaults.standard.myGenres.map { $0.id})
                    if some.intersection(something).isEmpty == false {
                        ret.append(survey)
                    }
                    
//                    if Set(UserDefaults.standard.myGenres.map { $0.name}).intersection(something).isEmpty == false {
//                        ret.append(survey)
//                    }
                    
                }
            }
            return ret
        } else {
            return allSurveys.filter {
                guard let validGenres = $0.genres else { fatalError() }
                let genreSet = Set(validGenres.map { $0.id })
                return genreSet.intersection(selectedGenres).isEmpty == false
            }
        }
    }
}
