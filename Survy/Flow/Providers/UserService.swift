//
//  UserService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

protocol UserServiceType: AnyObject {
    var collectedMoney: Int { get }
    var postedSurveyFree: Bool { get }
    var userId: Int { get }
}

class UserService: UserServiceType {
    var userId: Int { return 4 }
    
    var collectedMoney: Int { return 56000 }
    
    var postedSurveyFree: Bool { return true }
}
