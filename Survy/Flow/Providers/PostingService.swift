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
    var selectedTags: [Tag] { get set }
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
    
    func setParticipationGoal(participationGoal: Int)
    func setTargets(_ targets: [Target])
    func setTags(_ tags: [Tag])
    func setNumberOfSpecimens(_ num: Int)
    func addQuestion()
    func resetQuestions()
    func setPostingQuestion(postingQuestion: PostingQuestion, index: Int)
    func setSurveyTitle(name: String)
    func setSections(_ sections: [Section])
}

class PostingService: PostingServiceType {
    var sections: [Section]?
    
    func setSections(_ sections: [Section]) {
        self.sections = sections
    }
    
    var participationGoal: Int?
    
    func setParticipationGoal(participationGoal: Int) {
        self.participationGoal = participationGoal
    }
    
    var surveyTitle: String?
    
    func setSurveyTitle(name: String) {
        self.surveyTitle = name
    }
    
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
    var selectedTags: [Tag] = []
    var hasCompletedQuestion: Bool {
        return postingQuestions.contains(where: { postingQuestion in
            postingQuestion.isCompleted == true
        })
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
    
    func resetQuestions() {
        postingQuestions = []
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
    
    func setTags(_ tags: [Tag]) {
        selectedTags = tags.sorted()
    }
}
