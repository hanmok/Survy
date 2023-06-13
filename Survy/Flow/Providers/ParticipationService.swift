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
    var surveysToShow: [Survey] { get }
    var selectedCategories: Set<String> { get set }

    func moveToNextQuestion()
    func initializeSurvey()
    func postAnswer()
    func toggleCategory(_ category: String)
    func getSurveys(completion: @escaping () -> Void)
}

class ParticipationService: ParticipationServiceType {
    
    var selectedIndexes: Set<Int>?

    var selectedIndex: Int?
    
    func toggleCategory(_ category: String) {
        selectedCategories.toggle(category)
    }
    
    func getSurveys(completion: @escaping () -> Void) {
        APIService.shared.getAllSurveys { surveys in
            guard var surveys = surveys else { return }
            var newSurveys = [Survey]()
            
            surveys.forEach {
                var newSurvey = $0
                newSurvey.setCategories(categories: ["일반"])
                newSurveys.append(newSurvey)
            }
            
            print("allSurveys: \(surveys)")
            self.allSurveys = newSurveys
            completion()
        }
    }
    
    var textAnswer: String?
    
    func postAnswer() {
        
    }
    
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
    var percentage: CGFloat? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return 0 }
        return CGFloat(questionIndex) / CGFloat(questionsToConduct.count)
    }
    
    var selectedCategories = Set<String>()
    
    var surveysToShow: [Survey] {
        if selectedCategories.isEmpty == true {
            var ret = [Survey]()
            
            for survey in allSurveys {
                if let surveyCategories = survey.categories {
                    if UserDefaults.standard.lastSelectedCategoriesSet.intersection(surveyCategories).isEmpty == false {
                        ret.append(survey)
                    }
                } else {
                    fatalError()
                }
            }
            return ret
        } else {
            return allSurveys.filter {
                guard let validCategories = $0.categories else { fatalError() }
                let categorySet = Set(validCategories)
                return categorySet.intersection(selectedCategories).isEmpty == false
            }
        }
    }
}
