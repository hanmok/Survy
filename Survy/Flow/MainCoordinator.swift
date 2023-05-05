//
//  MainCoordinator.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation
import Model

class MainCoordinator: Coordinator {
    var provider: ProviderType
    
    init() {
        self.provider = Provider()
        testSetup()
    }
    
    func start() {
//        let mainTabController = MainTabController(provider: self.provider, coordinator: self)
//        navigationController?.setViewControllers([mainTabController], animated: false)
        
        let questionController = QuestionViewController(surveyService: self.provider.surveyService)
        navigationController?.setViewControllers([questionController], animated: false)
    }
    
    private func testSetup() {
        self.provider.surveyService.currentSurvey = surveys[0]
        self.provider.surveyService.currentSection = section
        self.provider.surveyService.questionsToConduct = [dietQuestion1, dietQuestion2, dietQuestion3]
        self.provider.surveyService.questionIndex = 0
    }
    
    func move(to destination: Destination) {
        switch destination {
            case .questionController:
                let questionController = QuestionViewController(surveyService: provider.surveyService)
                questionController.coordinator = self
                
                navigationController?.pushViewController(questionController, animated: true)
                
            case .root:
                navigationController?.popToRootViewController(animated: true)
        }
    }
    
    var navigationController: StartingNavigationController?
}
