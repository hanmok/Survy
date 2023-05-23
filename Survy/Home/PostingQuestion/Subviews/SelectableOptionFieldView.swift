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
        selectableOptionTextField.delegate = self
    }
    
    init(briefQuestionType: BriefQuestionType, tag: Int) {
        self.briefQuestionType = briefQuestionType
        super.init(frame: .zero)
        self.tag = tag
        setupDelegate()
        configureLayout()
        setupLayout()
    }
    
    private func setupLayout() {
        [optionSymbolImageView, selectableOptionTextField].forEach { addSubview($0) }
        optionSymbolImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        
        selectableOptionTextField.snp.makeConstraints { make in
            make.leading.equalTo(optionSymbolImageView.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureLayout() {
        switch briefQuestionType {
        case .singleSelection:
            optionSymbolImageView.image = UIImage.emptyCircle
                selectableOptionTextField.placeholder = String.optionPlaceholder
        case .multipleSelection:
            optionSymbolImageView.image = UIImage.uncheckedSquare
                selectableOptionTextField.placeholder = String.optionPlaceholder
        default:
            optionSymbolImageView.image = nil
            selectableOptionTextField.placeholder = "placeHolder"
        }
    }
    
    private let optionSymbolImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public let selectableOptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String.optionPlaceholder
        return textField
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var selectableOptionFieldDelegate: SelectableOptionFieldDelegate?
}

extension SelectableOptionFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        selectableOptionFieldDelegate?.notifyReturnButtonTapped(text, self.tag)
        return true
    }
}

protocol SelectableOptionFieldDelegate: AnyObject {
    func notifyReturnButtonTapped(_ text: String, _ tag: Int)
}

