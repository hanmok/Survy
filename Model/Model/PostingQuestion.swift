//
//  PostingQuestion.swift
//  Model
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation

// FIXME: 왜 이건 Class야..?
public class PostingQuestion {
    
    public init(index: Int) {
        self.index = index
    }
    
    public var index: Int
    public var questionText: String?
    
    public var numberOfOptions: Int {
        return selectableOptions.count
    }
    
    public func setSectionId(_ sectionId: Int) {
        self.sectionId = sectionId
    }
    
    public func removeUnnecessarySelectableOptions() {

        let numOfSelectableOptions = selectableOptions.count
        
        for idx in 0 ..< numOfSelectableOptions {
            if selectableOptions[numOfSelectableOptions - idx - 1].value == nil {
                selectableOptions.remove(at: numOfSelectableOptions - idx - 1)
            }
        }
    }
    
    public var sectionId: Int?
    
    public var isCompleted: Bool {
        if questionText != nil,
            briefQuestionType != nil,
            let first = selectableOptions.first,
            first.value != nil || first.placeHolder != nil {
            print("isCompleted changed to true")
            return true
        }
        print("isCompleted is false")
        return false
    }
    
    /// QuestionTypeId
    public var briefQuestionType: BriefQuestionType? {
        didSet {
            print("briefQuestionType set to \(briefQuestionType)")
        }
    }
    
    public var selectableOptions: [SelectableOption] = []
    
    public func modifySelectableOption(index: Int, selectableOption: SelectableOption) {
        if selectableOptions.count > index {
            self.selectableOptions[index] = selectableOption
        } else {
            let numberOfCurrentOptions = self.selectableOptions.count
            print("modifyCalled, adding \(numberOfCurrentOptions), count: \(selectableOptions.count), index: \(index)")
            self.selectableOptions.append(SelectableOption(position: numberOfCurrentOptions))
        }
    }
    
    public func removeSelectableOptions() {
        self.selectableOptions.removeAll()
    }
    
    public func modifyQuestionType(briefQuestionType: BriefQuestionType) {
        self.briefQuestionType = briefQuestionType
    }
    
    public func updateQuestionText(questionText: String) {
        self.questionText = questionText
    }
    
    public func addSelectableOption(selectableOption: SelectableOption) {
        self.selectableOptions.append(selectableOption)
        print("addSelectableOption called, current number of options: \(self.selectableOptions.count)")
    }
}
