//
//  BaseAPIType.swift
//  API
//
//  Created by Mac mini on 2023/05/27.
//

import Foundation
import Moya
import Model

public protocol BaseAPIType: TargetType {
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var accessToken: String { get }
    var refreshToken: String { get }
}

extension BaseAPIType {
    
    public var accessToken: String {
        return KeychainManager.shared.loadAccessToken() ?? ""
    }
    
    public var refreshToken: String {
        return KeychainManager.shared.loadRefreshToken() ?? ""
    }
    
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
        return ["Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"]
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}
