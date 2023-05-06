//
//  PostingViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/06.
//

import UIKit
import Model
import SnapKit

class PostingViewController: BaseViewController {
    
    var numOfSpecimen: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupTargets()
        view.backgroundColor = UIColor(hex6: 0xF4F7FB)
    }
    
    private func setupTargets() {
        numOfSpecimenButton.addTarget(self, action: #selector(specimenButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.title = "설문 요청"
        setupLeftNavigationBar()
    }
    
    private func setupLayout() {
        [targetLabel, categoryLabel, expectedCostGuideStackView, expectedCostResultStackView, requestingButton, plusButton].forEach {
            self.view.addSubview($0)
        }
        
        expectedCostGuideStackView.addArrangedSubviews([numOfSpecimenGuideLabel, expectedTimeGuideLabel, expectedCostGuideLabel])
        
        expectedCostResultStackView.addArrangedSubviews([numOfSpecimenButton, expectedTimeResultLabel, expectedCostResultLabel])
        
        targetLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(26)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(targetLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(26)
        }
        
        requestingButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        plusButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.height.equalTo(140)
        }

        
        expectedCostResultStackView.snp.makeConstraints { make in
            make.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(86)
            make.bottom.equalTo(requestingButton.snp.top).offset(-20)
            make.width.equalTo(100)
        }
        
        expectedCostGuideStackView.snp.makeConstraints { make in
            make.trailing.equalTo(expectedCostResultStackView.snp.leading).offset(-10)
            make.height.equalTo(expectedCostResultStackView.snp.height)
            make.bottom.equalTo(requestingButton.snp.top).offset(-20)
            make.width.equalTo(100)
        }
    }
    
    private func setupLeftNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage.leftChevron, style: .plain, target: self, action: #selector(dismissTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dismissTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func specimenButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "표본 수를 입력해주세요", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] alert -> Void in
            let textFieldInput = alertController.textFields![0] as UITextField
            guard let text = textFieldInput.text, let numOfSpecimenInput = Int(text) else { fatalError() }
            self?.numOfSpecimen = numOfSpecimenInput
            self?.numOfSpecimenButton.setTitle(String(numOfSpecimenInput) + "명", for: .normal)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        [cancelAction, saveAction].forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Views
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "타겟층 지정"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "관심사 지정"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let expectedCostGuideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let expectedCostResultStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let numOfSpecimenGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "표본 수"
        return label
    }()
    
    private let expectedTimeGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 소요시간"
        return label
    }()
    
    private let expectedCostGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 비용"
        return label
    }()
    
    
    
    private let numOfSpecimenButton: UIButton = {
        let button = UIButton()
        button.setTitle("100명", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .right
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.addInsets(top: 5.0, bottom: 5.0, left: 0, right: 5.0)
        return button
    }()
    
    private let expectedTimeResultLabel: UILabel = {
        let label = UILabel()
        label.text = "1분"
        label.textAlignment = .right
        return label
    }()
    
    private let expectedCostResultLabel: UILabel = {
        let label = UILabel()
        label.text = "30,000P"
        label.textAlignment = .right
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .mainColor
        button.addShadow(offset: CGSize(width: 5.0, height: 5.0))
        let image = UIImage.plus.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        button.addImageToCenter(image: image)
        return button
    }()
    
    private let requestingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설문 요청하기", for: .normal)
        button.backgroundColor = UIColor.grayProgress
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()
}
