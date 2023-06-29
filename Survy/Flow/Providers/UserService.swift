//
//  UserService.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation
import Model

protocol UserServiceType: AnyObject {
    var collectedMoney: Int { get }
    var postedSurveyFree: Bool { get }
    var userId: Int { get }
    var currentUser: User? { get set }
    func setUser(_ user: User)
    func logout()
}

class UserService: UserServiceType {
    var userId: Int { return 4 }
    var collectedMoney: Int { return 56000 }
    var postedSurveyFree: Bool { return true }
    var currentUser: User?
    func setUser(_ user: User) {
        self.currentUser = user
    }
    func logout() {
        self.currentUser = nil
    }
}
