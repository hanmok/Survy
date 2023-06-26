//
//  ConfirmationController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/21.
//

import UIKit
import Model
import API
import Dispatch


class ConfirmationController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        
        setupDelegate()
        setupNavigationBar()
        configureLayout()
        setupLayout()
        setupNotifications()
        setupTargets()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(otherViewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureLayout() {
        
        expectedTimeInMinLabel.text = "\(postingService.expectedTimeInMin)분"
        numberOfSpecimenTextField.text = "\(postingService.numberOfSpecimens)"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let costString = numberFormatter.string(from: postingService.totalCost as NSNumber)!
        expectedCostLabel.text = "\(costString)원"
    }
    
    @objc func otherViewTapped() {
        view.dismissKeyboard()
    }
    
    private func setupDelegate() {
        self.numberOfSpecimenTextField.delegate = self
    }
    
    @objc func exitTapped() {
        coordinator?.manipulate(.confirmation, command: .dismiss(nil))
    }
    
    private func setupTargets() {
        completeButton.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        
        priceSegmentedControl.insertSegment(action: UIAction(title: "Free", handler: { [weak self] freeAction in
            guard let self = self else { return }
            self.expectedCostLabel.text = "0원"
        }), at: 0, animated: false)
        
        priceSegmentedControl.insertSegment(action: UIAction(title: "Paid", handler: { [weak self] freeAction in
            guard let self = self else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let costString = numberFormatter.string(from: self.postingService.totalCost as NSNumber)!
            self.expectedCostLabel.text = "\(costString)원"
        }), at: 1, animated: false)
        
        // TODO: get from User Information // 이거,.. User Default 로 빼도 될 것 같은데?
        priceSegmentedControl.selectedSegmentIndex = 0
        self.expectedCostLabel.text = "0원"
    }
    
    @objc func completeTapped() {
        postingService.setParticipationGoal(participationGoal: 100)
        
        guard let surveyTitle = postingService.surveyTitle else { fatalError() }
        guard let participationGoal = postingService.participationGoal else { fatalError() }
        let userId = userService.userId
       
        let dispatchGroup = DispatchGroup()
        
        // Post Survey
        APIService.shared.postSurvey(title: surveyTitle,
                                     participationGoal: participationGoal,
                                     userId: userId) { [weak self] surveyId, string in
            guard let self = self else { fatalError() }
            guard let surveyId = surveyId else { fatalError() }
            let selectedGenreIds = postingService.selectedGenres.map { $0.id }
            
            // Survey ~ Genre
            for genreId in selectedGenreIds {
                APIService.shared.connectSurveyGenres(surveyId: surveyId, genreId: genreId) { result, message in
                    guard result != nil else { fatalError() }
                }
            }
            
            // Survey, UserId 연결
            APIService.shared.postSurveyUser(userId: userId, surveyId: surveyId) { result, message in
                guard result != nil else { fatalError("user and post not connected ") }
            }
            
            if postingService.sections == nil { // section.. 에 이게 반드시 필요해?
                let initialSection = Section(title: "test section", sequence: 0)
                postingService.setSections([initialSection])
            }
            
            guard var sections = postingService.sections else {fatalError("cannot happen")}
            
            // 각 Section 에 대해 API LOOP
            for index in sections.indices {
                dispatchGroup.enter()
                
                APIService.shared.postSection(title: sections[index].title,
                                              sequence: sections[index].sequence,
                                              surveyId: surveyId) { sectionId, sectionResultString in
                    
                    guard let sectionId = sectionId else { return }
                    sections[index].setId(sectionId)
                    
                    // TODO: Section 에 있는 각 postingQuestions 로 설정하기. (section 만들어진 후)
                    let postingQuestions = self.postingService.postingQuestions
                    
                    // Posting Questions
                    for index in postingQuestions.indices {
                        var question = postingQuestions[index]
                        question.setSectionId(sectionId)
                        APIService.shared.postQuestion(questionPosition: question.index,
                                                       text: question.questionText!,
                                                       sectionId: question.sectionId!,
                                                       questionTypeId: question.briefQuestionType!.rawValue,
                                                       expectedTimeInSec: 20) { questionId, string in
                            
                            guard let questionId = questionId else { fatalError() }
                            
                            let selectableOptions = postingQuestions[index].selectableOptions
                            print("selectableOptions: \(selectableOptions), the number of selectableOptions: \(selectableOptions.count)")
                            
                            for selectableIdx in selectableOptions.indices {
                                let selectableOption = selectableOptions[selectableIdx]
                                
                                if let selectableValue = selectableOption.value {
                                    dispatchGroup.enter()
                                    APIService.shared.postSelectableOption(value: selectableValue,
                                                                           position: selectableOption.position,
                                                                           questionId: questionId) { void, message in
                                        dispatchGroup.leave()
                                        guard void != nil else { fatalError(message) }
                                    }
                                }
                            }
                            print("completed!")
                        }
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.postingService.reset()
                self.coordinator?.manipulate(.confirmation, command: .dismiss(true))
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem = nil
    }
    
    let postingService: PostingServiceType
    let userService: UserServiceType
    
    init(postingService: PostingServiceType, userService: UserServiceType) {
        self.postingService = postingService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let wholeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.applyCornerRadius(on: .top, radius: 10)
        return view
    }()
    
    private let priceSegmentedControl = UISegmentedControl()
    
    private func setupLayout() {
        self.view.addSubview(wholeContainerView)
        self.view.addSubview(completeButton)
        
        [topViewContainer, guideStackView, resultStackView, priceSegmentedControl,
        expectedCostGuideLabel, expectedCostLabel
        ].forEach { self.wholeContainerView.addSubview($0)}
        
        topViewContainer.addSubview(topViewLabel)
        topViewContainer.addSubview(exitButton)
        
        wholeContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.centerY.equalToSuperview().offset(-75)
            make.height.equalTo(view.frame.height / 3.0)
        }
        
        topViewContainer.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        topViewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        
        self.guideStackView.addArrangedSubviews([expectedTimeInMinGuideLabel
                                                 ,numberOfSpecimenLabel
                                                ])
        
        self.resultStackView.addArrangedSubviews([expectedTimeInMinLabel
                                                  ,numberOfSpecimenTextField
                                                 ])
        
        guideStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(topViewContainer.snp.bottom).offset(12)
            make.height.equalTo(100)
            make.width.equalTo(150)
        }
        
        resultStackView.snp.makeConstraints { make in
            make.leading.equalTo(guideStackView.snp.trailing).offset(30)
            make.top.equalTo(guideStackView.snp.top)
            make.height.equalTo(guideStackView.snp.height)
            make.width.equalTo(150)
        }
        
        priceSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(guideStackView.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.trailing.equalTo(resultStackView.snp.trailing)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(wholeContainerView)
            make.height.equalTo(50)
            make.top.equalTo(wholeContainerView.snp.bottom)
        }
        
        expectedCostGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.bottom.equalTo(completeButton.snp.top).offset(-12)
        }
        
        expectedCostLabel.snp.makeConstraints { make in
            make.trailing.equalTo(resultStackView.snp.trailing)
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.bottom.equalTo(completeButton.snp.top).offset(-12)
        }
    }
    
    private let topViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        return view
    }()
    
    private let topViewLabel: UILabel = {
        let label = UILabel()
        label.text = "설문 요청 확인"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let expectedTimeInMinGuideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "예상 소요 시간"
        label.textAlignment = .center
        return label
    }()
    
    private let numberOfSpecimenLabel: UILabel = {
        let label = UILabel()
        label.text = "설문 참여 인원"
        label.textAlignment = .center
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.multiply.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private let expectedCostGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "총 예상 비용"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let guideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let expectedTimeInMinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let numberOfSpecimenTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = UIColor.systemBlue
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textField.layer.cornerRadius = 6
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let expectedCostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let resultStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        return stackView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("요청", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.applyCornerRadius(on: .bottom, radius: 10)
        return button
    }()
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            wholeContainerView.transform = CGAffineTransform(translationX: 0, y: -100)
            completeButton.transform = CGAffineTransform(translationX: 0, y: -100)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        wholeContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
        completeButton.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}


extension ConfirmationController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.selectAll(nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let numberOfSpecimens = Int(text) else { fatalError() }
        postingService.setNumberOfSpecimens(numberOfSpecimens)
        configureLayout()
    }
}
