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
    var postingService: PostingServiceType
    
    public init(postingService: PostingServiceType) {
        self.postingService = postingService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedTags = Set<Tag>()
    
    public let testTags = [
        Tag(id: 1, name: "운동"),
        Tag(id: 2, name: "필라테스"),
        Tag(id: 3, name: "PT"),
        Tag(id: 4, name: "애견")
    ]
    
    enum SelectableSection {
        case main
    }
    
    enum SelectedSection {
        case main
    }
    
    var selectedTagDataSource: UICollectionViewDiffableDataSource<SelectedSection, Tag>!
    
    var selectableTagDataSource: UICollectionViewDiffableDataSource<SelectableSection, Tag>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        
//        view.layer.cornerRadius = 10
//        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        
        setupNavigationBar()
        setupTargets()
        
        setupCollectionView()
        configureDataSource()
        setupLayout()
        
        performQuery(with: nil)
    }
    
    private let wholeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.applyCornerRadius(on: .top, radius: 10)
        return view
    }()
    
    func createSelectedTagLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let contentSize = layoutEnvironment.container.effectiveContentSize
//            let columns = contentSize.width > 800 ? 3 : 2
            let columns = 4
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .absolute(32))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(20))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        
        return layout
    }
    
    func createSelectableTagLayout() -> UICollectionViewLayout {
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
        let layout = createSelectableTagLayout()
        categoryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let layout2 = createSelectedTagLayout()
        selectedCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
    }
    
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
    
    @objc func completeTapped(_ sender: UIButton) {
        // TODO: Provider 에 selectedCategory 선택
        
        let selectedTagsArr = Array(selectedTags)
        postingService.setTags(selectedTagsArr)
        coordinator?.manipulate(.categorySelection, command: .dismiss)
    }
    
    private func setupLayout() {
        
        self.view.addSubview(wholeContainerView)
        [selectedCategoryCollectionView,
         searchBar,
         categoryListCollectionView, completeButton, topViewContainer].forEach { self.wholeContainerView.addSubview($0) }
        
        [topViewLabel, exitButton].forEach { self.topViewContainer.addSubview($0) }
        
        wholeContainerView.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
        
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
        
        var snapshot = NSDiffableDataSourceSnapshot<SelectableSection, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tagsToShow)
        selectableTagDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()
    
    private let topViewContainer: UIView = {
        let view = UIView()
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
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    private var selectedCategoryCollectionView: UICollectionView!
    
    private var categoryListCollectionView: UICollectionView!
}

extension CategorySelectionController {
    func configureDataSource() {
        let selectableCellRegistration = UICollectionView.CellRegistration<SelectableCategoryCell, Tag> { (cell, indexPath, category) in
            cell.categoryTag = category
            cell.delegate = self
        }
        
        selectableTagDataSource = UICollectionViewDiffableDataSource<SelectableSection, Tag>(collectionView: categoryListCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Tag) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: selectableCellRegistration, for: indexPath, item: identifier)
         }
        
        let selectedCellRegistration = UICollectionView.CellRegistration<SelectedCategoryCell, Tag> { (cell, indexPath, category) in
            cell.categoryTag = category
            cell.delegate = self
        }
        
        selectedTagDataSource = UICollectionViewDiffableDataSource<SelectedSection, Tag>(collectionView: selectedCategoryCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Tag) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: selectedCellRegistration, for: indexPath, item: identifier)
         }
    }
}


extension CategorySelectionController: SelectedCategoryCellDelegate {
    func selectedCategoryCellTapped(_ cell: SelectedCategoryCell) {
        // TODO: Update Snapshot to remove selected tag
        
        // 뭘 할 수가 없는데..??
    }
}

extension CategorySelectionController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

extension CategorySelectionController: SelectableCategoryCellDelegate {
    func selectableCategoryCellTapped(_ cell: SelectableCategoryCell) {
        cell.isTagSelected = !cell.isTagSelected
        
        guard let category = cell.categoryTag else { return }

        if cell.isTagSelected {
            _ = selectedTags.insert(category)
        } else {
            selectedTags.remove(category)
        }
        
        let selectedTagArr = Array(selectedTags)
        var snapshot = NSDiffableDataSourceSnapshot<SelectedSection, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(selectedTagArr)
        selectedTagDataSource.apply(snapshot, animatingDifferences: true)
    }
}
