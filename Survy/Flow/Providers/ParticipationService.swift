//
//  SurveyService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation
import Model
import API

enum QuestionProgressIndex {
    case undefined
    case inProgress(Int)
    case ended
}

protocol ParticipationServiceType: AnyObject {
    var currentSurvey: Survey? { get set }
    var currentSection: Section? { get set }
    var currentQuestion: Question? { get }
    var questionProgress: QuestionProgressIndex { get set }
    var questionsToConduct: [Question]? { get set }
    var isLastQuestion: Bool { get }
    var selectedIndexes: Set<Int>? { get set }
    var selectedIndex: Int? { get set }
    var textAnswer: String? { get set }
    var allSurveys: [Survey] { get set }
    var allGenres: [Genre] { get set }
    var surveysToShow: [Survey] { get }
    var selectedGenres: Set<Int> { get set }
    var numberOfQuestions: Int? { get }
    var sections: [Section]? { get set }

    func increaseQuestionIndex()
    func resetSurvey()
    func setSections(_ sections: [Section])
    func startSurvey()
    func setQuestions(_ questions: [Question])
}

class ParticipationService: ParticipationServiceType {
    
    func setQuestions(_ questions: [Question]) {
        self.questionsToConduct = questions
    }
    var sections: [Section]?
    
    func setSections(_ sections: [Section]) {
        self.sections = sections
    }
    var questionProgress: QuestionProgressIndex = .undefined

    var allGenres = [Genre]()
    
    var selectedIndexes: Set<Int>?

    var selectedIndex: Int?
    
    var textAnswer: String?
    
    var allSurveys: [Survey] = []
    
    func resetSurvey() {
        currentSurvey = nil
        currentSection = nil
        questionsToConduct = nil
        questionProgress = .undefined
//        questionProgress = .inProgress(0)
    }
    
    func startSurvey() {
        questionProgress = .inProgress(0)
    }
    
    var currentSurvey: Survey?
    var currentSection: Section?
    var currentQuestion: Question? {
        guard let questionsToConduct = questionsToConduct else { return nil }
        switch questionProgress {
            case .undefined:
                return nil
            case .inProgress(let questionIndex):
                return questionsToConduct[questionIndex]
            case .ended:
                return nil
        }
    }
    
    var isLastQuestion: Bool {
        guard let questionsToConduct = questionsToConduct else { return false }
        switch questionProgress {
            case .undefined:
                return false
            case .inProgress(let questionIdx):
                return questionIdx == questionsToConduct.count - 1
            case .ended:
                return false
        }
    }
    
    var questionsToConduct: [Question]?
    var numberOfQuestions: Int? {
        if let questionsToConduct = questionsToConduct {
            return questionsToConduct.count
        }
        return 0
    }
    
    func increaseQuestionIndex() {
        switch questionProgress {
            case .undefined:
                questionProgress = .inProgress(0)
            case .inProgress(let idx):
                guard let numberOfQuestions = numberOfQuestions else { return }
                if numberOfQuestions - 1 != idx {
                    questionProgress = .inProgress(idx + 1)
                } else {
                    questionProgress = .ended
                }
            case .ended:
                questionProgress = .undefined
        }
        
        print("current questionProgress: \(questionProgress)")
        // ended 로 잘 되는데 ?
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
