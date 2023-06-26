//
//  PostingQuestion.swift
//  Model
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation

public class PostingQuestion {
    
    public init(index: Int) {
        self.index = index
    }
    
    public var index: Int
    public var questionText: String?
    
    public var numberOfOptions: Int {
        return selectableOptions.count
    }
    
    public var sectionId: Int?
    
    public var isCompleted: Bool {
        print("questionText: \(questionText)")
        if questionText != nil,
           questionText != String.longerPlaceholder,
           briefQuestionType != nil,
           let first = selectableOptions.first,
           first.value != nil
            || first.placeHolder != nil
        {
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
    
    public func setSectionId(_ sectionId: Int) {
        self.sectionId = sectionId
    }
    
    // 음.. 아무것도 없는 경우에도 호출됨. 왜지 ??
    public func removeUnnecessarySelectableOptions() {
        let numberOfSelectableOptions = selectableOptions.count
        print("0623 flag 2, numberofSelectableOptions: \(numberOfSelectableOptions)")
        
        if numberOfSelectableOptions != 1 {
            for idx in 0 ..< numberOfSelectableOptions {
                let selectableOption = selectableOptions[numberOfSelectableOptions - idx - 1]
                print("currentSelectableOption: \(selectableOption)")
                
                if selectableOptions[numberOfSelectableOptions - idx - 1].value == nil {
                    selectableOptions.remove(at: numberOfSelectableOptions - idx - 1)
                }
            }
        }
    }
    
    public func updateSelectableOption(index: Int, selectableOption: SelectableOption) {
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
    
    public func updateQuestionType(briefQuestionType: BriefQuestionType) {
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
