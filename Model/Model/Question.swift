//
//  Question.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

public struct Question: Decodable {
    public init(id: Int,
                questionTypeId: Int,
                sectionId: Int,
                position: Int,
                text: String,
                expectedTimeInSec: Int
    ) {
        self.id = id
        self.questionTypeId = questionTypeId
        self.sectionId = sectionId
        self.position = position
        self.text = text
        self.expectedTimeInSec = expectedTimeInSec
//        self.parentSection = nil
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case questionTypeId = "questionType_id"
        case sectionId = "section_id"
        case position
        case text
        case expectedTimeInSec
    }
    
    public mutating func setSelectableOptions(_ selectableOptions: [SelectableOption]) {
        self.selectableOptions = selectableOptions
    }
    
    public var id: Int
    public var questionTypeId: Int
    public var sectionId: Int
    public var position: Int
    public var text: String
    public var expectedTimeInSec: Int
    
    public var questionType: BriefQuestionType?
    public var selectableOptions: [SelectableOption]?
    public var parentSection: Section?
}
