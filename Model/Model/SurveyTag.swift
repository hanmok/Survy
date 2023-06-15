//
//  SurveyTag.swift
//  Model
//
//  Created by Mac mini on 2023/06/14.
//

import Foundation

public struct SurveyTag: Codable {
    public let tagId: Int
    public let surveyId: Int
    
    public enum CodingKeys: String, CodingKey {
        case tagId = "tag_id"
        case surveyId = "survey_id"
    }
}

