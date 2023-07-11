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
import API
import Dispatch


enum InitialScreen {
    case mainTab
    case responsdingQuestion
    case postingQuestion
    case test
    case login
}

class MainCoordinator: Coordinator {
    
    var provider: ProviderType
    
    func handleAPIFailWithMessage(title: String, message: String? = nil) {
        navigationController?.setIndicatorSpin(false)
        toastMessage(title: title, message: message)
    }
    
    init() {
        self.provider = Provider()
    }
    
    func setIndicatorSpinning(_ shouldSpin: Bool) {
        navigationController?.setIndicatorSpin(shouldSpin)
    }
    
    func start() {
        
        var initialScreen: InitialScreen = .mainTab
        var initialController: UIViewController

//        initialScreen = .mainTab
        
        initialScreen = .login
        
        switch initialScreen {
            case .mainTab:
                initialController = MainTabController(provider: self.provider, coordinator: self)
            case .responsdingQuestion:
                initialController = QuestionViewController(participationService: self.provider.participationService)
            case .postingQuestion:
                initialController = PostingViewController(postingService: self.provider.postingService)
            case .test:
                initialController = ViewController6()
            case .login:
                initialController = LoginViewController(userService: self.provider.userService, coordinator: self)
        }
        
        navigationController?.setViewControllers([initialController], animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public func setupQuestions(completion: @escaping (Void?) -> Void) {
//        var sectionIds = [SectionId: [QuestionId]]()
        
        setIndicatorSpinning(true)
        APIService.shared.getSections { [weak self] allSections, message in
            guard let allSections = allSections else { fatalError() }
            guard let currentSurvey = self?.provider.participationService.currentSurvey else { fatalError() }
            
            var correspondingSections = allSections.filter { $0.surveyId == currentSurvey.id }
            
            print("correspondingSections: \(correspondingSections)")
            print("allSections: \(allSections)")
            // TODO: [SectionIds: [Questions]]
            var sectionDic = [SectionId: [Question]]()

            for correspondingSection in correspondingSections {
                sectionDic[correspondingSection.id!] = []
            }
            
                APIService.shared.getQuestions { questions, message in
                    guard let questions = questions else { fatalError() }
                    var sortedQuestions = questions.sorted { $0.position < $1.position }
                    
                    print("fetchedQuestions: \(sortedQuestions), numberOfFetchedQuestions: \(sortedQuestions.count)")
                    
                    var questionToSelectableOption = [QuestionId: [SelectableOption]]()
                    for eachQuestion in sortedQuestions {
                        questionToSelectableOption[eachQuestion.id] = []
                    }
                        
                    APIService.shared.getAllSelectableOptions { selectableOptions, message in
                        guard let selectableOptions = selectableOptions else { return }
                        
                        for selectableOption in selectableOptions {
                            questionToSelectableOption[selectableOption.questionId!]?.append(selectableOption)
                        }
                        
                        for questionIndex in sortedQuestions.indices {
                            let selectedQuestion = sortedQuestions[questionIndex]
                            sortedQuestions[questionIndex].setSelectableOptions(questionToSelectableOption[selectedQuestion.id]!)
                            sortedQuestions[questionIndex].setQuestionType(questionTypeId: selectedQuestion.questionTypeId)
                        }
                        
                        for question in sortedQuestions {
                            if sectionDic[question.sectionId] != nil {
                                sectionDic[question.sectionId]!.append(question)
                            }
                        }
                        
                        for sectionIndex in correspondingSections.indices {
                            let currentSectionId = correspondingSections[sectionIndex].id!
                            correspondingSections[sectionIndex].setQuestions(sectionDic[currentSectionId]!)
                        }
                        
                        let sortedSectionIds = sectionDic.keys.sorted()
                        var allQuestions = [Question]()
                        for key in sortedSectionIds {
                            sectionDic[key]!.sorted { $0.position < $1.position }.forEach {
                                allQuestions.append($0)
                            }
                        }
                        self?.provider.participationService.setSections(correspondingSections)
                        self?.provider.participationService.setQuestions(allQuestions)
                        self?.setIndicatorSpinning(false)
                        completion(())
                    }
                    self?.provider.participationService.startSurvey()
                }
        }
    }
    
    func move(to destination: Destination) {
        switch destination {
            case .loginPage:
//                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            case .mainTab:
                let mainTabController = MainTabController(provider: self.provider, coordinator: self)
                self.navigationController?.pushViewController(mainTabController, animated: true)
                
            case .questionController:
                self.setupQuestions { [weak self] result in
                    guard result != nil else { fatalError() }
                    guard let participationService = self?.provider.participationService else { fatalError() }
                    let questionController = QuestionViewController(participationService: participationService)
                    questionController.coordinator = self
                    self?.navigationController?.pushViewController(questionController, animated: true)
                }
                
            case .root:
                navigationController?.popToRootViewController(animated: true)
            case .postingController:
                let postingController = PostingViewController(postingService: self.provider.postingService)
                postingController.coordinator = self
                navigationController?.pushViewController(postingController, animated: true)
        }
    }
    
    func toastMessage(title: String, message: String? = nil) {
        navigationController?.toastMessage(title: title, message: message)
    }
    
    var navigationController: StartingNavigationController?
    
    func manipulate(_ childView: ChildView, command: Command) {
        
        let currentTabIndex = provider.commonService.selectedIndex
        
        switch (childView, command) {
                
            case (let type, .present):
                var vc: UIViewController & Coordinating

                switch type {
                    case .genreSelection(let purpose):
                        guard let purpose = purpose else { fatalError() }
                        vc = GenreSelectionController(postingService: self.provider.postingService, commonService: self.provider.commonService, participationService: self.provider.participationService, purpose: purpose)
                    case .targetSelection:
                        vc = TargetSelectionController(postingService: self.provider.postingService)
                    case .confirmation:
                        vc = ConfirmationController(postingService: self.provider.postingService, userService: self.provider.userService)
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
                
            case (let type, .dismiss(let isCompleted)):
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
                
                if type == .confirmation && isCompleted == true {
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
