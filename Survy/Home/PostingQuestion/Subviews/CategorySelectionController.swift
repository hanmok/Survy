//
//  CategorySelectingController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/08.
//

import UIKit
import Model

class CategorySelectionController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        setupNavigationBar()
        setupTargets()
        
        setupCollectionView()
        configureDataSource()
        setupLayout()
        
        performQuery(with: nil)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        
        return layout
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
//        categoryListCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        categoryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.multiply.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem = nil
    }
    
    private func setupTargets() {
        completeButton.addTarget(self, action: #selector(completeTapped(_:)), for: .touchUpInside)
        
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
    }
    
    @objc func exitTapped() {
        coordinator?.manipulate(.categorySelection, command: .dismiss)
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
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    let testTags = [Tag(id: 1, name: "운동"), Tag(id: 2, name: "필라테스"), Tag(id: 3, name: "PT"), Tag(id: 4, name: "애견")]
    
    private var categoryListCollectionView: UICollectionView!
    
    private func setupLayout() {
        [selectedCategoryCollectionView,
         searchBar,
         categoryListCollectionView, completeButton, topViewContainer].forEach { self.view.addSubview($0) }
        
        [topViewLabel, exitButton].forEach { self.topViewContainer.addSubview($0) }
        
        topViewContainer.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        topViewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(24)
        }
        
        selectedCategoryCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(topViewContainer.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        
//        searchContainerView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.top.equalTo(selectedCategoryCollectionView.snp.bottom).offset(20)
//            make.height.equalTo(46)
//        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(selectedCategoryCollectionView.snp.bottom).offset(20)
            make.height.equalTo(46)
        }
        searchBar.delegate = self
        
        categoryListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(90)
        }
        
//        searchImageView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(6)
//            make.top.bottom.equalToSuperview().inset(10)
//            make.width.equalTo(26)
//        }
        
//        searchTextField.snp.makeConstraints { make in
//            make.leading.equalTo(searchImageView.snp.trailing).offset(10)
//            make.trailing.equalToSuperview().inset(10)
//            make.top.bottom.equalToSuperview().inset(6)
//        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func performQuery(with text: String?) {
        var tagsToShow = [Tag]()
        if let text = text, text != "" {
            tagsToShow = testTags.filter { $0.name.contains(text)}.sorted(by: { tag1, tag2 in
                return tag1.name < tag2.name
            })
        } else {
            tagsToShow = testTags
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tagsToShow)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CategorySelectionController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CategorySearchCell, Tag> { (cell, indexPath, category) in
            cell.categoryTag = category
            cell.delegate = self
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: categoryListCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Tag) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}


extension CategorySelectionController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

extension CategorySelectionController: CategorySearchCellDelegate {
    func categorySearchCellTapped(_ cell: CategorySearchCell) {
        print(cell.categoryTag?.name)
    }
}
