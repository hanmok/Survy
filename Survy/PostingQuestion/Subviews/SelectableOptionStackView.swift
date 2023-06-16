//
//  PostingSelectableOptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import Model

class SelectableOptionStackView: UIStackView {
    var briefQuestionType: BriefQuestionType? {
        didSet {
            guard let briefQuestionType = briefQuestionType else { return }
            // not called
            changeQuestionType(briefQuestionType)
        }
    }
    
    public var selectableOptionFieldViews: [SelectableOptionFieldView] = []
    
    public func addSelectableOptionView(_ selectableOptionFieldView: SelectableOptionFieldView) {
        selectableOptionFieldViews.append(selectableOptionFieldView)
        addArrangedSubview(selectableOptionFieldView)
        selectableOptionFieldView.selectableOptionTextField.becomeFirstResponder()
    }
    
    public func removeSelectableOptions() {
        self.selectableOptionFieldViews.removeAll()
    }
    
    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 6
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeQuestionType(_ briefQuestionType: BriefQuestionType) {
        
    }
}
