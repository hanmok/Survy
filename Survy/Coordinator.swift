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
}

enum ChildView {
    case categorySelection
    case targetSelection
}

enum Command {
    case present
    case dismiss
}
