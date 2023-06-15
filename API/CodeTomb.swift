//
//  CodeTomb.swift
//  API
//
//  Created by Mac mini on 2023/06/14.
//

import Foundation


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

//     public func fetchTags(completion: @escaping ([Tag]) -> Void){
//        let url = URL(string: "https://dearsurvy.herokuapp.com/tags")!
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard error == nil, let data = data else {
//                print(error)
//                return
//            }
//
//            let tagsDic = try! JSONDecoder().decode([String: [Tag]].self, from: data)
//            let tags = tagsDic["tags"]!
//            print("tags: \(tags)")
//            completion(tags)
//
//        }.resume()
//    }




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


//public func requestTag(tagName: String, completion: @escaping ((String)?) -> Void) {
//    guard let url = URL(string: "https://dearsurvy.herokuapp.com/tags") else { return }
//
//    var request = URLRequest(url: url)
//    // method, body, headers
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    let body: [String: AnyHashable] = [
//        "name": tagName
//    ]
//
//    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil else {
//            return
//        }
//
//        do {
//            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print("Success: \(response)")
//            completion("success")
//        } catch {
//            print(error)
//            completion(error.localizedDescription)
//        }
//    }
//    task.resume()
//}



//func test_postTag() { // why is it not working ??
//    let expectation = self.expectation(description: "post")
//    APIService.shared.requestTag(tagName: "달리기") { result in
//        print("myAPIResult: \(result)")
//        XCTAssertNil(result)
//        expectation.fulfill()
//    }
//    waitForExpectations(timeout: 10)
//}
