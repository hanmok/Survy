//
//  CategorySelectingController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/08.
//

import UIKit
import Model
import SnapKit
import API

enum CategorySelectionPurpose {
    case participating
    case posting
}

class CategorySelectionController: UIViewController, Coordinating {
    
    enum SelectableSection {
        case main
    }
    
    enum SelectedSection {
        case main
    }
    
    
    var coordinator: Coordinator?
    
    var postingService: PostingServiceType
    var commonService: CommonServiceType
    var participationService: ParticipationServiceType
    var purpose: CategorySelectionPurpose
    
    private var selectedTags = Set<Tag>()
    private var selectableTags = Set<Tag>()
    
    var selectedTagDataSource: UICollectionViewDiffableDataSource<SelectedSection, Tag>!
    var selectableTagDataSource: UICollectionViewDiffableDataSource<SelectableSection, Tag>!
    
    public init(postingService: PostingServiceType,
                commonService: CommonServiceType,
                participationService: ParticipationServiceType,
                purpose: CategorySelectionPurpose) {
        self.postingService = postingService
        self.commonService = commonService
        self.participationService = participationService
        self.purpose = purpose
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchedTags = commonService.allTags
        updateUI(with: fetchedTags)
    }
    
    private func updateUI(with tags: [Tag]) {
        self.selectableTags = []
        
        for tag in tags.sorted(by: <) {
            self.selectableTags.insert(tag)
        }
        
        if purpose == .participating {
            selectedTags = Set(selectableTags.filter { UserDefaults.standard.myCategories.contains($0)})
        } else {
            selectedTags = Set(postingService.selectedTags)
        }
    
        self.updateTags()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        
        setupNavigationBar()
        setupTargets()
        
        setupCollectionView()
        configureDataSource()
        setupLayout()
        
        performQuery(with: nil)
    }
    
    func createSelectedTagLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = 4
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
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
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize, subitem: item, count: columns
            )
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .absolute(UIScreen.screenWidth - 64),
                heightDimension: .absolute(CGFloat.categoryAdddingButton)
            )
            
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
              )
            
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
            
            section.boundarySupplementaryItems = [sectionFooter]
            
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
        coordinator?.manipulate(.categorySelection(nil), command: .dismiss(nil))
    }
    
    @objc func completeTapped(_ sender: UIButton) {
        // TODO: Provider 에 selectedCategory 선택
        
        let selectedTagsArr = Array(selectedTags)
        postingService.setTags(selectedTagsArr)
        
        if purpose == .participating { // Posting 하는 경우는 아직 굳이 하지 않아도 됨.
            UserDefaults.standard.myCategories = selectedTagsArr
        }
        
        coordinator?.manipulate(.categorySelection(nil), command: .dismiss(nil))
    }
    
    private func setupLayout() {
        
        self.view.addSubview(wholeContainerView)
        
        [selectedCategoryCollectionView, searchBar,
         categoryListCollectionView, completeButton, topViewContainer].forEach { self.wholeContainerView.addSubview($0) }
        
        [topViewLabel, exitButton].forEach { self.topViewContainer.addSubview($0) }
        
        wholeContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.safeAreaInsetTop)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
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
    
    // TODO: 대소문자 구분 없애기.
    private func performQuery(with text: String?) {
        var tagsToShow = [Tag]()
        if let text = text, text != "" {
            tagsToShow = selectableTags.filter { $0.name.contains(text)}.sorted(by: { tag1, tag2 in
                return tag1.name < tag2.name
            })
        } else {
            let sortedTags = Array(selectableTags).sorted()
            tagsToShow = sortedTags
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SelectableSection, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tagsToShow)
        selectableTagDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateTags() {
        print("updateTags Called")
        var selectableSnapshot = NSDiffableDataSourceSnapshot<SelectableSection, Tag>()
        selectableSnapshot.appendSections([.main])
        let sortedTags = Array(selectableTags).sorted()
        selectableSnapshot.appendItems(sortedTags)
        print("updateTags called, current number: \(sortedTags.count)")
        selectableTagDataSource.apply(selectableSnapshot, animatingDifferences: false)
        
        var selectedSnapshot = NSDiffableDataSourceSnapshot<SelectedSection, Tag>()
        selectedSnapshot.appendSections([.main])
        let sortedSelectedTags = Array(selectedTags).sorted()
        selectedSnapshot.appendItems(sortedSelectedTags)
        selectedTagDataSource.apply(selectedSnapshot, animatingDifferences: false)
        
        self.coordinator?.setIndicatorSpinning(false)
    }
    
    private var selectedCategoryCollectionView: UICollectionView!
    
    private var categoryListCollectionView: UICollectionView!
    
    private func addCategoryAction() {
        let alertController = UIAlertController(title: "관심사 추가 요청", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "New Category Name"
        }
        
        let saveAction = UIAlertAction(title: "요청", style: .default) { alert -> Void in
            guard let textFields = alertController.textFields, let text = textFields[0].text else { return }
            self.coordinator?.setIndicatorSpinning(true)
            APIService.shared.postTag(requestingTagName: text) { [weak self] result in
                self?.coordinator?.setIndicatorSpinning(false)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
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
    
    private let wholeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.applyCornerRadius(on: .all, radius: 10)
        return view
    }()
    
}

extension CategorySelectionController {
    func configureDataSource() {
        registerSupplementaryView()
        
        let selectableCellRegistration = UICollectionView.CellRegistration<SelectableCategoryCell, Tag> { (cell, indexPath, category) in
            // 여기서 처리하면 좋을 것 같은데..
            if self.selectedTags.contains(category) {
                cell.isTagSelected = true
            }
            
            cell.categoryTag = category
            cell.delegate = self
        }
        
        selectableTagDataSource = UICollectionViewDiffableDataSource<SelectableSection, Tag>(collectionView: categoryListCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Tag) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: selectableCellRegistration, for: indexPath, item: identifier)
         }
        
        selectableTagDataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategorySelectionFooterCell.reuseIdentifier, for: indexPath) as? CategorySelectionFooterCell
            view?.footerCellDelegate = self
            
            return view
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
        
    }
}

extension CategorySelectionController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

extension CategorySelectionController {
    func registerSupplementaryView() {
        categoryListCollectionView.register(CategorySelectionFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CategorySelectionFooterCell.reuseIdentifier)
    }
}

extension CategorySelectionController: SelectableCategoryCellDelegate {
    func selectableCategoryCellTapped(_ cell: SelectableCategoryCell) {
        
        // count == 4, isSelected == false
        // 4개 선택된 상태에서, 새로 선택한게 이미 선택된 상태가 아니어야함.
//        guard selectedTags.count < 4 && cell.isTagSelected == true else {
//            coordinator?.navigationController?.toastMessage(title: "관심 카테고리는 4개까지 선택 가능합니다.")
//            return
//        }
        
        if selectedTags.count == 4 && cell.isTagSelected == false {
            coordinator?.navigationController?.toastMessage(title: "관심 카테고리는 4개까지 선택 가능합니다.")
            return
        }
        
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

extension CategorySelectionController: CategorySelectionFooterCellDelegate {
    func categorySelectionFooterCellTapped() {
        addCategoryAction()
    }
}
