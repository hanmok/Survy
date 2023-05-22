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
    var numberOfQuestions: Int { get set }
    
    
    func setTargets(_ targets: [Target])
    func setTags(_ tags: [Tag])
    func setNumberOfSpecimens(_ num: Int)
    func addQuestion()
    func resetQuestions()
    func updateQuestion(postingQuestion: PostingQuestion, index: Int, type: BriefQuestionType, questionText: String, numberOfOptions: Int)
}

class PostingService: PostingServiceType {
   
    var postingQuestions: [PostingQuestion] = []
    
    func updateQuestion(postingQuestion: PostingQuestion, index: Int, type: BriefQuestionType, questionText: String = "", numberOfOptions: Int) {
        
        if postingQuestions.count > index {
            postingQuestions[index] = postingQuestion
        } else {
            let newPostingQuestion = PostingQuestion(index: index, question: questionText, questionType: type, numberOfOptions: numberOfOptions)
            
            postingQuestions.append(PostingQuestion(index: index, question: questionText, questionType: type, numberOfOptions: numberOfOptions))
        }
    }
    
    func resetQuestions() {
        postingQuestions = []
    }
    
    func addQuestion() {
//        let index = self.numberOfQuestions + 1
    }
    
    var numberOfQuestions: Int = 1
    
    var defaultMinimumCost: Int { return 300 }
    var expectedTimeInMin: Int { return 2 }
    
    var numberOfSpecimens: Int = 100
    
    var totalCost: Int {
        return numberOfSpecimens * defaultMinimumCost * expectedTimeInMin
    }
    
    func setNumberOfSpecimens(_ num: Int) {
        self.numberOfSpecimens = num
    }
    
//    var numberOfQuestions: Int {
//        return postingQuestions.count
//    }
    
    var selectedTargets: [Target] = []
    var selectedTags: [Tag] = []
    
    func setTargets(_ targets: [Target]) {
        selectedTargets = targets.sorted()
    }
    
    func setTags(_ tags: [Tag]) {
        selectedTags = tags.sorted()
    }
}

public class PostingQuestion {
    var index: Int
    var question: String
    var numberOfOptions: Int {
        didSet {
            guard selectableOptions.isEmpty else { fatalError() }
            for i in 1 ..< numberOfOptions {
                selectableOptions.append(SelectableOption(position: i))
            }
        }
    }
    
    var briefQuestionType: BriefQuestionType
    var selectableOptions: [SelectableOption] = []
    
    init(index: Int, question: String = "", questionType: BriefQuestionType, numberOfOptions: Int) {
        self.index = index
        self.question = question
        self.briefQuestionType = questionType
        self.numberOfOptions = numberOfOptions
    }
    
    public func addSelectableOption(selectableOption: SelectableOption) {
        print("type: \(type(of: self)), numOfSelectableOptions: \(self.selectableOptions.count)")
        self.selectableOptions.append(selectableOption)
    }
}
