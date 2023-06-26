//
//  QuestionAPI.swift
//  API
//
//  Created by Mac mini on 2023/06/16.
//

import Foundation
import Moya
import Model

public enum QuestionAPI {
    case create(QuestionPosition, QuestionText, SectionId, QuestionTypeId, Int) // text, section_id, questionType_id, expectedTimeInSec
    case fetchAll
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
        switch self {
            case .create: return .post
            case .fetchAll: return .get
        }
    }

    public var parameters: [String : Any]? {
        switch self {
            case .create(let questionPosition, let text, let sectionId, let questionTypeId, let expectedTimeInSec):
                return ["position": questionPosition,
                        "text": text,
                        "section_id": sectionId,
                        "questionType_id": questionTypeId,
                        "expectedTimeInSec": expectedTimeInSec]
            case .fetchAll: return [:]
        }
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .create :
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
