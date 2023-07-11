//
//  SurveyAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/12.
//

import Foundation
import Moya
import Model

public enum ResponseAPI {
//    case create(String, Int, Int) // title, participationGoal, userId
//    case fetchAll
//    case fetchGenres(Int) // with survey id
//    case participate(SurveyId, UserId)
    case create(QuestionId, SelectableOptionId, UserId, SurveyId)
}

extension ResponseAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        switch self {
//            case .fetchGenres(let surveyId):
//                return "/surveys/\(surveyId)/genres"
//            case .participate(let surveyId, let userId):
//            case .participate:
//                return "/surveys/\(surveyId)/participated-users/\(userId)"
//                return "/surveys/participated-users"
            default:
                return "/responses"
        }
    }
    
    public var method: Moya.Method {
//        switch self {
//            case .fetchAll, .fetchGenres:
//                return .get
//            case .create, .participate:
//                return .post
//        }
        return .post
    }
    
    public var parameters: [String : Any]? {
        switch self {
//            case .create(let title, let participationGoal, let userId):
//                return ["title": title, "participationGoal": participationGoal, "user_id": userId]
//            case .participate(let surveyId, let userId):
//                return ["survey_id": surveyId, "user_id": userId]
            case .create(let questionId, let selectableOptionId, let userId, let surveyId):
                return ["question_id": questionId, "selectableOption_id": selectableOptionId, "user_id": userId, "survey_id": surveyId]
            default: return [:]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
//            case .create, .participate :
            case .create:
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//            default:
//                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
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
