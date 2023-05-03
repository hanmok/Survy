//
//  Coordinator.swift
//  Survy
//
//

import UIKit

protocol Coordinator {
    
    var provider: ProviderType { get set }
//    var cameraController: CameraController? { get }
//    var navigationController: StartingNavigationController? { get set }
    var navigationController: StartingNavigationController? { get set }
    /**
        다른 Controller 로 이동
     */
    func move(to type: Destination)
    func start()
    /**
     Camera, Score, Preview, CompleteView, Guide View 와 같이 다른 화면과 공존해야하는 Controller 를 제어
     
     - Parameters:
        - target: 조작할 SubViewController
        - command: 명령어 (show, hide, prepare, dismiss)
     */
//    func manipulateSubView(target: SubTarget, command: Command)
}
