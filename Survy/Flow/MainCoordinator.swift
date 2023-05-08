//
//  MainCoordinator.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import UIKit
import Model

enum InitialScreen {
    case mainTab
    case responsdingQuestion
    case postingQuestion
}

class MainCoordinator: Coordinator {
    var provider: ProviderType
    
    init() {
        self.provider = Provider()
        testSetup()
    }
    
    func start() {
        var initialScreen: InitialScreen = .mainTab
        var initialController: UIViewController
        
//        initialScreen = .postingQuestion
        initialScreen = .mainTab
        
        switch initialScreen {
            case .mainTab:
                initialController = MainTabController(provider: self.provider, coordinator: self)
                
            case .responsdingQuestion:
                initialController = QuestionViewController(surveyService: self.provider.surveyService)
            case .postingQuestion:
                initialController = PostingViewController()
        }
        
        navigationController?.setViewControllers([initialController], animated: false)
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
                navigationController?.toastMessage(title: "Test naslkdnkj ialiusdhjlajliu hadiudialjsild jasiodjio", message: "message")
            case .postingController:
                let postingController = PostingViewController()
                postingController.coordinator = self
                navigationController?.pushViewController(postingController, animated: true)
        }
    }
    
    var navigationController: StartingNavigationController?
}
