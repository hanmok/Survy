//
//  MainCoordinator.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import UIKit
import Model
import SnapKit

enum InitialScreen {
    case mainTab
    case responsdingQuestion
    case postingQuestion
    case test
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
        
//        initialScreen = .test
        
        switch initialScreen {
            case .mainTab:
                initialController = MainTabController(provider: self.provider, coordinator: self)
                
            case .responsdingQuestion:
                initialController = QuestionViewController(surveyService: self.provider.surveyService)
            case .postingQuestion:
                initialController = PostingViewController()
            case .test:
                initialController = DiffableTablePracticeViewController()
        }
        
        navigationController?.setViewControllers([initialController], animated: false)
    }
    
    public func testSetup() {
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
            case .postingController:
                let postingController = PostingViewController()
                postingController.coordinator = self
                navigationController?.pushViewController(postingController, animated: true)
        }
    }
    
    var navigationController: StartingNavigationController?
    
    func manipulate(_ childView: ChildView, command: Command) {
        switch (childView, command) {
//            case (.targetSelection, .present): break
//            case (.targetSelection, .dismiss): break
                
//            case (.categorySelection, .present):
//                let targetSelectionController = CategorySelectionController()
//                targetSelectionController.coordinator = self
//                guard let topViewController = navigationController?.topViewController else { return }
//                topViewController.view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
//                topViewController.addChild(targetSelectionController)
//                topViewController.view.addSubview(targetSelectionController.view)
//                targetSelectionController.view.snp.makeConstraints { make in
//                    make.edges.equalTo(topViewController.view.layoutMarginsGuide)
//                }
//
//            case (.categorySelection, .dismiss):
//                guard let topViewController = navigationController?.topViewController else { return }
//                topViewController.view.backgroundColor = UIColor.postingVCBackground
//                topViewController.children.forEach {
//                    $0.willMove(toParent: nil)
//                    $0.view.removeFromSuperview()
//                    $0.removeFromParent()
//                }
                
            case (let type, .present):
                var vc: UIViewController & Coordinating
                // 나중에 또 쓰일 수 있으므로 if 로 분리해놓음.
                if type == .targetSelection {
                    vc = TargetSelectionController()
                } else { // categorySelection
                    vc = CategorySelectionController()
                }
                vc.coordinator = self
                
                guard let topViewController = navigationController?.topViewController else { return }
                topViewController.view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
                
                topViewController.addChild(vc)
                topViewController.view.addSubview(vc.view)
                vc.view.snp.makeConstraints { make in
                    make.edges.equalTo(topViewController.view.layoutMarginsGuide)
                }
                
            case (_, .dismiss):
                                guard let topViewController = navigationController?.topViewController else { return }
                                topViewController.view.backgroundColor = UIColor.postingVCBackground
                                topViewController.children.forEach {
                                    $0.willMove(toParent: nil)
                                    $0.view.removeFromSuperview()
                                    $0.removeFromParent()
                                }
        }
    }
}
