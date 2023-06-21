//
//  DefaultAlamofireManager.swift
//  API
//
//  Created by Mac mini on 2023/06/14.
//

import Foundation
import Alamofire

class DefaultAlamofireManager: Session {
    static let shareManager: DefaultAlamofireManager = {
        let configureation = URLSessionConfiguration.default
//        Sniffer.enable(in: configureation)
        configureation.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        configureation.timeoutIntervalForRequest = 20
        configureation.timeoutIntervalForResource = 20
        configureation.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configureation)
    }()
}



