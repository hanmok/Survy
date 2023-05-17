
//
//  CategorySelectingController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/08.
//

import UIKit
import Model

class TargetSelectionController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    var postingService: PostingServiceType
    
    public init(postingService: PostingServiceType) {
        self.postingService = postingService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let locations = [
        Target(id: 101, name: "서울특별시", section: .location),
        Target(id: 102, name: "경기도", section: .location),
        Target(id: 103, name: "인천광역시", section: .location),
        Target(id: 104, name: "부산광역시", section: .location),
        Target(id: 105, name: "대구광역시", section: .location),
        Target(id: 106, name: "강원도", section: .location),
        Target(id: 107, name: "전라도", section: .location),
        Target(id: 108, name: "경상도", section: .location),
        Target(id: 109, name: "제주도", section: .location),
        Target(id: 110, name: "충청도", section: .location),
        Target(id: 111, name: "대전광역시", section: .location),
        Target(id: 112, name: "광주광역시", section: .location),
        Target(id: 113, name: "울산광역시", section: .location),
        Target(id: 114, name: "세종특별자치시", section: .location)
    ]

    let ages = [Target(id: 12, name:"20대", section: .age),
                Target(id: 13, name:"30대", section: .age),
                Target(id: 14, name:"40대", section: .age),
                Target(id: 15, name:"50대", section: .age)
    ]
    
    let genders = [
        Target(id: 1, name:"남성", section: .gender),
        Target(id: 2, name:"여성", section: .gender)
    ]
    
    enum SelectedTargetSection {
        case main
    }
    
    var selectableTargetDataSource: UICollectionViewDiffableDataSource<TargetSection, Target>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        setupNavigationBar()
        setupTargets()
        
        setupCollectionView()
        configureDataSource()
        setupLayout()
        
        setupInitialValues()
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
            
            let headerFooterSize = NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
//              heightDimension: .estimated(100)
              heightDimension: .absolute(40)
            )
            
//            let someSize = NSCollectionlayoutsize
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
              layoutSize: headerFooterSize,
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return layout
    }
    
    private func setupCollectionView() {
        let layout = createSelectableTagLayout()
        selectableTargetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        let selectedTargetsArr = Array(selectedTargets)
        postingService.setTargets(selectedTargetsArr)
        coordinator?.manipulate(.categorySelection, command: .dismiss)
    }
    
    private func setupLayout() {
        [topViewContainer,
         separatorView,
         selectableTargetCollectionView,
         completeButton].forEach { self.view.addSubview($0) }
        
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
        
        selectableTargetCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topViewContainer.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(90)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.mainColor
//        button.backgroundColor = UIColor.deeperMainColor
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
        label.text = "타겟층 설정"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.multiply.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        return view
    }()
    
    
    private var selectedTargets = Set<Target>()
    
    private var selectedTargetCollectionView: UICollectionView!
    
    private var selectableTargetCollectionView: UICollectionView!
}


extension TargetSelectionController {
    
    func registerHeader() {
        selectableTargetCollectionView.register(TargetSelectionHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TargetSelectionHeaderCell.reuseIdentifier)
    }
    
    func configureDataSource() {
        registerHeader()
        
        let selectableCellRegistration = UICollectionView.CellRegistration<SelectableTargetCell, Target> { (cell, indexPath, category) in
            cell.target = category
            cell.delegate = self
        }

        selectableTargetDataSource = UICollectionViewDiffableDataSource<TargetSection, Target>(collectionView: selectableTargetCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Target) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: selectableCellRegistration, for: indexPath, item: identifier)
         }
        
        selectableTargetDataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> TargetSelectionHeaderCell? in
            
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TargetSelectionHeaderCell.reuseIdentifier, for: indexPath) as? TargetSelectionHeaderCell

            let targetSection = TargetSection.allCases[indexPath.section]
            view?.label.attributedText = NSAttributedString(string: targetSection.rawValue, attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .semibold), .foregroundColor: UIColor.black])

            return view
        }
    }
    
    private func setupInitialValues(){
        var snapShot = NSDiffableDataSourceSnapshot<TargetSection, Target>()
        snapShot.appendSections([.gender, .age, .location])
        snapShot.appendItems(genders, toSection: .gender)
        snapShot.appendItems(ages, toSection: .age)
        snapShot.appendItems(locations, toSection: .location)
        selectableTargetDataSource.apply(snapShot)
    }
}

extension TargetSelectionController: SelectableTargetCellDelegate {
    func selectableTargetCellTapped(_ cell: SelectableTargetCell) {
        cell.isTargetSelected = !cell.isTargetSelected

        guard let target = cell.target else { return }

        if cell.isTargetSelected {
            _ = selectedTargets.insert(target)
        } else {
            selectedTargets.remove(target)
        }
        
//        let selectedTargetArr = Array(selectedTargets)
//        var snapshot = NSDiffableDataSourceSnapshot<SelectedTargetSection, Target>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(selectedTargetArr)
////        selectedTargetDataSource.apply(snapshot, animatingDifferences: true)
//        selectableTargetDataSource.apply(snapshot, animatingDifferences: true)
    }
}
