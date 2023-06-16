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
    
    func setTargets(_ targets: [Target])
    func setTags(_ tags: [Tag])
    func setNumberOfSpecimens(_ num: Int)
    func addQuestion()
    func resetQuestions()
    
//    func updateQuestion(postingQuestion: PostingQuestion, index: Int, type: BriefQuestionType, questionText: String, numberOfOptions: Int)
    
    func setPostingQuestion(postingQuestion: PostingQuestion, index: Int)
}

class PostingService: PostingServiceType {
    
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
    
    
    // start from.. 0 ? 1 ?
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
    
    /// does noting for now (0616)
    func addQuestion() {
//        let index = self.numberOfQuestions + 1
        
        let postingQuestion = PostingQuestion(index: numberOfQuestions)
        postingQuestions.append(postingQuestion)
        print("current postingQuestion: \(postingQuestions.count)")
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

