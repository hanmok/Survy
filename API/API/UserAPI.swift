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
//    case create(String, Int, Int) // title, participationGoal, userId
    case connectToSurvey(UserId, SurveyId)
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
//            case .fetchGenres(let surveyId):
//                return "/surveys/\(surveyId)/genres"
            
//            default:
//                return "/surveys"
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
//            case .fetchAll, .fetchGenres:
//                return .get
//            case .create:
//                return .post
            case .connectToSurvey:
                return .post
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .connectToSurvey(let userId, let surveyId):
                return ["user_id": userId, "survey_id": surveyId]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
//            case .create :
//                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            default:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
//            case .create:
//                return URLEncoding.httpBody
            default:
                return URLEncoding.queryString
        }
    }
}


