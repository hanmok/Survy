//
//  SurveyTag.swift
//  API
//
//  Created by Mac mini on 2023/06/14.
//

import Foundation
import Moya
import Model

public enum SurveyTagAPI {
    case fetchAll
}

extension SurveyTagAPI: BaseAPIType {
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        switch self {
            case .fetchAll:
                return "/survey_tags"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchAll:
                return .get
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .fetchAll:
                return [:]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .fetchAll:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
//        switch self {
//            case .create:
//                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//            default:
//                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
//        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
            case .fetchAll:
                return URLEncoding.queryString
//            case .create:
//                return URLEncoding.httpBody
//            default:
//                return URLEncoding.queryString
        }
    }
}
