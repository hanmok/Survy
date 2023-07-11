//
//  QuestionViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import UIKit
import SnapKit
import Model

class QuestionViewController: BaseViewController, Coordinating {

    private var previousPercentage: CGFloat = 0
    
    @objc func otherViewTapped() {
        view.dismissKeyboard()
    }
    
    private var questionHeight: CGFloat?
    
    var coordinator: Coordinator?
    
    var participationService: ParticipationService
    
    init(participationService: ParticipationServiceType) {
        self.participationService = participationService as! ParticipationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTargets() {
        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - Fetch participation No. Not here.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        responseOptionStackView.optionStackViewDelegate = self
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
        guard let numberOfQuestions = participationService.numberOfQuestions else { return }
        print("current Questions: \(participationService.questionsToConduct)")
        switch participationService.questionProgress {
            case .undefined:
                break
            case .inProgress(let questionIndex):
                let currentQuestionIndex = questionIndex
                let previous = max(currentQuestionIndex - 1, 0)
                let current = currentQuestionIndex
                
                let startingPercentage = Int((CGFloat(previous) / CGFloat(numberOfQuestions)) * 100)
                let endPercentage = Int((CGFloat(current) / CGFloat(numberOfQuestions)) * 100)
                
                animateCounter(prev: startingPercentage, next: endPercentage)
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear) {
                    self.myProgressView.setProgress(Float(CGFloat(current) / CGFloat(numberOfQuestions)), animated: true)
                } completion: { _ in }
                
            case .ended:
                let startingPercentage = Int((CGFloat(numberOfQuestions - 1) / CGFloat(numberOfQuestions)) * 100)
                let endPercentage = 100
                animateCounter(prev: startingPercentage, next: endPercentage)
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear) {
                    self.myProgressView.setProgress(1, animated: true)
                } completion: { _ in }
        }
        
        guard let question = participationService.currentQuestion else { return }

        configureQuestionBox(question: question)
//        // FIXME: 두번쨰 Question 의 Index가 2 -> 1 로 바뀜. 왜 ??
//        let questionText = "\(question.position + 1). \(question.text)" // position: 0 부터 시작.
//
//        questionLabel.text = questionText
//
//        let approximatedWidthOfBioTextView = UIScreen.screenWidth - 20 * 2 - 12 * 2
//
//        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)
//
//        let frame = NSString(string: questionText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: questionLabel.font.pointSize)], context: nil)
//
//        questionHeight = frame.height
        
        if participationService.isLastQuestion {
            nextButton.setTitle("완료", for: .normal)
            nextButton.addCharacterSpacing()
        }
        
        guard let selectableOptions = question.selectableOptions else { fatalError() }
        guard let questionType = question.questionType else { fatalError() }
        responseOptionStackView.setQuestionType(questionType)
        
        switch question.questionType {
            case .singleSelection:
                for selectableOption in selectableOptions {
                    guard let value = selectableOption.value else { return }
                    let singleChoiceButton = SingleChoiceResponseButton(text: value, tag: selectableOption.position)
                    responseOptionStackView.addSingleSelectionButton(singleChoiceButton)
                }
            case .multipleSelection:
                for selectableOption in selectableOptions {
                    guard let value = selectableOption.value else { return }
                    let multipleChoiceButton = MultipleChoiceResponseButton(text: value, tag: selectableOption.position)
                    responseOptionStackView.addMultipleSelectionButton(multipleChoiceButton)
                }
            case .short:
                guard let first = selectableOptions.first, let textFieldPlaceholder = first.placeHolder else { return }
                let textField = UITextField()
                textField.placeholder = textFieldPlaceholder
                responseOptionStackView.addTextField(textField)
            case .essay: // Should have Placeholder
                break
            case .none:
                break
        }
    }
    
    @objc func nextButtonTapped() {
        guard let question = participationService.currentQuestion else { fatalError() }
        
        switch question.questionType {
            case .singleSelection:
                // 이거 설정해서 달라지는게 뭐야 ? API 를 나중에 호출해야하는데, 그 전까지는 아무것도 없음.
                participationService.selectedIndex = responseOptionStackView.selectedIndex
            case .multipleSelection:
                participationService.selectedIndexes = responseOptionStackView.selectedIndices
            case .short:
                participationService.textAnswer = responseOptionStackView.textAnswer
            case .essay:
                participationService.textAnswer = responseOptionStackView.textAnswer
            case .none:
                break
        }
        
        resetResponseOptionStackView()
        
        if participationService.isLastQuestion {
            participationService.increaseQuestionIndex()
            updateWithNewQuestion(isLast: true)
            participationService.resetSurvey()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                // TODO: Give message
                self?.coordinator?.move(to: .backToMainTab)
            }
        } else {
            participationService.increaseQuestionIndex()
            updateWithNewQuestion(isLast: false)
        }
    }
    
    private func resetResponseOptionStackView() {
        responseOptionStackView.reset()
    }
    
    private func performSlideAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func configureQuestionBox(question: Question) {
        let questionText = "\(question.position + 1). \(question.text)"
        
        questionLabel.text = questionText
        
        let approximatedWidthOfBioTextView = UIScreen.screenWidth - 20 * 2 - 12 * 2

        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)

        let frame = NSString(string: questionText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: questionLabel.font.pointSize)], context: nil)
        
        questionHeight = frame.height
    }
    
    private func updateQuestionBoxSize() {
        guard let question = participationService.currentQuestion else { return }
        
        configureQuestionBox(question: question)
        
        questionContainerView.snp.updateConstraints { make in
            make.height.equalTo(12 + questionHeight! + 12 + CGFloat(responseOptionStackView.subviews.count * 40) + 12)
        }
    }
    
    private func updateWithNewQuestion(isLast: Bool) {
        resetResponseOptionStackView()
        configureLayout()
        updateQuestionBoxSize()
        
        if !isLast {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: []) {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    self.questionContainerView.transform = CGAffineTransform(translationX: -UIScreen.screenWidth, y: 0)
                    self.nextButton.alpha = 0.0
                }
            } completion: { bool in
                if bool {
                    self.questionContainerView.transform = CGAffineTransform(translationX: UIScreen.screenWidth, y: 0)
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: []) {
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                            self.questionContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.nextButton.alpha = 1.0
                        }
                    }
                }
            }
            
            // 다음 버튼 아래로 보내기.
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.nextButton.snp.updateConstraints { make in
                    make.leading.trailing.equalTo(self.view.layoutMarginsGuide)
                    make.top.equalTo(self.questionContainerView.snp.bottom).offset(30)
                    make.height.equalTo(50)
                }
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.nextButton.alpha = 0.0
                self.questionContainerView.alpha = 0.0
            }
        }
        notifyConditionChange(to: false)
    }
    
    private func setupLayout() {
        [
         myProgressView,
         questionContainerView,
         nextButton, quitButton].forEach {
            self.view.addSubview($0)
        }
        
        myProgressView.addSubview(percentageLabel)
        
        [questionLabel, responseOptionStackView].forEach { self.questionContainerView.addSubview($0) }
        
        myProgressView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        print("questionHeight: \(questionHeight!)")
        
        questionContainerView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.width.equalTo(UIScreen.screenWidth - 40)
            make.top.equalTo(myProgressView.snp.bottom).offset(80)
//            make.height.equalTo(CGFloat(responseOptionStackView.subviews.count * 40) + questionHeight! + 12 + 12) // 12, 12: top, bottom inset
            
            make.height.equalTo(12 + questionHeight! + 12 + CGFloat(responseOptionStackView.subviews.count * 40) + 12)
            
//            make.height.equalTo(responseOptionStackView.subviews.count * 40 + 50) // 이거.. 높이 바꿔야함.
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        responseOptionStackView.snp.makeConstraints { make in
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
    
    private func animateCounter(prev: Int, next: Int) {
        var tracker = prev
        let interval = 1.0 / Double(next - prev)
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            tracker += 1
            DispatchQueue.main.async {
                self?.percentageLabel.text = "\(tracker)%"
            }
            if tracker == next {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let myProgressView: UIProgressView = {
        let pv = UIProgressView()
        pv.progressTintColor = UIColor.mainColor
        pv.trackTintColor = .grayProgress
        pv.layer.cornerRadius = 12
        
        pv.clipsToBounds = true
        return pv
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
        
        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private var responseOptionStackView: ResponseOptionStackView = {
        let stackView = ResponseOptionStackView()
        return stackView
    }()
    
    // MARK: - Buttons
    
    private let nextButton: UIButton = {
        let button = UIButton()
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
                self.participationService.resetSurvey()
                self.coordinator?.move(to: .backToMainTab)
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


//# Table    Create Table
//Question    CREATE TABLE `question` (
//  `id` int(11) NOT NULL AUTO_INCREMENT,
//  `questionType_id` int(11) DEFAULT NULL,
//  `section_id` int(11) DEFAULT NULL,
//  `position` int(11) NOT NULL,
//  `text` text NOT NULL,
//  `expectedTimeInSec` int(11) DEFAULT '5',
//  PRIMARY KEY (`id`),
//  KEY `FK_QuestionType_Question` (`questionType_id`),
//  KEY `FK_Section_Question` (`section_id`),
//  CONSTRAINT `FK_Section_Question` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)
//) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8
//
//
//'Question', 'CREATE TABLE `question` (\n  `id` int(11) NOT NULL AUTO_INCREMENT,\n  `questionType_id` int(11) DEFAULT NULL,\n  `section_id` int(11) DEFAULT NULL,\n  `position` int(11) NOT NULL,\n  `text` text NOT NULL,\n  `expectedTimeInSec` int(11) DEFAULT \'5\',\n  PRIMARY KEY (`id`),\n  KEY `FK_QuestionType_Question` (`questionType_id`),\n  KEY `FK_Section_Question` (`section_id`),\n  CONSTRAINT `FK_Section_Question` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)\n) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8'
//
//
//# Table, Create Table
//'Question', 'CREATE TABLE `question` (\n  `id` int(11) NOT NULL AUTO_INCREMENT,\n  `questionType_id` int(11) DEFAULT NULL,\n  `section_id` int(11) DEFAULT NULL,\n  `position` int(11) NOT NULL,\n  `text` text NOT NULL,\n  `expectedTimeInSec` int(11) DEFAULT \'5\',\n  PRIMARY KEY (`id`),\n  KEY `FK_QuestionType_Question` (`questionType_id`),\n  KEY `FK_Section_Question` (`section_id`),\n  CONSTRAINT `FK_Section_Question` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)\n) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8'
//
//
//Question, CREATE TABLE `question` (
//  `id` int(11) NOT NULL AUTO_INCREMENT,
//  `questionType_id` int(11) DEFAULT NULL,
//  `section_id` int(11) DEFAULT NULL,
//  `position` int(11) NOT NULL,
//  `text` text NOT NULL,
//  `expectedTimeInSec` int(11) DEFAULT '5',
//  PRIMARY KEY (`id`),
//  KEY `FK_QuestionType_Question` (`questionType_id`),
//  KEY `FK_Section_Question` (`section_id`),
//  CONSTRAINT `FK_Section_Question` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)
//) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8
//
//
//
//# Table, Create Table
//Question, CREATE TABLE `question` (
//  `id` int(11) NOT NULL AUTO_INCREMENT,
//  `questionType_id` int(11) DEFAULT NULL,
//  `section_id` int(11) DEFAULT NULL,
//  `position` int(11) NOT NULL,
//  `text` text NOT NULL,
//  `expectedTimeInSec` int(11) DEFAULT '5',
//  PRIMARY KEY (`id`),
//  KEY `FK_QuestionType_Question` (`questionType_id`),
//  KEY `FK_Section_Question` (`section_id`),
//  CONSTRAINT `FK_Section_Question` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)
//) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8
//
//
//CREATE TABLE `question` (
//  `id` int(11) NOT NULL AUTO_INCREMENT,
//  `questionType_id` int(11) DEFAULT NULL,
//  `section_id` int(11) DEFAULT NULL,
//  `position` int(11) NOT NULL,
//  `text` text NOT NULL,
//  `expectedTimeInSec` int(11) DEFAULT '5',
//  PRIMARY KEY (`id`),
//  KEY `FK_QuestionType_Question` (`questionType_id`),
//  KEY `FK_Section_Question` (`section_id`),
//  CONSTRAINT `FK_Section_Question` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)
//) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8
//
//
//ALTER TABLE table_name
//ADD FOREIGN KEY (column_name)
//REFERENCE table_name(Referencing column_name in table_name);
