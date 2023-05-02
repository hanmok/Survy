////
////  CategoryButton.swift
////  Survy
////
////  Created by Mac mini on 2023/05/02.
////
//
//import UIKit
//
///// 선택 Toggle 시 메시지를 전달해줘야함.
//class CategoryButton: UIButton {
//
//
////    public var categoryDelegate: CategoryButtonDelegate?
//
//    private let circularBackground: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    var wrappedTitle: String?
//
//    public func setWrappedTitle(_ title: String) {
//        wrappedButton.setTitle(title, for: .normal)
//        wrappedTitle = title
//    }
//
////    override var isSelected: Bool {
////        didSet {
////            setSelected(isSelected)
////        }
////    }
//
//    public let wrappedButton: UIButton = {
//        let button = UIButton()
//        return button
//    }()
//
////    private func setSelected(_ isSelected: Bool) {
////        if isSelected {
////            circularBackground.backgroundColor = UIColor(white: 0.3, alpha: 1)
////            wrappedButton.setTitleColor(.white, for: .normal)
////        } else {
////            circularBackground.backgroundColor = .clear
////            wrappedButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
////        }
////    }
//
////    @objc func wrapperTapped() {
////        wrappedButton.isSelected = !wrappedButton.isSelected
////        let isSelected = wrappedButton.isSelected
//////        setSelected(isSelected)
////        guard let wrappedTitle = wrappedTitle else { fatalError() }
//////        categoryDelegate?.tagSelected(wrappedTitle, isSelected)
////    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//
////        wrappedButton.addTarget(self, action: #selector(wrapperTapped), for: .touchUpInside)
//
////        addSubview(circularBackground)
////        circularBackground.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
//
////        circularBackground.addSubview(wrappedButton)
////        wrappedButton.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
//
////        circularBackground.backgroundColor = .clear
////        wrappedButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//protocol CategoryButtonDelegate {
//    func tagSelected(_ tagName: String, _ isSelected: Bool)
//}
