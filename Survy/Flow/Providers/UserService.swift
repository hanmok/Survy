//
//  UserService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

protocol UserServiceType: AnyObject {
    var interestedCategories: [String] { get set }
    
    var collectedMoney: Int { get }
   
}

class UserService: UserServiceType {
    
    var interestedCategories: [String] = ["애견", "운동", "음식", "피부"]
    
    var collectedMoney: Int { return 56000 }
    
}
