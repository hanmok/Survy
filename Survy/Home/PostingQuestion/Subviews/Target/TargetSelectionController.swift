
//
//  CategorySelectingController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/08.
//

import UIKit
import Model

struct Target: Hashable {
    let name: String
    let section: TargetSection
    let id = UUID()
    
    public static func == (lhs: Target, rhs: Target) -> Bool {
        return lhs.id == rhs.id
    }
}

enum TargetSection: String, CaseIterable {
    case gender = "Gender"
    case age = "Age"
    case location = "Location"
}

class TargetSelectionController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    let locations = [
        Target(name: "서울특별시", section: .location),
        Target(name: "경기도", section: .location),
        Target(name: "인천광역시", section: .location),
        Target(name: "부산광역시", section: .location),
        Target(name: "대구광역시", section: .location),
        Target(name: "강원도", section: .location),
        Target(name: "전라도", section: .location),
        Target(name: "경상도", section: .location),
        Target(name: "제주도", section: .location),
        Target(name: "충청도", section: .location),
        Target(name: "대전광역시", section: .location),
        Target(name: "광주광역시", section: .location),
        Target(name: "울산광역시", section: .location),
        Target(name: "세종특별자치시", section: .location)
    ]

    let ages = [Target(name:"20대", section: .age),
                Target(name:"30대", section: .age),
                Target(name:"40대", section: .age),
                Target(name:"50대", section: .age)
    ]
    
    let genders = [
        Target(name:"남성", section: .gender),
        Target(name:"여성", section: .gender)
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
