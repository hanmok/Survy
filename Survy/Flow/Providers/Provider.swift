//
//  ProviderType.swift
//  MultiPeer
//

//

import Foundation
import Model

/**
 앱 내 여러 부분에서 공통으로 쓰이는 데이터
 */
protocol ProviderType: AnyObject {
//    var connectionManager: ConnectionManager { get set }
//    var movementService: MovementServiceType { get set }
//    var resultService: ResultServiceType { get set }
//    var commonService: CommonServiceType { get set }
    var userService: UserServiceType { get set }
    var surveyService: SurveyServiceType { get set }
}

class Provider: ProviderType {
    var userService: UserServiceType = UserService()
    var surveyService: SurveyServiceType = SurveyService()
//    var commonService: CommonServiceType = CommonService()
//    var resultService: ResultServiceType = ResultService()
//    var movementService: MovementServiceType = MovementService()
//    var connectionManager: ConnectionManager = ConnectionManager()
}
