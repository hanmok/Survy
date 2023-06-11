import UIKit

struct Customer: Codable { // Encodable & Decodable
    var firstName: String
    var lastName: String
    var age: Int
}

// MARK: - Encode
let customer = Customer(firstName: "John", lastName: "Doe", age: 45) // Customer
let encodedJSON = try! JSONEncoder().encode(customer) // Data
let str = String(data: encodedJSON, encoding: .utf8) // Data -> String(JSON)
/*
let str = """
{
"firstName":"John",
"age":45,
"lastName":"Doe"
}
"""
*/

// MARK: - Decode

let json = """
{
    "firstName": "John",
    "lastName": "Doe",
    "age": 34
}
""".data(using: .utf8)!
let customer = try! JSONDecoder().decode(Customer.self, from: json) // Customer

















// MARK: - Decoding Array

struct Place: Decodable {
    var name: String
    var latitude: Double
    var longitude: Double
    var visited: Bool
}


let json = """
[
    {
        "name": "Costa Rica",
        "latitude": 23.12,
        "longitude": 45.12,
        "visited": true
    },
    {
        "name": "Puerto Rico",
        "latitude": 23,
        "longitude": 45,
        "visited": true
    },
    {
        "name": "Mexico City",
        "latitude": 23,
        "longitude": 45,
        "visited": true
    },
    {
        "name": "Iceland",
        "latitude": 23,
        "longitude": 45,
        "visited": false
    }
]
""".data(using: .utf8)!

let places = try! JSONDecoder().decode([Place].self, from: json)
