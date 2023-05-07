//
//  PostingBlockCollectionViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import SnapKit

protocol PostingBlockCollectionViewCellDelegate {
    func questionTypeSelected(_ cell: PostingBlockCollectionViewCell, _ typeIndex: Int)
}

class PostingBlockCollectionViewCell: UICollectionViewCell {
    
    var postingBlockCollectionViewDelegate: PostingBlockCollectionViewCellDelegate?
    
    public var questionIndex: Int? {
        didSet {
            guard let index = questionIndex else { return }
            indexLabel.text = String(index) + "."
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDelegate()
        setupLayout()
    }
    
    private func setupDelegate() {
        questionTypeOptionStackView.optionStackViewDelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func otherViewTapped() {
        endEditing(true)
    }
    
    private func setupLayout() {
        
        backgroundColor = .white
        layer.cornerRadius = 16
        addShadow(offset: CGSize(width: 5.0, height: 5.0))
        
        [indexLabel, questionTextField, questionTypeOptionStackView, selectableOptionStackView].forEach {
            addSubview($0)
        }
        
        [singleSelection1, singleSelection2, singleSelection3, singleSelection4].forEach { self.questionTypeOptionStackView.addPostingSingleSelectionButton($0)}
        
        indexLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(15)
        }
        
        questionTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(indexLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(20)
        }
        
        questionTypeOptionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(questionTextField.snp.bottom).offset(14)
            make.height.equalTo(30)
        }
        
        selectableOptionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(questionTypeOptionStackView.snp.bottom).offset(20)
//            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    public var questionTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textField.placeholder = "질문을 입력해주세요."
        return textField
    }()
    
    private var singleSelection1: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단일 선택", tag: 1)
        return singleSelection
    }()
    
    private var singleSelection2: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "다중 선택", tag: 2)
        return singleSelection
    }()
    
    private var singleSelection3: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단답형", tag: 3)
        return singleSelection
    }()
    
    private var singleSelection4: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "서술형", tag: 4)
        return singleSelection
    }()
    
    public var questionTypeOptionStackView: PostingQuestionOptionStackView = {
        let postingOptionStackView = PostingQuestionOptionStackView()
        return postingOptionStackView
    }()
    
    public var selectableOptionStackView: PostingSelectableOptionStackView = {
        let stackView = PostingSelectableOptionStackView()
        return stackView
    }()
}

extension PostingBlockCollectionViewCell: OptionStackViewDelegate {
    func notifySelectionChange(to index: Int) {
        
        print("selected changed to \(index)")
        var briefQuestionType: BriefQuestionType
        switch index {
            case 1: briefQuestionType = .singleSelection
            case 2: briefQuestionType = .multipleSelection
            default: briefQuestionType = .others
        }
//        let briefQuestionType = BriefQuestionType(rawValue: index)!
        
        selectableOptionStackView.changeQuestionType(briefQuestionType)
        print("selectableOptionStackView: \(selectableOptionStackView.selectableOptionFieldViews)")
    }
    
    // 한번만 호출될걸?
    func notifyConditionChange(to condition: Bool) {
        guard let selectedIndex = questionTypeOptionStackView.selectedIndex, condition else { return }
        switch selectedIndex {
            case BriefQuestionType.singleSelection.rawValue: // 단일선택
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .singleSelection)
//                selectableOptionStackView.addArrangedSubview(selectableOptionFieldView)
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)

            case BriefQuestionType.multipleSelection.rawValue: // 다중선택
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .multipleSelection)
//                selectableOptionStackView.addArrangedSubview(selectableOptionFieldView)
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
                
            default: // 단답형, 서술형
                let plain = SelectableOptionFieldView(briefQuestionType: .others)
//                selectableOptionStackView.addArrangedSubview(plain)
                selectableOptionStackView.addSelectableOptionView(plain)
        }
        
        
        
        postingBlockCollectionViewDelegate?.questionTypeSelected(self, selectedIndex)
    }
}
