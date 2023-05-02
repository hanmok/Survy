//
//  QuestionViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import UIKit
import SnapKit

// Coordinator pattern 필요할 것 같은데 ??

class QuestionViewController: BaseViewController {

    var percentage: CGFloat = 0.13
    var questionType: QuestionType?
    var selectableOptions: [SelectableOption]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        setupLayout()
        
        callApi()
    }
    
    func callApi() {
        APIManager.shared.testCall()
    }
    
    private func configureLayout() {
        guard let questionType = questionType else { return }
        guard let selectableOptions = selectableOptions else { return }
        
        // QuestionType 에 따라 갯수, 종류를 나누어야함.
        switch questionType {
        case .essay:
            break
        case .shortSentence:
            break
            
        case .singleSelection:
            break
        case .muiltipleSelection:
            break
        case .multipleSentences:
            break
        }
        
//        optionStackView
    }
    
    private func setupLayout() {
        [progressContainerView, questionContainerView, nextButton]
            .forEach {
            self.view.addSubview($0)
        }
        
        [fullProgressBar, partialProgressBar, percentageLabel].forEach {
            self.progressContainerView.addSubview($0)
        }
        
        [questionLabel, optionStackView].forEach { self.questionContainerView.addSubview($0) }
        
        
        progressContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(30)
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
        
        // Height: Intrinsic Size 에 맡겨야함.
        questionContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(progressContainerView.snp.bottom).offset(80)
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
    }
    
    
    // MARK: - Percentage Bar
    private let progressContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let fullProgressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0xD9D9D9)
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
        label.text = "13%"
        label.textColor = UIColor(white: 0.1, alpha: 1)
        return label
    }()
    
    
    
    // MARK: - Question Container
    
    private let questionContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Others
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainColor
        return button
    }()
}
