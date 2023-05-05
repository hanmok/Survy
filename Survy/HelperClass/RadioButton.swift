//
//  SelectableButtons.swift
//  MultiPeer
//
//  Created by 핏투비 iOS on 2022/05/11.
//

import UIKit
import SnapKit
//import Then

class RadioButton: UIButton, Identifiable {
    public var id = UUID()
    public var title: String

    public var isSelected_: Bool {
        get {
            return self.isSelected
        }
        set {
            self.isSelected = newValue
        }
    }

    public var parentContainer: RadioButtonStackView?

    init(title: String, shouldSet: Bool = true, frame: CGRect = .zero) {
        self.title = title
        super.init(frame: frame)

        if shouldSet {
            self.setTitle(title, for: .normal)
            self.setTitleColor(.black, for: .normal)
        }
    }

    public func changeSelectedState(isSelected: Bool, appliedColor: UIColor, titleColor: UIColor) {
        self.backgroundColor = appliedColor
        self.setTitleColor(titleColor, for: .normal)
    }

    public func setIsSelected(to isSelected: Bool) {
        self.isSelected_ = isSelected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
