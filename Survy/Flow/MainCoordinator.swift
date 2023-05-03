//
//  MainCoordinator.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

class MainCoordinator: Coordinator {
    var provider: ProviderType
    
    init() {
        self.provider = Provider()
    }
    
    func start() {
        let mainTabController = MainTabController(provider: self.provider, coordinator: self)
        navigationController?.setViewControllers([mainTabController], animated: false)
    }
    
    func move(to destination: Destination) {
        switch destination {
            case .questionController:
                let questionController = QuestionViewController(surveyService: provider.surveyService)
                
                navigationController?.pushViewController(questionController, animated: true)
            case .root:
                break
        }
    }
    
    var navigationController: StartingNavigationController?
}
