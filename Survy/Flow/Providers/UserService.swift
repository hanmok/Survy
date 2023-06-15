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
}

class UserService: UserServiceType {
    
    var collectedMoney: Int { return 56000 }
    
    var postedSurveyFree: Bool { return true }
}
