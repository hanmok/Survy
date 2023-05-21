//
//  SurveyService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation
import Model

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
    
    var availableSurveys: [Survey] { get }
    var surveysToShow: [Survey] { get }
    var selectedCategories: Set<String> { get set }

    func moveToNextQuestion()
    func initializeSurvey()
    func postAnswer()
    func toggleCategory(_ category: String)
}

class ParticipationService: ParticipationServiceType {
    var selectedIndexes: Set<Int>?

    var selectedIndex: Int?
    func toggleCategory(_ category: String) {
        selectedCategories.toggle(category)
    }
    var textAnswer: String?
    
    func postAnswer() {
        
    }
    
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
    
    // Test Data
    var availableSurveys:[Survey] {
        return [
            Survey(id: 1, numOfParticipation: 153, participationGoal: 200, title: "체형 교정 운동을 추천해주세요", rewardRange: [100], categories: ["운동"]),
            
            Survey(id: 2, numOfParticipation: 273, participationGoal: 385, title: "애견인과 비애견인의 동물 관련 음식 소비패턴에 대한 조사입니다. 참여 부탁드려요!", rewardRange: [500], categories: ["애견", "음식"]),
            
            Survey(id: 3, numOfParticipation: 132, participationGoal: 1000, title: "다이어트 운동, 약물에 대한 간단한 통계 조사입니다.", rewardRange: [100], categories: ["운동", "다이어트"]),
            
            Survey(id: 4, numOfParticipation: 153, participationGoal: 200, title: "체형 교정 운동을 추천해주세요", rewardRange: [100], categories: ["운동"]),
            
            Survey(id: 5, numOfParticipation: 273, participationGoal: 385, title: "애견인과 비애견인의 동물 관련 음식 소비패턴에 대한 조사입니다. 참여 부탁드려요!", rewardRange: [500], categories: ["애견", "음식"]),
            
            Survey(id: 6, numOfParticipation: 132, participationGoal: 1000, title: "다이어트 운동, 약물에 대한 간단한 통계 조사입니다.", rewardRange: [100], categories: ["운동", "다이어트"])
            
            
        ]
    }
    
    var selectedCategories = Set<String>()
    
    var surveysToShow: [Survey] {
        if selectedCategories.isEmpty == true {
            return availableSurveys
        } else {
            return availableSurveys.filter {
                let categories = Set($0.categories)
                return categories.intersection(selectedCategories).isEmpty == false
            }
        }
    }
}
