//
//  NameMismatches.swift
//  API
//
//  Created by Mac mini on 2023/06/11.
//

import Foundation

struct Person: Decodable {
    var firstName: String
    var lastName: String
    var age: Int
}

let json = """
{
    "first_name": "John",
    "last_name": "Doe",
    "age": 34
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase // snake_case -> camelCase
let snakePerson = try! decoder.decode(Person.self, from: json)


























// MARK: - Coding Keys

struct User: Decodable {
    let firstName: String
    let lastName: String
    let age: Int
    let address: Address
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "FIRSTNAME"
        case lastName = "LASTNAME"
        case age = "AGE"
        case address = "ADDRESS"
    }
}

struct Address: Decodable {
    let street: String
    let state: String
    let zipcode: String
    
    private enum CodingKeys: String, CodingKey {
        case street = "STREET"
        case state = "STATE"
        case zipcode = "ZIPCODE"
    }
}

let json = """
{
"FIRSTNAME": "John",
"LASTNAME": "Doe",
"AGE": 34,
"ADDRESS": {
    "STREET": "1200 Richmond Ave",
    "STATE": "TX",
    "ZIPCODE": "77042"
    }
}
""".data(using: .utf8)!

let user = try! JSONDecoder().decode(User.self, from: json)
