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
    
    func setIndicatorSpinning(_ shouldSpin: Bool) {
        navigationController?.setIndicatorSpin(shouldSpin)
    }
    
    func start() {
        
        var initialScreen: InitialScreen = .mainTab
        var initialController: UIViewController

        initialScreen = .mainTab
        
        switch initialScreen {
            case .mainTab:
                initialController = MainTabController(provider: self.provider, coordinator: self)
                
            case .responsdingQuestion:
                initialController = QuestionViewController(surveyService: self.provider.participationService)
            case .postingQuestion:
                initialController = PostingViewController(postingService: self.provider.postingService)
                
            case .test:
                initialController = ViewController6()
        }
        
        navigationController?.setViewControllers([initialController], animated: false)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
            case .postingController:
                let postingController = PostingViewController(postingService: self.provider.postingService)
                postingController.coordinator = self
                navigationController?.pushViewController(postingController, animated: true)
        }
    }
    
    func toastMessage(title: String, message: String) {
        navigationController?.toastMessage(title: title, message: message)
    }
    
    var navigationController: StartingNavigationController?
    
    func manipulate(_ childView: ChildView, command: Command) {
        
        let currentTabIndex = provider.commonService.selectedIndex
        
        switch (childView, command) {
                
            case (let type, .present):
                var vc: UIViewController & Coordinating

                switch type {
                    case .categorySelection:
                        vc = CategorySelectionController(postingService: self.provider.postingService)
                    case .targetSelection:
                        vc = TargetSelectionController(postingService: self.provider.postingService)
                    case .confirmation:
                        vc = ConfirmationController(postingService: self.provider.postingService)
                }
                
                vc.coordinator = self
                
                guard var topViewController = navigationController?.topViewController else { fatalError() }
                
                if let mainTab = topViewController as? MainTabController, let wrappedNav = mainTab.viewControllers?[currentTabIndex] as? UINavigationController {
                    topViewController = wrappedNav.topViewController!
                    topViewController.tabBarController?.tabBar.isHidden = true
                }
                
                topViewController.view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
                print("presentingViewController: \(topViewController)")
                
                topViewController.addChild(vc)
                topViewController.view.addSubview(vc.view)
                
                vc.view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
            case (let type, .dismiss):
                // MainTabController 면 곤란함.. 다르게 처리해야해. How ?
                guard var topViewController = navigationController?.topViewController else { fatalError() }
                
                if let mainTab = topViewController as? MainTabController, let nav = mainTab.viewControllers![currentTabIndex] as? UINavigationController {
                    topViewController = nav.topViewController!
                    topViewController.tabBarController?.tabBar.isHidden = false
                }
                
                print("topViewController: \(topViewController)")
                
                topViewController.view.backgroundColor = UIColor.postingVCBackground
                topViewController.children.forEach {
                    $0.willMove(toParent: nil)
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
                
//                guard let postingViewController = topViewController as? BaseViewController else { fatalError() }
                
                if type == .confirmation {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        self.move(to: .root)
                        self.navigationController?.toastMessage(title: "설문이 요청되었습니다.")
                    }
                } else {
                    guard let postingViewController = topViewController as? BaseViewController else { return }
                    postingViewController.updateMyUI()
                }
        }
    }
}
