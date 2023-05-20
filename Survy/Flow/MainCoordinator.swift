//
//  MainCoordinator.swift
//  Survy
//
//  Created by Mac mini on 2023/05/03.
//

import UIKit
import Model
import SnapKit
import Toast

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
                initialController = QuestionViewController(surveyService: self.provider.participationService)
            case .postingQuestion:
                initialController = PostingViewController(postingService: self.provider.postingService)
                
            case .test:
//                initialController = DiffableTablePracticeViewController()
//                initialController = DiffableCollectionViewPractice()
//                initialController = MVVMController()
                
                initialController = ConfirmationController(postingService: self.provider.postingService)
        }
        
        navigationController?.setViewControllers([initialController], animated: false)
    }
    
    public func testSetup() {
        self.provider.participationService.currentSurvey = surveys[0]
        self.provider.participationService.currentSection = section
        self.provider.participationService.questionsToConduct = [dietQuestion1, dietQuestion2, dietQuestion3]
        self.provider.participationService.questionIndex = 0
    }
    
    func move(to destination: Destination) {
        switch destination {
            case .questionController:
                
                let questionController = QuestionViewController(surveyService: provider.participationService)
                questionController.coordinator = self
                navigationController?.pushViewController(questionController, animated: true)
            case .root:
                navigationController?.popToRootViewController(animated: true)
                navigationController?.setNavigationBarHidden(false, animated: false)
            case .postingController:
//                let postingController = PostingViewController()
                let postingController = PostingViewController(postingService: self.provider.postingService)
                postingController.coordinator = self
                navigationController?.pushViewController(postingController, animated: true)
        }
    }
    
    var navigationController: StartingNavigationController?
    
    func manipulate(_ childView: ChildView, command: Command) {
        switch (childView, command) {
                
            case (let type, .present):
                var vc: UIViewController & Coordinating
                // 나중에 또 쓰일 수 있으므로 if 로 분리해놓음.

                switch type {
                    case .categorySelection:
                        vc = CategorySelectionController(postingService: self.provider.postingService)
                    case .targetSelection:
                        vc = TargetSelectionController(postingService: self.provider.postingService)
                    case .confirmation:
                        vc = ConfirmationController(postingService: self.provider.postingService)
                }
                
                vc.coordinator = self
                
                guard let topViewController = navigationController?.topViewController else { return }
                topViewController.view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
                
                topViewController.addChild(vc)
                topViewController.view.addSubview(vc.view)
                vc.view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
            case (let type, .dismiss):
                guard let topViewController = navigationController?.topViewController else { fatalError() }
                
                topViewController.view.backgroundColor = UIColor.postingVCBackground
                topViewController.children.forEach {
                    $0.willMove(toParent: nil)
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
                
                guard let postingViewController = topViewController as? BaseViewController else { fatalError() }
                
                if type == .confirmation {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        self.move(to: .root)
                        self.navigationController?.toastMessage(title: "설문이 요청되었습니다.")
                    }
                } else {
                    postingViewController.updateMyUI()
                    navigationController?.setNavigationBarHidden(false, animated: false)
                }
        }
    }
}
