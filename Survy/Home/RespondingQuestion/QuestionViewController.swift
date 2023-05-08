//
//  QuestionViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import UIKit
import SnapKit
import Model

// Coordinator pattern 필요할 것 같은데 ??

class QuestionViewController: BaseViewController, Coordinating {

    @objc func otherViewTapped() {
        view.dismissKeyboard()
    }
    
    var coordinator: Coordinator?
    
    var surveyService: SurveyService
    
    init(surveyService: SurveyServiceType) {
        self.surveyService = surveyService as! SurveyService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTargets() {
        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        setupTargets()
        setupLayout()

        view.backgroundColor = .mainBackgroundColor
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(otherViewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureLayout() {
//        guard let questionType = questionType else { return }
//        guard let selectableOptions = selectableOptions else { return }
        
        optionStackView.optionStackViewDelegate = self
        
        guard let question = surveyService.currentQuestion,
              let percentage = surveyService.percentage else { return }
        
        questionLabel.text = "\(question.position). \(question.text)"
        percentageLabel.text = "\(Int(percentage * 100))%"
        
        if surveyService.isLastQuestion {
            nextButton.setTitle("완료", for: .normal)
            nextButton.addCharacterSpacing()
        }
        
        // Strategy Pattern 써야 하는거 아닌가 ??
        
        // QuestionType 에 따라 갯수, 종류를 나누어야함.
        
        let selectableOptions = question.selectableOptions
        optionStackView.setQuestionType(question.questionType)
        
        switch question.questionType {
            case .singleSelection:
                for selectableOption in selectableOptions {
                    guard let value = selectableOption.value else { return }
                    let singleChoiceButton = SingleChoiceResponseButton(text: value, tag: selectableOption.position)
                    optionStackView.addSingleSelectionButton(singleChoiceButton)
                }
            case .multipleSelection:
                for selectableOption in selectableOptions {
                    guard let value = selectableOption.value else { return }
                    let multipleChoiceButton = MultipleChoiceResponseButton(text: value, tag: selectableOption.position)
                    optionStackView.addMultipleSelectionButton(multipleChoiceButton)
                }
            case .shortSentence: // Should have Placeholder
                guard let first = selectableOptions.first, let textFieldPlaceholder = first.placeHolder else { return }
                let textField = UITextField()
                textField.placeholder = textFieldPlaceholder
                optionStackView.addTextField(textField)
            case .essay: // Should have Placeholder
                break
            case .multipleSentences:
                break
        }
    }
    
    
    @objc func nextButtonTapped() {
        
        guard let question = surveyService.currentQuestion else { fatalError() }
        
        switch question.questionType {
            
            case .singleSelection:
                surveyService.selectedIndex = optionStackView.selectedIndex
            case .multipleSelection:
                surveyService.selectedIndexes = optionStackView.selectedIndices
            case .shortSentence:
                surveyService.textAnswer = optionStackView.textAnswer
            case .essay:
                surveyService.textAnswer = optionStackView.textAnswer
            case .multipleSentences:
                break
        }
        
        if !surveyService.isLastQuestion {
            surveyService.moveToNextQuestion()
            coordinator?.move(to: .questionController)
        } else {
            surveyService.initializeSurvey()
            coordinator?.move(to: .root)
        }
    }
    
    
    private func setupLayout() {
        let percentage = surveyService.percentage ?? 0.0
        [progressContainerView, questionContainerView, nextButton, quitButton]
            .forEach {
            self.view.addSubview($0)
        }
        
        [fullProgressBar, partialProgressBar, percentageLabel].forEach {
            self.progressContainerView.addSubview($0)
        }
        
        [questionLabel, optionStackView].forEach { self.questionContainerView.addSubview($0) }
        
        progressContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        fullProgressBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let filledWidth = (UIScreen.screenWidth - 40) * percentage
        partialProgressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(filledWidth)
            make.height.top.equalToSuperview()
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        questionContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(progressContainerView.snp.bottom).offset(80)
            make.height.equalTo(optionStackView.subviews.count * 40 + 50)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(questionContainerView.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        
        quitButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    // MARK: - UI Properties
    
    // MARK: - Percentage Bar
    private let progressContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let fullProgressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayProgress
        return view
    }()
    
    private let partialProgressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "0%"
        label.textColor = UIColor(white: 0.1, alpha: 1)
        return label
    }()
    
    // MARK: - Question Container
    
    private let questionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.addShadow(offset: CGSize(width: 5.0, height: 5.0))
        return view
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let optionStackView: ResponseOptionStackView = {
        let stackView = ResponseOptionStackView()
        return stackView
    }()
    
    // MARK: - Buttons
    
    private let nextButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = UIColor.mainColor
        button.backgroundColor = .grayProgress
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.addCharacterSpacing()
        button.addShadow(offset: CGSize(width: 5.0, height: 5.0))
        return button
    }()
    
    private let quitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.grayProgress
        button.setTitle("종료", for: .normal)
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.addCharacterSpacing(textColor: UIColor(white: 0.4, alpha: 1))
        return button
    }()
    
    // MARK: - Helper Functions
    @objc func quitButtonTapped() {
        
        let alertController = UIAlertController(title: "정말 종료하시겠습니까?", message: "모든 설문을 마치지 않은 채 종료하실 경우 리워드가 제공되지 않고 해당 설문에 재참여가 불가능합니다.", preferredStyle: UIAlertController.Style.alert)
        
        let quitAction = UIAlertAction(title: "종료", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.surveyService.initializeSurvey()
                self.coordinator?.move(to: .root)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        [quitAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        self.present(alertController, animated: true)
    }
}

extension QuestionViewController: OptionStackViewDelegate {
    func notifySelectionChange(to index: Int) {
        
    }
    
    func notifyConditionChange(to condition: Bool) {
        self.nextButton.isUserInteractionEnabled = condition
        self.nextButton.backgroundColor = condition ? .mainColor : .grayProgress
    }
}
