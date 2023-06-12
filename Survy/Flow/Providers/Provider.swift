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
    var userService: UserServiceType { get set }
    var participationService: ParticipationServiceType { get set }
    var postingService: PostingServiceType { get set }
    var commonService: CommonServiceType { get set }
}

class Provider: ProviderType {
    var postingService: PostingServiceType = PostingService()
    var userService: UserServiceType = UserService()
    var participationService: ParticipationServiceType = ParticipationService()
    var commonService: CommonServiceType = CommonService()
}

protocol CommonServiceType {
    var selectedIndex: Int { get set }
    func setSelectedIndex(_ index: Int)
}

class CommonService: CommonServiceType {
    var selectedIndex: Int = 0
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
}
