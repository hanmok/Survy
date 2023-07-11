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

public struct UserResponse: Decodable {
    public var user: User
    public var accessToken: String?
    public var refreshToken: String?
}

public enum CustomError: Error {
    case logout(String?)
    case response(String?)
}

public struct MessageResponse: Decodable {
    public var message: String
}

public struct SelectableOptionResponse: Decodable {
    public var selectableOptions: [SelectableOption]
}

public struct ParticipateResponse: Decodable {
    public var message: String
    public var userId: Int
    public var surveyId: Int
    
    public enum CodingKeys: String, CodingKey {
        case message
        case userId = "user_id"
        case surveyId = "survey_id"
    }
}
