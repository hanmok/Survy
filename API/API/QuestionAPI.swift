//
//  QuestionAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation
import Moya


public enum QuestionAPI {
    case create(String, Int, Int, Int) // text, section_id, questionType_id, expectedTimeInSec
}


extension QuestionAPI: BaseAPIType {
    
    struct Super: BaseAPIType { }
    
    var `super`: Super {
        return Super()
    }
    
    public var path: String {
        return "/questions"
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    // TODO: 필요할걸?
    public var parameters: [String : Any]? {
        switch self {
            case .create(let text, let sectionId, let questionTypeId, let expectedTimeInSec):
                return ["text": text,
                        "section_id": sectionId,
                        "questionType_id": questionTypeId,
                        "expectedTimeInSec": expectedTimeInSec]
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
