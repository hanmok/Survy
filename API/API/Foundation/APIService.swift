
//
//  APIManager.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Alamofire
import Foundation
import Model
import Moya

public class APIService {
    private init() {}
    static public let shared = APIService()
    
    private let provider: MoyaProvider<MultiTarget> = {
        let provider = MoyaProvider<MultiTarget>(endpointClosure: MoyaProvider.defaultEndpointMapping, requestClosure: MoyaProvider<MultiTarget>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: nil, session: DefaultAlamofireManager.shareManager, plugins: [], trackInflights: false)
        return provider
    }()
    
    private let tagProvider = MoyaProvider<TagAPI>()
    private let surveyProvider = MoyaProvider<SurveyAPI>()
    private let surveyTagProvider = MoyaProvider<SurveyTagAPI>()
}

// MARK: - Tag

extension APIService {
    public func getAllTags(completion: @escaping ([Tag]?) -> Void) {
        tagProvider.request(.fetchAll) { result in
            switch result {
                case .success(let result):
                    print("fetched result: \(result)")
                    let tagsDic = try! JSONDecoder().decode([String: [Tag]].self, from: result.data)
                    let tags = tagsDic["tags"]
                    completion(tags)
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    completion(nil)
            }
        }
    }
    
    public func postTag(requestingTagName: String, completion: @escaping ((String)?) -> Void) {
            
        // TODO: - StatusCode 500 이면 에러 처리.
        tagProvider.request(.create(requestingTagName)) { result in
            
            switch result {
                    
            case .success(let result):
                    // 이게 무슨코드야? json 으로 만드는 코드.
                    let responseDic = try! JSONSerialization.jsonObject(with: result.data, options: .allowFragments)
                    print("someDic: \(responseDic)")
                    completion("hi")
                    
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

// MARK: - Survey

extension APIService {
    public func getAllSurveys(completion: @escaping ([Survey]?) -> Void ) {
        surveyProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
                    let surveysResponse = try! JSONDecoder().decode(SurveyResponse.self, from: response.data)
                    print("surveysResponse: \(surveysResponse)")
                    completion(surveysResponse.surveys)
                    
                case .failure(let error):
                    completion(nil)
            }
        }
    }
}

// MARK: - SurveyTags

extension APIService {
    public func getAllSurveyTags(completion: @escaping ([SurveyTag]?) -> Void) {
        surveyTagProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let surveyTagsDic = try! JSONDecoder().decode([String: [SurveyTag]].self, from: response.data)
                    guard let surveyTags = surveyTagsDic["survey_tags"] else { completion(nil)
                        return
                    }
                    completion(surveyTags)
                case .failure(let moyaError):
                    completion(nil)
            }
        }
    }
}
