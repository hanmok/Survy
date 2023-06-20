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
    
    // 음.. body 와 parameter 를 어떻게 구분하지 ?? 나중에 필요할 때 혀
    public var task: Moya.Task { // body part
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

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
