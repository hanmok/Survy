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
    var title: String? { get set }
    var editingCellIndex: Int? { get set }

    func refineSelectableOptionsOfPostingQuestions()
    func setTitle(_ title: String)
    func setParticipationGoal(participationGoal: Int)
    func setTargets(_ targets: [Target])
    func setGenres(_ genres: [Genre])
    func setNumberOfSpecimens(_ num: Int)
    func addQuestion()
    func resetQuestions()
    func setPostingQuestion(postingQuestion: PostingQuestion, index: Int)
    func setSurveyTitle(name: String)
    func setSections(_ sections: [Section])
}

class PostingService: PostingServiceType {
    
    var editingCellIndex: Int?
    
    var title: String?

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
    
    func setEditingCellIndex(_ index: Int) {
        self.editingCellIndex = index
    }
    func setSurveyTitle(name: String) {
        self.surveyTitle = name
    }
    
    func setTitle(_ title: String) {
        print("title set to \(title)")
        self.title = title
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
    
    func setGenres(_ genres: [Genre]) {
        selectedGenres = genres.sorted()
    }
}
