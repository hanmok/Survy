//
//  SelectableButtonStackView.swift
//  MultiPeer
//
//  Created by 핏투비 iOS on 2022/05/18.
//

import UIKit

class RadioButtonStackView: UIStackView {

    // MARK: - Properties

     var selectedBGColor: UIColor
     var defaultBGColor: UIColor

     var selectedTitleColor: UIColor
     var defaultTitleColor: UIColor

     var selectedLayerColor: UIColor
     var deafaultLayerColor: UIColor

     var prevSelectedBtnId: UUID?
     var currentSelectedBtnId: UUID?

    public var selectedBtnTitle: String = ""

    public var buttons: [RadioButton] = []

    public var selectedBtnIndex: Int?

    // MARK: - Life Cycle
    deinit {
        debugPrint(type(of: self), #function)
    }

    init(
        selectedBGColor: UIColor = .white,
        defaultBGColor: UIColor = .white,
        selectedTitleColor: UIColor = .white,
        defaultTitleColor: UIColor = .white,
        selectedLayerColor: UIColor = .clear,
        defaultLayerColor: UIColor = .clear,
        spacing: CGFloat = 16,
        cornerRadius: CGFloat = 0,
        frame: CGRect = .zero
    ) {
        self.selectedBGColor = selectedBGColor
        self.defaultBGColor = defaultBGColor

        self.selectedTitleColor = selectedTitleColor
        self.defaultTitleColor = defaultTitleColor

        self.deafaultLayerColor = defaultLayerColor
        self.selectedLayerColor = selectedTitleColor
        super.init(frame: frame)
        self.spacing = spacing
        setupSubBtnBGColor()
        setupInitialLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// add SelectableButton to self
    public func addArrangedButton(_ btn: RadioButton) {
        super.addArrangedSubview(btn)
        buttons.append(btn)
        btn.parentContainer = self
        btn.backgroundColor = defaultBGColor
    }

    public func selectBtnAction(selected id: UUID?) {
        guard let id = id else { // if id is invalid
            for button in buttons {
                if button.id == currentSelectedBtnId {
                    button.changeSelectedState(isSelected: false, appliedColor: defaultBGColor, titleColor: defaultTitleColor)
                }
            }

            currentSelectedBtnId = nil
            return
        }

        prevSelectedBtnId = currentSelectedBtnId

        for (index, button) in buttons.enumerated() {
            if button.id == id {
                currentSelectedBtnId = id
                selectedBtnIndex = index
                button.changeSelectedState(isSelected: true, appliedColor: selectedBGColor, titleColor: selectedTitleColor)
                button.setIsSelected(to: true)
                selectedBtnTitle = button.title

            } else if let validPrev = prevSelectedBtnId, validPrev == button.id {
                button.changeSelectedState(isSelected: false, appliedColor: defaultBGColor, titleColor: defaultTitleColor)

                button.setIsSelected(to: false)
            }
        }
    }

    public func selectBtnAction(with title: String) {
        var id: UUID?
        // TODO: find btn with given title
        for button in buttons {
            if button.title == title {
                id = button.id
                break
            }
        }
        selectBtnAction(selected: id)
    }

    public func setSelectedBtnNone() {
        prevSelectedBtnId = nil
        currentSelectedBtnId = nil

        buttons.forEach {
            $0.changeSelectedState(isSelected: false,
                                   appliedColor: defaultBGColor,
                                   titleColor: defaultTitleColor)
        }
    }

    private func setupSubBtnBGColor() {
        for eachBtn in buttons {
            eachBtn.backgroundColor = defaultBGColor
        }
    }

    private func setupInitialLayout() {
        self.distribution = .fillEqually
        self.spacing = spacing
    }
}
