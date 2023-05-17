//
//  DiffableCollectionViewPractice.swift
//  Survy
//
//  Created by Mac mini on 2023/05/18.
//

import Foundation
import UIKit
import SnapKit

class DiffableCollectionViewPractice: UIViewController {

    
    struct MyItem: Hashable {
        let id = UUID()
        let name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        setupLayout()
        setupInitialValues()
        
    }
    
    var myDataSource: UICollectionViewDiffableDataSource<Section, MyItem>!
    
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
    
    private var myCollectionView: UICollectionView!
    
    private func setupCollectionView() {
        let layout = createSelectableTagLayout()
        myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    private func configureDataSource() {
        
        let myCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, MyItem> { (cell, indexPath, category) in
            cell.backgroundColor = .magenta
        }

        myDataSource = UICollectionViewDiffableDataSource<Section, MyItem>(collectionView: myCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: MyItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: myCellRegistration, for: indexPath, item: identifier)
         }
    }
    
    private func setupLayout() {
        self.view.addSubview(myCollectionView)
        myCollectionView.snp.makeConstraints { make in
//            make.leading.top.trailing.bottom.equalToSuperview()
            make.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupInitialValues() {
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, MyItem>()
//        snapShot.appendSections([.gender, .age, .location])
        snapShot.appendSections([.main])
        let items: [MyItem] = [MyItem(name: "hi"), MyItem(name: "bye")]
        snapShot.appendItems(items)
//        snapShot.appendItems(genders, toSection: .gender)
//        snapShot.appendItems(ages, toSection: .age)
//        snapShot.appendItems(locations, toSection: .location)
        myDataSource.apply(snapShot)
    }
}


