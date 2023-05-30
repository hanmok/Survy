//
//  Tag+Moya.swift
//  API
//
//  Created by Mac mini on 2023/05/27.
//

import Foundation
import Moya
import Model

public enum TagAPI  {
    case fetchAll
    case fetchWith(Int)
    case create(String)
}



extension TagAPI: BaseAPIType {

    struct Super: BaseAPIType {}
    
    var `super`: Super {
        return Super()
    }

    public var path: String {
        switch self {
            case .fetchAll, .create:
                return "/tags"
            case .fetchWith(let id):
                return "/tags/\(id)"
        }
    }

    public var method: Moya.Method {
        switch self {
            case .fetchAll, .fetchWith:
                return .get
            case .create:
                return .post
        }
    }

    public var parameters: [String: Any]? {
        switch self {
            case .create(let name):
                return ["name": name]
            default: return [:]
        }
    }

    public var task: Moya.Task { // body part
        guard let parameters = parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
