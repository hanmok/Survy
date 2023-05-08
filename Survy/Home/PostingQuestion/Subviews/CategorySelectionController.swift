//
//  CategorySelectingController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/08.
//

import UIKit

class CategorySelectionController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        setupNavigationBar()
        setupTargets()
        setupLayout()
    }
    
    private let topViewContainer: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.6, alpha: 1)
        view.backgroundColor = .mainColor
        return view
    }()
    
    private let topViewLabel: UILabel = {
        let label = UILabel()
        label.text = "관심사 설정"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem = nil
    }
    
    private func setupTargets() {
        completeButton.addTarget(self, action: #selector(completeTapped(_:)), for: .touchUpInside)
    }
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()
    
    @objc func completeTapped(_ sender: UIButton) {
        
        coordinator?.manipulate(.categorySelection, command: .dismiss)
        
    }
    
    private let selectedCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0xD9D9D9, alpha: 1)
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.search
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private let categoryListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private func setupLayout() {
        [selectedCategoryCollectionView, searchContainerView, categoryListCollectionView, completeButton, topViewContainer].forEach { self.view.addSubview($0) }
        
        [topViewLabel].forEach { self.topViewContainer.addSubview($0) }
        
        [searchImageView, searchTextField].forEach { self.searchContainerView.addSubview($0) }
        
        topViewContainer.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        topViewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        selectedCategoryCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(topViewContainer.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        
        searchContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(selectedCategoryCollectionView.snp.bottom).offset(20)
            make.height.equalTo(46)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(26)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}
