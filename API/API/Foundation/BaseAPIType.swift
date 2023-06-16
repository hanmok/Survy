//
//  BaseAPIType.swift
//  API
//
//  Created by Mac mini on 2023/05/27.
//

import Foundation
import Moya

public protocol BaseAPIType: TargetType {
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
//    func result(data: String, code: Int?, message: String?) -> String
}

extension BaseAPIType {
    public var baseURL: URL {
        return URL(string: "https://dearsurvy.herokuapp.com")!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        guard let parameters = parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}
