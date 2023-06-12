
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
    
    //    public func request(_ type: BaseAPIType, completion: @escaping (Result<String, Error>) -> Void) {
    //        let multiTarget = MultiTarget(type)
    //        provider.request(multiTarget) { result in
    //            switch result {
    //                case .success(let response):
    //                    do {
    //                        let data = try response.map(<#T##type: Decodable.Protocol##Decodable.Protocol#>)
    ////                        let ret = result.map(multiTarget)
    //                    }
    //
    //                case .failure(let error):
    //                    break
    //
    //            }
    //        }
    //    }
    
    
    
}

// MARK: - Tag

extension APIService {
    
//    func testCall() {
//
////        let url = URL(string: "192.168.0.12:4000/users")!
//
////    https://dearsurvy.herokuapp.com
//        let baseURL = "https://dearsurvy.herokuapp.com"
//        let url = URL(string: "\(baseURL)/tags")!
////        let url = URL(string: "\(baseURL)")!
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            print("data: \(data), response: \(response), error: \(error)")
//
////            let data = Data(data.debugDescription.utf8)
//
////            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
////
////            }
//            print("data: \(data)")
//
//        }
//
//        task.resume()
//
//        AF.request("https://dearsurvy.herokuapp.com/tags").response { response in
//            print("af Response:")
//            debugPrint(response)
//        }
//
//        AF.request("https://dearsurvy.herokuapp.com/tags")
//            .responseDecodable(of: TagResponse.self) { response in
//                do {
//                    let resultValue = try response.result.get()
//                    print("fetched result: \(resultValue)")
//                } catch let error {
//                    print("encountered error \(error.localizedDescription)")
//                }
//            }
//    }
    
     public func fetchTags(completion: @escaping ([Tag]) -> Void){
        let url = URL(string: "https://dearsurvy.herokuapp.com/tags")!
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil, let data = data else {
                print(error)
                return
            }

            let tagsDic = try! JSONDecoder().decode([String: [Tag]].self, from: data)
            let tags = tagsDic["tags"]!
            print("tags: \(tags)")
            completion(tags)
            
        }.resume()
    }
    
    public func fetchTagsMoya(completion: @escaping ([Tag]?) -> Void) {
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
    
    public func requestTag(tagName: String, completion: @escaping ((String)?) -> Void) {
        guard let url = URL(string: "https://dearsurvy.herokuapp.com/tags") else { return }
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "name": tagName
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("Success: \(response)")
                completion("success")
            } catch {
                print(error)
                completion(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    public func requestTagMoya(requestingTagName: String, completion: @escaping ((String)?) -> Void) {
            
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
        
            // 어떻게 요청하지 ?? 이름을 어떻게 정하지 ?? 이미 정했을걸?
            
        }
    }
}

extension APIService {
    public func getAllSurveys(completion: @escaping ([Survey]?) -> Void ) {
        surveyProvider.request(.fetchAll) { result in
            switch result {
                case .success(let result):
//                    let surveysDic = try! JSONDecoder().decode([String: [Survey]].self, from: result.data)
//                    let surveysDic = try! JSONDecoder().decode([String: SurveyResponse].self, from: result.data)
//                    let surveysResult = try! JSONDecoder().decode(SurveyResponse.self, from: result.data)
                    let 
//                    guard let surveys = surveysDic["surveys"] else { fatalError("There's no surveys in dictionary~")}
                    print("surveysResult: \(surveysResult)")
                    
                    
                case .failure(let error):
                    fatalError(error.localizedDescription)
//                    completion(nil)
            }
        }
    }
    
//    public func
}

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


