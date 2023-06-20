//
//  SurveyAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/12.
//

import Foundation
import Moya
import Model

public enum SurveyAPI {
    case create(String, Int, Int) // title, participationGoal, userId
    case fetchAll
    case fetchGenres(Int) // with survey id
}

extension SurveyAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        switch self {
            case .fetchGenres(let surveyId):
                return "/surveys/\(surveyId)/genres"
            default:
                return "/surveys"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchAll, .fetchGenres:
                return .get
            case .create:
                return .post
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .create(let title, let participationGoal, let userId):
                return ["title": title, "participationGoal": participationGoal, "user_id": userId]
            default: return [:]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .create:
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            default:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
            case .create:
                return URLEncoding.httpBody
            default:
                return URLEncoding.queryString
        }
    }
}


