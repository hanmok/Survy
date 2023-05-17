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
}

class Provider: ProviderType {
    var postingService: PostingServiceType = PostingService()
    
    var userService: UserServiceType = UserService()
    var participationService: ParticipationServiceType = ParticipationService()
}
