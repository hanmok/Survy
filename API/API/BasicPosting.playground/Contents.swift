import UIKit

var greeting = "Hello, playground"
print(greeting)

func apiCall(){
//    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    guard let url = URL(string: "https://dearsurvy.herokuapp.com/tags") else { return }
    
    var request = URLRequest(url: url)
    // method, body, headers
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable] = [
//        "userId": 1,
//        "title": "Hello from iOS Academy",
//        "body": "The quick brown fox jumped over the lazy dog"
        "name": "마케팅"
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("Success: \(response)")
        } catch {
            print(error)
        }
    }
    
    task.resume()
}


apiCall()
