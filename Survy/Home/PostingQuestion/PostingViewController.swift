//
//  PostingViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/06.
//

import UIKit
import Model
import SnapKit
import Toast

class PostingViewController: BaseViewController, Coordinating {
    
    var currentTags: [Tag] = []
    
    var currentTargets: [Target] = []
    
    var coordinator: Coordinator?
    
    var numOfSpecimen: Int = 100
    
    var postingService: PostingServiceType
    
    var questionCellHeights = Set<CellHeight>()
    var tableViewTotalHeight: CGFloat {
        return questionCellHeights.map { $0.height }.reduce(0, +)
    }
    
    private var targetDataSource: UICollectionViewDiffableDataSource<Section, Target>!
    private var tagDataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    
    let marginSize = 12
    enum Section {
        case main
    }
    
    public init(postingService: PostingServiceType) {
        self.postingService = postingService
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let wholeHeight = tableViewTotalHeight + 100 + 52 + 20 + 16 + 100
//        scrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 3)
        print("wholeHeight: \(wholeHeight)")
        scrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: wholeHeight)
        
        // FIXME: scroll to the bottom if new question has added
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height)
        
        if wholeHeight > UIScreen.screenHeight - 100 {
            scrollView.setContentOffset(bottomOffset, animated: false)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if postingService.numberOfQuestions == 0 {
            postingService.addQuestion()
        }
        
        registerPostingBlockCollectionView()
        
        setupTopCollectionViews()
        configureTopDataSource()
        
        setupNavigationBar()
        
        setupLayout()
        setupTargets()
        
        view.backgroundColor = UIColor.postingVCBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(otherViewTapped))
        view.addGestureRecognizer(tapGesture)
        
        setupInitialSnapshot()
    }
    
    // MARK: - CollectionView, TableView Setup
    
    private func registerPostingBlockCollectionView() {
        postingBlockCollectionView.register(PostingBlockCollectionViewCell.self, forCellWithReuseIdentifier: PostingBlockCollectionViewCell.reuseIdentifier)
        
        postingBlockCollectionView.register(PostingBlockCollectionFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PostingBlockCollectionFooterCell.reuseIdentifier)
        
        postingBlockCollectionView.delegate = self
        postingBlockCollectionView.dataSource = self
    }
    
    private func setupTopCollectionViews() {
        let layout = createLayout()
        
        selectedTagsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectedTargetsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        selectedTagsCollectionView.backgroundColor = .magenta
        selectedTargetsCollectionView.backgroundColor = .cyan
    }
    
    private func configureTopDataSource() {
        let tagCellRegistration = UICollectionView.CellRegistration<TagLabelCollectionViewCell, Tag> {
            (cell, indexPath, tag) in
            cell.text = tag.name
        }

        tagDataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: selectedTagsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Tag) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: tagCellRegistration, for: indexPath, item: identifier)
        }
        
        let targetCellRegistration = UICollectionView.CellRegistration<TargetLabelCollectionViewCell, Target> {
            (cell, indexPath, target) in
            cell.text = target.name
        }

        targetDataSource = UICollectionViewDiffableDataSource<Section, Target>(collectionView: selectedTargetsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Target) -> UICollectionViewCell? in
             return collectionView.dequeueConfiguredReusableCell(using: targetCellRegistration, for: indexPath, item: identifier)
        }
    }
    
    override func updateMyUI() {
        questionCellHeights.removeAll()
        if postingService.selectedTags != currentTags {
            currentTags = postingService.selectedTags
            var tagSnapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
            tagSnapshot.appendSections([.main])
            tagSnapshot.appendItems(currentTags)
            tagDataSource.apply(tagSnapshot)
            
        }
        
        if postingService.selectedTargets != currentTargets {
            currentTargets = postingService.selectedTargets
            var targetSnapshot = NSDiffableDataSourceSnapshot<Section, Target>()
            targetSnapshot.appendSections([.main])
            targetSnapshot.appendItems(currentTargets)
            self.targetDataSource.apply(targetSnapshot, animatingDifferences: true)
        }
    }
    
    
    private func setupInitialSnapshot() {
        var tagSnapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        tagSnapshot.appendSections([.main])
        tagSnapshot.appendItems(currentTags, toSection: .main)
        tagDataSource.apply(tagSnapshot)
        
        var targetSnapshot = NSDiffableDataSourceSnapshot<Section, Target>()
        targetSnapshot.appendSections([.main])
        targetSnapshot.appendItems(currentTargets)
        targetDataSource.apply(targetSnapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
//            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = 5
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing

            return section
        }
        return layout
    }
    
    
    // MARK: - Helper functions
    
    private func setupTargets() {
        requestingButton.addTarget(self, action: #selector(requestSurveyTapped), for: .touchUpInside)
        targetButton.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    @objc func otherViewTapped() {
        view.dismissKeyboard()
    }
    
    @objc func targetTapped(_ sender: UIButton) {
        view.dismissKeyboard()
        coordinator?.manipulate(.targetSelection, command: .present)
    }
    
    @objc func categoryTapped(_ sender: UIButton) {
        view.dismissKeyboard()
        coordinator?.manipulate(.categorySelection, command: .present)
    }
    
    @objc func requestSurveyTapped(_ sender: UIButton) {
        print("current PostingQuestions: ")
        print("number of Questions: \(postingService.numberOfQuestions)")
        postingService.postingQuestions.forEach {
            print("question: \($0.question), questionType: \($0.briefQuestionType)")
            $0.selectableOptions.forEach {
                print("options: \($0.value)")
            }
        }
        coordinator?.manipulate(.confirmation, command: .present)
    }
    
    @objc func dismissTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        [
//        targetButton, categoryButton,
//         selectedTargetsCollectionView,
//         selectedTagsCollectionView,
//        postingBlockCollectionView,
            scrollView,
         expectedTimeGuideLabel, expectedTimeResultLabel,
         requestingButton
         ].forEach {
            self.view.addSubview($0)
        }
        
        [
            targetButton, categoryButton,
            selectedTargetsCollectionView,
            selectedTagsCollectionView,
            postingBlockCollectionView
        ].forEach {
            self.scrollView.addSubview($0)
        }
        
        requestingButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        expectedTimeResultLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(requestingButton.snp.top).offset(-20)
            make.width.equalTo(50)
        }
        
        expectedTimeGuideLabel.snp.makeConstraints { make in
            make.trailing.equalTo(expectedTimeResultLabel.snp.leading).offset(-10)
            make.bottom.equalTo(expectedTimeResultLabel.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.leading.equalTo(view.layoutMarginsGuide)
            make.leading.equalToSuperview()
//            make.width.equalTo(UIScreen.screenWidth - 40)
            make.width.equalTo(UIScreen.screenWidth)
            make.bottom.equalTo(expectedTimeGuideLabel.snp.top).offset(-10)
        }
        
//        postingBlockCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        targetButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.leading.equalTo(view.layoutMarginsGuide)
//            make.top.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(26)
        }
        
        targetButton.addSmallerInsets()
        
        selectedTargetsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(targetButton.snp.top)
            make.bottom.equalTo(targetButton.snp.bottom)
            make.leading.equalTo(targetButton.snp.trailing).offset(10)
//            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(300)
        }
        selectedTargetsCollectionView.backgroundColor = .clear
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(targetButton.snp.bottom).offset(20)
//            make.leading.equalTo(view.layoutMarginsGuide)
//            make.leading.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(26)
        }
        
        categoryButton.addSmallerInsets()
        
        selectedTagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.top)
            make.bottom.equalTo(categoryButton.snp.bottom)
            make.leading.equalTo(categoryButton.snp.trailing).offset(10)
//            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(300)
        }
        selectedTagsCollectionView.backgroundColor = .clear
        
        
        
        postingBlockCollectionView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.width.equalToSuperview()
//            make.leading.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
//            make.width.equalTo(UIScreen.screenWidth - 40)
            make.width.equalTo(UIScreen.screenWidth)
            make.top.equalTo(categoryButton.snp.bottom).offset(16)
            make.bottom.equalTo(expectedTimeGuideLabel.snp.top).offset(-10)
        }
    }
    
    private func setupNavigationBar() {
        self.title = "설문 요청"
        setupLeftNavigationBar()
    }
    
    private func setupLeftNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage.leftChevron, style: .plain, target: self, action: #selector(dismissTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Views
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private var selectedTargetsCollectionView: UICollectionView!
    private var selectedTagsCollectionView: UICollectionView!
    
    private lazy var postingBlockCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
//        layout.scrollDirection = .vertical
        
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let anotherLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let someConfig = UICollectionViewCompositionalLayoutConfiguration()
        someConfig.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let targetButton: UIButton = {
        let button = UIButton()
        let attributedString = NSAttributedString(string: "타겟층", attributes: [.foregroundColor: UIColor.systemBlue, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)])
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        return button
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        let attributedString = NSAttributedString(string: "관심사", attributes: [.foregroundColor: UIColor.systemBlue, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)])
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        return button
    }()
    
    private let expectedTimeGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 소요시간"
        return label
    }()
    
    private let expectedTimeResultLabel: UILabel = {
        let label = UILabel()
        label.text = "1분"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        questionCellHeights.removeAll()
        return max(postingService.numberOfQuestions, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingBlockCollectionViewCell.reuseIdentifier, for: indexPath) as! PostingBlockCollectionViewCell
        
        cell.postingBlockCollectionViewDelegate = self
        cell.questionIndex = indexPath.row + 1
        
        let cellHeight = CellHeight(index: indexPath.row, height: 150 + 20) // spacing
        self.questionCellHeights.insert(cellHeight)
        viewDidAppear(false)
        let postingQuestion = postingService.postingQuestions[indexPath.row]
        cell.postingQuestion = postingQuestion
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionFooter:
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PostingBlockCollectionFooterCell.reuseIdentifier, for: indexPath) as! PostingBlockCollectionFooterCell
                footer.footerDelegate = self
                return footer
            default:
                fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.screenWidth - 100, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // selectableStackView 내 갯수에 따라 변할 수 있어야 함.
//        return CGSize(width: UIScreen.screenWidth - 40, height: 240)
        return CGSize(width: UIScreen.screenWidth - 40, height: 150)
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

extension PostingViewController: PostingBlockCollectionFooterDelegate {
    func addQuestionButtonTapped() {
        postingService.addQuestion()
        DispatchQueue.main.async {
            self.postingBlockCollectionView.reloadData()
        }
    }
}
