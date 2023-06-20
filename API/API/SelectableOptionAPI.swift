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
//    case create(String, Int, Int, Int) // text, section_id, questionType_id, expectedTimeInSec
//    case create(QuestionText, SectionId, QuestionTypeId, Int) // text, section_id, questionType_id, expectedTimeInSec
    case create(SelectableOptionValue, Position, QuestionId) // text, section_id,
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
        return .post
    }
    
    // TODO: 필요할걸?
    public var parameters: [String : Any]? {
        switch self {
            case .create(let selectableOptionValue, let position, let questionId):
                return ["value": selectableOptionValue,
                        "position": position,
                        "question_id": questionId]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
    
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
}
