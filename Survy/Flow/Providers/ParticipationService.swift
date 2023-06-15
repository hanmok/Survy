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
    var allTags: [Tag] { get set }
    var surveysToShow: [Survey] { get }
    var selectedCategories: Set<Int> { get set }
    
    func moveToNextQuestion()
    func initializeSurvey()
    func toggleCategory(_ categoryId: Int)
    func getSurveys(completion: @escaping () -> Void)
    func getTags(completion: @escaping () -> Void)
}

class ParticipationService: ParticipationServiceType {
    var allTags = [Tag]()
    
    var selectedIndexes: Set<Int>?

    var selectedIndex: Int?
    
    func toggleCategory(_ categoryId: Int) {
        selectedCategories.toggle(categoryId)
    }
    
    func getSurveys(completion: @escaping () -> Void) {
        APIService.shared.getAllSurveys { surveys in
            guard let surveys = surveys else { return }
            self.allSurveys = surveys
            completion()
        }
    }
    
    func getTags(completion: @escaping () -> Void) {
        APIService.shared.getAllTags { tags in
            guard let tags = tags else { return }
            self.allTags = tags
            completion()
        }
    }
    
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
    var percentage: CGFloat? {
        guard let questionsToConduct = questionsToConduct, let questionIndex = questionIndex else { return 0 }
        return CGFloat(questionIndex) / CGFloat(questionsToConduct.count)
    }
    
    var selectedCategories = Set<Int>() // Tag Id
    
    var surveysToShow: [Survey] {
        return allSurveys
        
        if selectedCategories.isEmpty == true {
            var ret = [Survey]()
            for survey in allSurveys {
                if let surveyCategories = survey.tags {
                    let something = surveyCategories.map { $0.id }
                    if UserDefaults.standard.lastSelectedCategoriesSet.intersection(something).isEmpty == false {
                        ret.append(survey)
                    }
                }
            }
            return ret
        } else {
            return allSurveys.filter {
                guard let validCategories = $0.tags else { fatalError() }
                let categorySet = Set(validCategories.map { $0.id })
                return categorySet.intersection(selectedCategories).isEmpty == false
            }
        }
    }
}
