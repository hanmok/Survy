//
//  PostingServiceType.swift
//  Survy
//
//  Created by Mac mini on 2023/05/16.
//

import Foundation
import Model

protocol PostingServiceType: AnyObject {
    var selectedTargets: [Target] { get set }
    var selectedGenres: [Genre] { get set }
    var postingQuestions: [PostingQuestion] { get set }
    var defaultMinimumCost: Int { get }
    var expectedTimeInMin: Int { get }
    var numberOfSpecimens: Int { get set }
    var totalCost: Int { get }
    var numberOfQuestions: Int { get }
    var hasCompletedQuestion: Bool { get }
    var surveyTitle: String? { get set }
    var participationGoal: Int? { get set }
    var sections: [Section]? { get set }

    func refineSelectableOptionsOfPostingQuestions()
    func setSurveyTitle(_ surveyTitle: String)
    func setParticipationGoal(participationGoal: Int)
    func setTargets(_ targets: [Target])
    func setGenres(_ genres: [Genre])
    func setNumberOfSpecimens(_ num: Int)
    func addQuestion()
    func setPostingQuestion(postingQuestion: PostingQuestion, index: Int)
    func setSections(_ sections: [Section])
    func reset()
}

class PostingService: PostingServiceType {
    var sections: [Section]?
    var participationGoal: Int?
    var surveyTitle: String?
    var postingQuestions: [PostingQuestion] = []
    var numberOfQuestions: Int {
        return postingQuestions.count
    }
    var defaultMinimumCost: Int { return 300 }
    var expectedTimeInMin: Int { return 2 }
    var numberOfSpecimens: Int = 100
    var totalCost: Int {
        return numberOfSpecimens * defaultMinimumCost * expectedTimeInMin
    }
    var selectedTargets: [Target] = []
    var selectedGenres: [Genre] = []
    var hasCompletedQuestion: Bool {
        return postingQuestions.contains(where: { postingQuestion in
            postingQuestion.isCompleted == true
        })
    }
    
    func setSurveyTitle(_ surveyTitle: String) {
        print("title set to \(surveyTitle)")
        self.surveyTitle = surveyTitle
    }
    
    func setSections(_ sections: [Section]) {
        self.sections = sections
    }
    
    func setParticipationGoal(participationGoal: Int) {
        self.participationGoal = participationGoal
    }
    
    /// start from 0
    func setPostingQuestion(postingQuestion: PostingQuestion, index: Int) {
        print("setPostingQuestion called, index: \(index), numberOfPostingQuestions: \(self.postingQuestions.count)")
        
        if self.postingQuestions.count > index {
            self.postingQuestions[index] = postingQuestion
        } else {
            self.postingQuestions.append(postingQuestion)
        }
    }
    
    func refineSelectableOptionsOfPostingQuestions() {
        var postingQuestions = self.postingQuestions
        for questionIdx in postingQuestions.indices {
            postingQuestions[questionIdx].removeUnnecessarySelectableOptions()
        }
        self.postingQuestions = postingQuestions
    }
    
    func reset() {
        sections = nil
        participationGoal = nil
        surveyTitle = nil
        postingQuestions = []
        selectedTargets = []
        selectedGenres = []
    }
    
    func addQuestion() {
        let postingQuestion = PostingQuestion(index: numberOfQuestions)
        postingQuestions.append(postingQuestion)
    }
    
    func setNumberOfSpecimens(_ num: Int) {
        self.numberOfSpecimens = num
    }
    
    func setTargets(_ targets: [Target]) {
        selectedTargets = targets.sorted()
    }
    
    func setGenres(_ genres: [Genre]) {
        selectedGenres = genres.sorted()
    }
}
