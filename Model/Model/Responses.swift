//
//  Responses.swift
//  Model
//
//  Created by Mac mini on 2023/06/23.
//

import Foundation

public struct SurveyResponse: Decodable {
    public var surveys: [Survey]
}

public struct SectionResponse: Decodable {
    public var sections: [Section]
}

public struct QuestionResponse: Decodable {
    public var questions: [Question]
}

public struct PostResponse: Decodable {
    public var message: String
    public var id: Int
}


public struct SelectableOptionResponse: Decodable {
    public var selectableOptions: [SelectableOption]
}
