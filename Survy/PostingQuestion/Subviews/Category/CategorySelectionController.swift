//
//  GenreSelectingController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/08.
//

import UIKit
import Model
import SnapKit
import API

enum GenreSelectionPurpose {
    case participating
    case posting
}

class GenreSelectionController: UIViewController, Coordinating {
    
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
    var purpose: GenreSelectionPurpose
    
    private var selectedGenres = Set<Genre>()
    private var selectableGenres = Set<Genre>()
    
    var selectedGenreDataSource: UICollectionViewDiffableDataSource<SelectedSection, Genre>!
    var selectableGenreDataSource: UICollectionViewDiffableDataSource<SelectableSection, Genre>!
    
    public init(postingService: PostingServiceType,
                commonService: CommonServiceType,
                participationService: ParticipationServiceType,
                purpose: GenreSelectionPurpose) {
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
        let fetchedGenres = commonService.allGenres
        updateUI(with: fetchedGenres)
    }
    
    private func updateUI(with genres: [Genre]) {
        self.selectableGenres = []
        
        for genre in genres.sorted(by: <) {
            self.selectableGenres.insert(genre)
        }
        
        if purpose == .participating {
            selectedGenres = Set(selectableGenres.filter { UserDefaults.standard.myGenres.contains($0)})
        } else {
            selectedGenres = Set(postingService.selectedGenres)
        }
    
        self.updateGenres()
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
    
    func createSelectedGenreLayout() -> UICollectionViewLayout {
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
    
    func createSelectableGenreLayout() -> UICollectionViewLayout {
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
                heightDimension: .absolute(CGFloat.genreAdddingButton)
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
        let layout = createSelectableGenreLayout()
        genreListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let layout2 = createSelectedGenreLayout()
        selectedGenreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
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
        coordinator?.manipulate(.genreSelection(nil), command: .dismiss(nil))
    }
    
    @objc func completeTapped(_ sender: UIButton) {
        // TODO: Provider 에 selectedGenre 선택
        
        let selectedGenresArr = Array(selectedGenres)
        postingService.setGenres(selectedGenresArr)
        
        if purpose == .participating { // Posting 하는 경우는 아직 굳이 하지 않아도 됨.
            UserDefaults.standard.myGenres = selectedGenresArr
        }
        
        coordinator?.manipulate(.genreSelection(nil), command: .dismiss(nil))
    }
    
    private func setupLayout() {
        
        self.view.addSubview(wholeContainerView)
        
        [selectedGenreCollectionView, searchBar,
         genreListCollectionView, completeButton, topViewContainer].forEach { self.wholeContainerView.addSubview($0) }
        
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
        
        selectedGenreCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(topViewContainer.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(selectedGenreCollectionView.snp.bottom).offset(20)
            make.height.equalTo(46)
        }
        searchBar.delegate = self
        
        genreListCollectionView.snp.makeConstraints { make in
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
        var genresToShow = [Genre]()
        if let text = text, text != "" {
            genresToShow = selectableGenres.filter { $0.name.contains(text)}.sorted(by: { genre1, genre2 in
                return genre1.name < genre2.name
            })
        } else {
            let sortedGenres = Array(selectableGenres).sorted()
            genresToShow = sortedGenres
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SelectableSection, Genre>()
        snapshot.appendSections([.main])
        snapshot.appendItems(genresToShow)
        selectableGenreDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateGenres() {
        print("updateGenres Called")
        var selectableSnapshot = NSDiffableDataSourceSnapshot<SelectableSection, Genre>()
        selectableSnapshot.appendSections([.main])
        let sortedGenres = Array(selectableGenres).sorted()
        selectableSnapshot.appendItems(sortedGenres)
        print("updateGenres called, current number: \(sortedGenres.count)")
        selectableGenreDataSource.apply(selectableSnapshot, animatingDifferences: false)
        
        var selectedSnapshot = NSDiffableDataSourceSnapshot<SelectedSection, Genre>()
        selectedSnapshot.appendSections([.main])
        let sortedSelectedGenres = Array(selectedGenres).sorted()
        selectedSnapshot.appendItems(sortedSelectedGenres)
        selectedGenreDataSource.apply(selectedSnapshot, animatingDifferences: false)
        
        self.coordinator?.setIndicatorSpinning(false)
    }
    
    private var selectedGenreCollectionView: UICollectionView!
    
    private var genreListCollectionView: UICollectionView!
    
    private func addGenreAction() {
        let alertController = UIAlertController(title: "관심사 추가 요청", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "New Genre Name"
        }
        
        let saveAction = UIAlertAction(title: "요청", style: .default) { alert -> Void in
            guard let textFields = alertController.textFields, let text = textFields[0].text else { return }
            self.coordinator?.setIndicatorSpinning(true)
            APIService.shared.postGenre(requestingGenreName: text) { [weak self] result in
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

extension GenreSelectionController {
    func configureDataSource() {
        registerSupplementaryView()
        
        let selectableCellRegistration = UICollectionView.CellRegistration<SelectableGenreCell, Genre> { (cell, indexPath, genre) in
            // 여기서 처리하면 좋을 것 같은데..
            if self.selectedGenres.contains(genre) {
                cell.isGenreSelected = true
            }
            
            cell.genreGenre = genre
            cell.delegate = self
        }
        
        selectableGenreDataSource = UICollectionViewDiffableDataSource<SelectableSection, Genre>(collectionView: genreListCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Genre) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: selectableCellRegistration, for: indexPath, item: identifier)
            cell.layer.cornerRadius = 10
            return cell
         }
        
        selectableGenreDataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GenreSelectionFooterCell.reuseIdentifier, for: indexPath) as? GenreSelectionFooterCell
            view?.footerCellDelegate = self
            return view
        }
        
        let selectedCellRegistration = UICollectionView.CellRegistration<SelectedGenreCell, Genre> { (cell, indexPath, genre) in
            cell.genreGenre = genre
            cell.delegate = self
        }
        
        selectedGenreDataSource = UICollectionViewDiffableDataSource<SelectedSection, Genre>(collectionView: selectedGenreCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Genre) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: selectedCellRegistration, for: indexPath, item: identifier)
            cell.layer.cornerRadius = 6
            return cell
         }
    }
}

extension GenreSelectionController: SelectedGenreCellDelegate {
    func selectedGenreCellTapped(_ cell: SelectedGenreCell) {
        // TODO: Update Snapshot to remove selected genre
        
    }
}

extension GenreSelectionController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

extension GenreSelectionController {
    func registerSupplementaryView() {
        genreListCollectionView.register(GenreSelectionFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GenreSelectionFooterCell.reuseIdentifier)
    }
}

extension GenreSelectionController: SelectableGenreCellDelegate {
    func selectableGenreCellTapped(_ cell: SelectableGenreCell) {

        if selectedGenres.count == 4 && cell.isGenreSelected == false {
            coordinator?.navigationController?.toastMessage(title: "관심 카테고리는 4개까지 선택 가능합니다.")
            return
        }
        
        cell.isGenreSelected = !cell.isGenreSelected
        
        guard let genre = cell.genreGenre else { return }

        if cell.isGenreSelected {
            _ = selectedGenres.insert(genre)
        } else {
            selectedGenres.remove(genre)
        }
        
        let selectedGenreArr = Array(selectedGenres)
        var snapshot = NSDiffableDataSourceSnapshot<SelectedSection, Genre>()
        snapshot.appendSections([.main])
        snapshot.appendItems(selectedGenreArr)
        selectedGenreDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension GenreSelectionController: GenreSelectionFooterCellDelegate {
    func genreSelectionFooterCellTapped() {
        addGenreAction()
    }
}
