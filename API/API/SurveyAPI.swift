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
    case create(String, Int) // title, participationGoal
    case fetchAll
    case fetchTags(Int) // with survey id
}

extension SurveyAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        switch self {
            case .fetchTags(let surveyId):
                return "/surveys/\(surveyId)/tags"
            default:
                return "/surveys"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchAll, .fetchTags:
                return .get
            case .create:
                return .post
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .create(let title, let participationGoal):
                return ["title": title, "participationGoal": participationGoal]
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


