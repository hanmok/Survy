//
//  QuestionAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation
import Moya
import Model

public enum SelectableOptionAPI {
    case create(SelectableOptionValue, Position, QuestionId) // text, section_id,
    case fetchAll
}


extension SelectableOptionAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        return "/selectable-options"
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchAll:
                return .get
            case .create:
                return .post
        }
    }

    public var parameters: [String : Any]? {
        switch self {
            case .create(let selectableOptionValue, let position, let questionId):
                return ["value": selectableOptionValue,
                        "position": position,
                        "question_id": questionId]
            case .fetchAll:
                return [:]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self{
            case .create:
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            case .fetchAll:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
            case .create:
                return URLEncoding.httpBody
            case .fetchAll:
                return URLEncoding.queryString
        }
    }
}
