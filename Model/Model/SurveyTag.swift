//
//  SurveyGenre.swift
//  Model
//
//  Created by Mac mini on 2023/06/14.
//

import Foundation

public struct SurveyGenre: Codable {
    public let genreId: Int
    public let surveyId: Int
    
    public enum CodingKeys: String, CodingKey {
        case genreId = "genre_id"
        case surveyId = "survey_id"
    }
}

