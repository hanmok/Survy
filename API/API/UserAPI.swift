//
//  SurveyAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/12.
//

import Foundation
import Moya
import Model

public enum UserAPI {
    case connectToSurvey(UserId, SurveyId)
    case getPostedSurveyByUser(UserId)
    case create(Username, Password)
    case login(Username, Password)
}

extension UserAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        switch self {
            case .connectToSurvey:
                return "/users/posted-survey"
            case .getPostedSurveyByUser(let userId):
                return "/users/\(userId)/posted-surveys"
            case .create:
                return "/users"
            case .login:
                return "/users/login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .connectToSurvey, .create, .login:
                return .post
            case .getPostedSurveyByUser:
                return .get
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .connectToSurvey(let userId, let surveyId):
                return ["user_id": userId, "survey_id": surveyId]
            case .getPostedSurveyByUser(_):
                return [:]
            case .create(let username, let password), .login(let username, let password):
                return ["username": username, "password": password]
                
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .connectToSurvey, .create, .login:
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            default:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
            case .connectToSurvey, .create, .login:
                return URLEncoding.httpBody
            default:
                return URLEncoding.queryString
        }
    }
}
