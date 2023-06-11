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
    
    
    private let tagProvider = MoyaProvider<TagAPI>()
    
   
    
    
    
    
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
        tagProvider.request(.fetchAll) { [weak self] result in
            switch result {
                case .success(let result):
                    print("result: \(result)")
                    let tagsDic = try! JSONDecoder().decode([String: [Tag]].self, from: result.data)
                    let tags = tagsDic["tags"]
                    completion(tags)
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    completion(nil)
            }
        }
    }
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


