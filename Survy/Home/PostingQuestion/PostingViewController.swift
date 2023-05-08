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
        registerCollectionView()
        setupNavigationBar()
        setupLayout()
        setupTargets()
        view.backgroundColor = UIColor(hex6: 0xF4F7FB)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(otherViewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func otherViewTapped() {
        view.endEditing(true)
    }
    
    private func setupTargets() {
        numOfSpecimenButton.addTarget(self, action: #selector(specimenButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.title = "설문 요청"
        setupLeftNavigationBar()
    }
    
    private func registerCollectionView() {
        
        postingBlockCollectionView.register(PostingBlockCollectionViewCell.self, forCellWithReuseIdentifier: PostingBlockCollectionViewCell.reuseIdentifier)
        
        postingBlockCollectionView.register(PostingBlockCollectionFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PostingBlockCollectionFooterCell.reuseIdentifier)
        
        postingBlockCollectionView.delegate = self
        postingBlockCollectionView.dataSource = self
    }
    
    private func setupLayout() {
        [targetLabel, categoryLabel, expectedCostGuideStackView, expectedCostResultStackView, requestingButton,
         postingBlockCollectionView].forEach {
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
        
        postingBlockCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.bottom.equalTo(expectedCostResultStackView.snp.top).offset(-10)
        }
    }
    
    private lazy var postingBlockCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: UIScreen.screenWidth - 40, height: 200)
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
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
    
    private let requestingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설문 요청하기", for: .normal)
        button.backgroundColor = UIColor.grayProgress
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()
}

extension PostingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingBlockCollectionViewCell.reuseIdentifier, for: indexPath) as! PostingBlockCollectionViewCell
        cell.questionIndex = indexPath.row + 1
        cell.postingBlockCollectionViewDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionFooter:
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PostingBlockCollectionFooterCell.reuseIdentifier, for: indexPath) as! PostingBlockCollectionFooterCell
                return footer
            default:
                fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.screenWidth - 40, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.screenWidth - 40, height: 240)
    }
}

extension PostingViewController: PostingBlockCollectionViewCellDelegate {
    func questionTypeSelected(_ cell: PostingBlockCollectionViewCell, _ typeIndex: Int) {
        switch typeIndex {
            case 1: // 단일선택
                break
            case 2: // 다중선택
                break
            default: // 단답형, 서술형
                break
        }
    }
}
