//
//  SectionAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation
import Moya

public enum SectionAPI {
    case create(String, Int, Int) // title, surveyId, Sequence
}

extension SectionAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
//        switch self {
//            case .fetchGenres(let surveyId):
//                return "/surveys/\(surveyId)/genres"
//            default:
//                return "/surveys"
//        }
        return "/sections"
    }
    
    public var method: Moya.Method {

//        switch self {
//            case .fetchAll, .fetchGenres:
//                return .get
//            case .create:
//                return .post
//        }

        return .post
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .create(let title, let sequence, let surveyId):
                return ["title": title, "sequence": sequence, "survey_id": surveyId]
        }
        
//        return ["title": String]
//        switch self {
//            case .create(let title, let participationGoal):
//                return ["title": title, "participationGoal": participationGoal]
//            default: return [:]
//        }
//        return [:]
        
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        
//        switch self {
//            case .create:
//                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//            default:
//                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
//        }
    
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
    
    public var parameterEncoding: ParameterEncoding {
//        switch self {
//            case .create:
//                return URLEncoding.httpBody
//            default:
//                return URLEncoding.queryString
//        }
        return URLEncoding.httpBody
    }
}
