//
//  SelectableOptionTextField.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import Model

class SelectableOptionFieldView: UIView {
    
    var briefQuestionType: BriefQuestionType
    var selectableOption: SelectableOption
    
    public func changeType(to briefQuestionType: BriefQuestionType) {
        self.briefQuestionType = briefQuestionType
        self.configureLayout()
    }
    
    private func setupDelegate() {
        selectableOptionTextField.delegate = self
    }
    
    init(briefQuestionType: BriefQuestionType,
         selectableOption: SelectableOption) {
        self.briefQuestionType = briefQuestionType
        self.selectableOption = selectableOption
        
        super.init(frame: .zero)
        
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
                if selectableOption.value != nil {
                    selectableOptionTextField.text = selectableOption.value
                }
        case .multipleSelection:
            optionSymbolImageView.image = UIImage.uncheckedSquare
                selectableOptionTextField.placeholder = String.optionPlaceholder
                if selectableOption.value != nil {
                    selectableOptionTextField.text = selectableOption.value
                }
            case .short:
                if let value = selectableOption.value {
                    selectableOptionTextField.text = value
                } else {
                    selectableOptionTextField.placeholder = "short form placeHolder"
                }
                optionSymbolImageView.image = nil
                
            case .essay:
                if let value = selectableOption.value {
                    selectableOptionTextField.text = value
                } else {
                    selectableOptionTextField.placeholder = "essay form placeHolder"
                }
                optionSymbolImageView.image = nil
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
        UserDefaults.standard.isAddingSelectableOption = true
        guard let text = textField.text else { return true }
        print("dismisskeyboard flag 1")
        selectableOptionFieldDelegate?.selectableOptionFieldReturnTapped(text, self.selectableOption.position)
        return true
    }
}

protocol SelectableOptionFieldDelegate: AnyObject {
    func selectableOptionFieldReturnTapped(_ text: String, _ position: Int)
}

