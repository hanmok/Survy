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
    var numberOfQuestions: Int { get }
    
    var defaultMinimumCost: Int { get }
    var expectedTimeInMin: Int { get }
    var numberOfSpecimens: Int { get set }
    var totalCost: Int { get }
    
    func setTargets(_ targets: [Target])
    func setTags(_ tags: [Tag])
    func setNumberOfSpecimens(_ num: Int)
    func addQuestion()
}

class PostingService: PostingServiceType {
    
    var postingQuestions: [PostingQuestion] = []
    
    func addQuestion() {
        let index = self.numberOfQuestions + 1
        postingQuestions.append(PostingQuestion(index: index))
    }
    var defaultMinimumCost: Int { return 300 }
    var expectedTimeInMin: Int { return 2 }
    
    var numberOfSpecimens: Int = 100
    
    var totalCost: Int {
        return numberOfSpecimens * defaultMinimumCost * expectedTimeInMin
    }
    
    func setNumberOfSpecimens(_ num: Int) {
        self.numberOfSpecimens = num
    }
    
    var numberOfQuestions: Int {
        return postingQuestions.count
    }
    
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
    var question: String?
    
    var briefQuestionType: BriefQuestionType?
    var selectableOptions: [SelectableOption]
    
     init(index: Int, question: String = "", questionType: BriefQuestionType? = nil, selectableOptions: [SelectableOption] = []) {
        self.index = index
        self.question = question
        self.briefQuestionType = questionType
        self.selectableOptions = selectableOptions
    }
    
    init(question: String,
         index: Int,
         questionType: BriefQuestionType,
         selectableOptions: [SelectableOption]) {
        self.question = question
        self.index = index
        self.briefQuestionType = questionType
        self.selectableOptions = selectableOptions
    }
    
    public func updateQuestion(text: String) {
        self.question = text
    }
    
    public func addSelectableOption(selectableOption: SelectableOption) {
        print("type: \(type(of: self)), numOfSelectableOptions: \(self.selectableOptions.count)")
        self.selectableOptions.append(selectableOption)
    }
}
