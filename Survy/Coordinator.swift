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
}
