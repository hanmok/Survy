//
//  APIManager.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//
import Alamofire
import Foundation

class APIManager {
    private init() {}
    static let shared = APIManager()
    func testCall() {
        
//        let url = URL(string: "192.168.0.12:4000/users")!
        
//    https://dearsurvy.herokuapp.com
        let baseURL = "https://dearsurvy.herokuapp.com"
        let url = URL(string: "\(baseURL)/tags")!
//        let url = URL(string: "\(baseURL)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            print("data: \(data), response: \(response), error: \(error)")
            
//            let data = Data(data.debugDescription.utf8)

//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//
//            }
            print("data: \(data)")

        }

        task.resume()
        
        AF.request("https://dearsurvy.herokuapp.com/tags").response { response in
            print("af Response:")
            debugPrint(response)
        }
        
        AF.request("https://dearsurvy.herokuapp.com/tags")
            .responseDecodable(of: TagResponse.self) { response in
                do {
                    let resultValue = try response.result.get()
                    print("fetched result: \(resultValue)")
                } catch let error {
                    print("encountered error \(error.localizedDescription)")
                }
            }
    }
}
