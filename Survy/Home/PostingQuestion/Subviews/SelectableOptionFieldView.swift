//
//  SelectableOptionTextField.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import Model

enum BriefQuestionType: Int {
    case singleSelection = 1
    case multipleSelection
    case others
}

class SelectableOptionFieldView: UIView {
    
    var briefQuestionType: BriefQuestionType
    
    public func changeType(to briefQuestionType: BriefQuestionType) {
        self.briefQuestionType = briefQuestionType
        self.configureLayout()
    }
    
    private func setupDelegate() {
        textField.delegate = self
    }
    
    init(briefQuestionType: BriefQuestionType) {
        self.briefQuestionType = briefQuestionType
        super.init(frame: .zero)
        setupDelegate()
        configureLayout()
        setupLayout()
    }
    
    private func setupLayout() {
        [optionSymbolImageView, textField].forEach { addSubview($0) }
        optionSymbolImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(optionSymbolImageView.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureLayout() {
        switch briefQuestionType {
        case .singleSelection:
            optionSymbolImageView.image = UIImage.emptyCircle
            textField.placeholder = "항목을 입력해주세요."
        case .multipleSelection:
            optionSymbolImageView.image = UIImage.uncheckedSquare
                textField.placeholder = "항목을 입력해주세요."
        default:
            optionSymbolImageView.image = nil
            textField.placeholder = "placeHolder"
        }
    }
    
    private let optionSymbolImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "항목을 입력해주세요."
        return textField
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectableOptionFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
