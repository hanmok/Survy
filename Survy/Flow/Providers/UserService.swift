//
//  UserService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

protocol UserServiceType: AnyObject {
    var lastSelectedCategories: [String] { get }
    
    var collectedMoney: Int { get }
    
    var postedSurveyFree: Bool { get }
}

class UserService: UserServiceType {
    
//    var lastSelectedCategories: [String] = ["애견", "운동", "음식", "피부"]
    
    var lastSelectedCategories: [String] {
        return UserDefaults.standard.lastSelectedCategories.cutStringInOrder()
    }
    
    var collectedMoney: Int { return 56000 }
    
    var postedSurveyFree: Bool { return true }
}
