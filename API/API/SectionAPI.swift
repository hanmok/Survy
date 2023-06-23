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
    case fetchAll
}

extension SectionAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        return "/sections"
    }
    
    public var method: Moya.Method {
        switch self {
            case .create:
                return .post
            default:
                return .get
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
            case .create(let title, let sequence, let surveyId):
                return ["title": title, "sequence": sequence, "survey_id": surveyId]
            case .fetchAll:
                return [:]
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
