//
//  PostingQuestion.swift
//  Model
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation

public class PostingQuestion {
    // 음.. briefQuestionType 없을 수도 있음. 처음 생겼는데 있는게 더 이상함.
    public init(index: Int, question: String = "", briefQuestionType: BriefQuestionType) {
        self.index = index
        self.question = question
        self.briefQuestionType = briefQuestionType
    }
    
    public init(index: Int) {
        self.index = index
    }
    
    public var index: Int
    public var question: String?
    
    public var numberOfOptions: Int {
        return selectableOptions.count
    }
    public var briefQuestionType: BriefQuestionType?
    public var selectableOptions: [SelectableOption] = []
    
    public func modifySelectableOption(index: Int, selectableOption: SelectableOption) {
        if selectableOptions.count > index {
            self.selectableOptions[index] = selectableOption
        } else {
            let numberOfCurrentOptions = self.selectableOptions.count
            print("modifyCalled, adding \(numberOfCurrentOptions), count: \(selectableOptions.count), index: \(index)")
            self.selectableOptions.append(SelectableOption(postion: numberOfCurrentOptions))
        }
    }
    
    public func removeSelectableOptions() {
        self.selectableOptions.removeAll()
        
    }
    
    public func modifyQuestionType(briefQuestionType: BriefQuestionType) {
        self.briefQuestionType = briefQuestionType
    }
    
    public func updateQuestionText(questionText: String) {
        self.question = questionText
    }
    
    public func addSelectableOption(selectableOption: SelectableOption) {
        self.selectableOptions.append(selectableOption)
        print("addSelectableOption called, current number of options: \(self.selectableOptions.count)")
    }
}
