import UIKit

struct Customer {
    var firstName: String
    var lastName: String
    var age: Int
}

extension Customer {
    init?(dictionary: [String: Any]) {
        guard let firstName = dictionary["firstName"] as? String,
                let lastName = dictionary["lastName"] as? String,
              let age = dictionary["age"] as? Int else {
            return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

let json = """
{
    "firstName": "John",
    "lastName": "Doe",
    "age": 34
}
""".data(using: .utf8)!

// jsonObject: Returns a Foundation object from given JSON data.
if let dictionary = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: Any] {
    if let customer = Customer(dictionary: dictionary) {
        print(customer)
    }
}

















let groupJson = """
[
    {
        "firstName": "John",
        "lastName": "Doe",
        "age": 34
},
    {
        "firstName": "Mary",
        "lastName": "Kate",
        "age": 35
    },
    {
        "firstName": "Alex",
        "lastName": "Lowe",
        "age": 45
    }
]
""".data(using: .utf8)!

if let customersDictionary = try! JSONSerialization.jsonObject(with: groupJson, options: .allowFragments) as? [[String: Any]] { // Array of Dictionary
    print("customersDictionary: \(customersDictionary)")
    let customers = customersDictionary.compactMap { dictionary in
        return Customer(dictionary: dictionary)
    }
    
    // Automatically pass in dictionary
    let customers2 = customersDictionary.compactMap(Customer.init)
}
