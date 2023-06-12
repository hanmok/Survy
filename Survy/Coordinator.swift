//
//  Coordinator.swift
//  Survy
//
//

import UIKit

protocol Coordinator {
    
    var provider: ProviderType { get set }

    var navigationController: StartingNavigationController? { get set }
    
    func move(to type: Destination)
    
    func start()
    
    func manipulate(_ childView: ChildView, command: Command)
    
    func testSetup()
    
    func setIndicatorSpinning(_ shouldSpin: Bool)
}

enum ChildView {
    case categorySelection
    
    case targetSelection
    case confirmation
}

enum Command {
    case present
    case dismiss
}
