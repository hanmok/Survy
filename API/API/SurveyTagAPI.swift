//
//  SurveyGenre.swift
//  API
//
//  Created by Mac mini on 2023/06/14.
//

import Foundation
import Moya
import Model

public enum SurveyGenreAPI {
    case fetchAll
    case connectToGenre(SurveyId, GenreId)
}

extension SurveyGenreAPI: BaseAPIType {
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        switch self {
            case .fetchAll:
                return "/survey_genres"
            case .connectToGenre:
                return "/surveys/genres"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchAll:
                return .get
            case .connectToGenre:
                return .post
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .fetchAll:
                return [:]
            case .connectToGenre(let surveyId, let genreId):
                return ["survey_id": surveyId, "genre_id": genreId]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .fetchAll:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            case .connectToGenre:
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
            case .connectToGenre:
                return URLEncoding.httpBody
            case .fetchAll:
                return URLEncoding.queryString
        }
    }
}
