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
    
    var currentGenres: [Genre] = []
    
    var currentTargets: [Target] = []
    
    var coordinator: Coordinator?
    
    var numOfSpecimen: Int = 100
    private let selectableOptionHeight: CGFloat = 27
//    private let defaultCellHeight: CGFloat = 120
    private let defaultCellHeight: CGFloat = 120
    
    var postingService: PostingServiceType
    
    var questionCellHeights = Set<CellHeight>()
    
    var tableViewTotalHeight: CGFloat {
        return questionCellHeights.map {$0.height + 20}.reduce(0, +)
    }
    
    private var targetDataSource: UICollectionViewDiffableDataSource<Section, Target>!
    
    private var genreDataSource: UICollectionViewDiffableDataSource<Section, Genre>!
    
    enum Section {
        case main
    }
    
    public init(postingService: PostingServiceType) {
        self.postingService = postingService
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 어디로 스크롤 해야하지? 눌린 곳의 위치를 어떻게 알아?
        let wholeHeight = tableViewTotalHeight + 100 + 52 + 20 + 16 + 100
        scrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: wholeHeight)
        
        // FIXME: scroll to the bottom if new question has added
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height)
        
        if wholeHeight > UIScreen.screenHeight - 100 {
            scrollView.setContentOffset(bottomOffset, animated: false)
        }
    }
    
    private let customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar(title: "설문 요청")
        return navBar
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "설문 제목을 입력해주세요."
        textField.layer.borderColor = UIColor.strongMainColor.cgColor
        textField.layer.borderWidth = 3
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return textField
    }()
    
    private func setupDelegates() {
        titleTextField.delegate = self
        customNavBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if postingService.numberOfQuestions == 0 {
            postingService.addQuestion()
        }
        registerPostingBlockCollectionView()
        
        setupTopCollectionViews()
        
        configureTopDataSources()
        
        setupDelegates()
        setupLayout()
        setupTargets()
        
        view.backgroundColor = UIColor.postingVCBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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
        
        selectedGenresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectedTargetsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        selectedGenresCollectionView.backgroundColor = .magenta
        selectedTargetsCollectionView.backgroundColor = .cyan
    }
    
    private func configureTopDataSources() {
        configureGenreDataSource()
        configureTargetDataSource()
    }
    
    private func configureTargetDataSource() {
        let targetCellRegistration = UICollectionView.CellRegistration<TargetLabelCollectionViewCell, Target> {
            (cell, indexPath, target) in
            cell.text = target.name
        }

        targetDataSource = UICollectionViewDiffableDataSource<Section, Target>(collectionView: selectedTargetsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Target) -> UICollectionViewCell? in
             return collectionView.dequeueConfiguredReusableCell(using: targetCellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureGenreDataSource() {
        let genreCellRegistration = UICollectionView.CellRegistration<GenreLabelCollectionViewCell, Genre> {
            (cell, indexPath, genre) in
            cell.text = genre.name
        }

        genreDataSource = UICollectionViewDiffableDataSource<Section, Genre>(collectionView: selectedGenresCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Genre) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: genreCellRegistration, for: indexPath, item: identifier)
        }
    }
    
    /// Update genre, target UIs
    override func updateMyUI() {
        if postingService.selectedGenres != currentGenres {
            currentGenres = postingService.selectedGenres
            var genreSnapshot = NSDiffableDataSourceSnapshot<Section, Genre>()
            genreSnapshot.appendSections([.main])
            genreSnapshot.appendItems(currentGenres)
            genreDataSource.apply(genreSnapshot)
        }
        
        if postingService.selectedTargets != currentTargets {
            currentTargets = postingService.selectedTargets
            var targetSnapshot = NSDiffableDataSourceSnapshot<Section, Target>()
            targetSnapshot.appendSections([.main])
            targetSnapshot.appendItems(currentTargets)
            self.targetDataSource.apply(targetSnapshot, animatingDifferences: true)
        }
        
        checkIfConditionSatisfied()
    }
    
    private func checkIfConditionSatisfied() {
        // Category 선택되어야함, 완료된 질문 있어야함, title 뭔가 입력되어있어야함.
        let isSatisfied = postingService.selectedGenres.isEmpty == false
        && postingService.hasCompletedQuestion
        && postingService.surveyTitle != nil

        requestingButton.isUserInteractionEnabled = isSatisfied
        requestingButton.backgroundColor = isSatisfied ? .deeperMainColor : .grayProgress
    }
    
    private func setupInitialSnapshot() {
        var genreSnapshot = NSDiffableDataSourceSnapshot<Section, Genre>()
        genreSnapshot.appendSections([.main])
        genreSnapshot.appendItems(currentGenres, toSection: .main)
        genreDataSource.apply(genreSnapshot)
        
        var targetSnapshot = NSDiffableDataSourceSnapshot<Section, Target>()
        targetSnapshot.appendSections([.main])
        targetSnapshot.appendItems(currentTargets)
        targetDataSource.apply(targetSnapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            // 이게 꼭 Diffable 이어야해? Nope. 이걸 왜 지금하고있어?
            let columns = 5
            let spacing = CGFloat(10)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
            
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
        genreButton.addTarget(self, action: #selector(genreTapped), for: .touchUpInside)
//        titleTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneTapped(_:)))
        titleTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneTapped(_:)))
    }
    
    @objc func doneTapped(_ sender: UITextField) {
        guard let title = sender.text else { return }
        postingService.setSurveyTitle(title)
        self.view.dismissKeyboard()
        checkIfConditionSatisfied()
    }
    // MARK: - Button Actions
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc private func dismissKeyboard() {
        
        // 음.. 왜그럴까 ??
        // 인식을 마쳐야하는데..
        
        print("dismisskeyboardCalled")
        
        UserDefaults.standard.isAddingSelectableOption = false

        view.dismissKeyboard()
        
        postingService.refineSelectableOptionsOfPostingQuestions()
        
        DispatchQueue.main.async {
            self.postingBlockCollectionView.reloadData()
        }
        checkIfConditionSatisfied()
    }
    
    @objc func targetTapped(_ sender: UIButton) {
        dismissKeyboard()
        coordinator?.manipulate(.targetSelection, command: .present)
    }
    
    @objc func genreTapped(_ sender: UIButton) {
        dismissKeyboard()
        coordinator?.manipulate(.genreSelection(.posting), command: .present)
    }
    
    @objc func requestSurveyTapped(_ sender: UIButton) {
        let postingQuestions = postingService.postingQuestions
        print("0623 flag 1")
        for eachQuestion in postingQuestions {
            print("title: \(eachQuestion.questionText)")
            print("selectableOptions:")
            for eachSelectableOption in eachQuestion.selectableOptions {
                print("value: \(eachSelectableOption.value)")
                print("some: \(eachSelectableOption.position)")
            }
        }
        print("current postingQuestions: \(postingService.postingQuestions)")
        coordinator?.manipulate(.confirmation, command: .present)
    }
    
    @objc func dismissTapped() {
        postingService.reset()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        [
            customNavBar,
            scrollView,
            expectedTimeGuideLabel, expectedTimeResultLabel,
            requestingButton
         ].forEach {
            self.view.addSubview($0)
        }
        
        [
            titleTextField,
            targetButton, genreButton,
            selectedTargetsCollectionView,
            selectedGenresCollectionView,
            postingBlockCollectionView
        ].forEach {
            self.scrollView.addSubview($0)
        }
        
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        requestingButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        expectedTimeResultLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(requestingButton.snp.top).offset(-5)
            make.width.equalTo(50)
        }
        
        expectedTimeGuideLabel.snp.makeConstraints { make in
            make.trailing.equalTo(expectedTimeResultLabel.snp.leading).offset(-10)
            make.bottom.equalTo(expectedTimeResultLabel.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
            make.bottom.equalTo(expectedTimeGuideLabel.snp.top).offset(-10)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.screenWidth - 40)
            make.height.equalTo(40)
        }
        
        targetButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(26)
        }

        targetButton.addSmallerInsets()
        
        selectedTargetsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(targetButton.snp.top)
            make.bottom.equalTo(targetButton.snp.bottom)
            make.leading.equalTo(targetButton.snp.trailing).offset(10)
            make.width.equalTo(300)
        }
        selectedTargetsCollectionView.backgroundColor = .clear
        
        genreButton.snp.makeConstraints { make in
            make.top.equalTo(targetButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(26)
        }
        
        genreButton.addSmallerInsets()
        
        selectedGenresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genreButton.snp.top)
            make.bottom.equalTo(genreButton.snp.bottom)
            make.leading.equalTo(genreButton.snp.trailing).offset(10)
            make.width.equalTo(300)
        }
        selectedGenresCollectionView.backgroundColor = .clear
        
        postingBlockCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
            make.top.equalTo(genreButton.snp.bottom).offset(16)
            make.bottom.equalTo(expectedTimeGuideLabel.snp.top).offset(-10)
        }
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
    private var selectedGenresCollectionView: UICollectionView!
    
    private lazy var postingBlockCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        
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
    
    private let genreButton: UIButton = {
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
        return postingService.numberOfQuestions
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingBlockCollectionViewCell.reuseIdentifier, for: indexPath) as! PostingBlockCollectionViewCell
        
        cell.postingBlockCollectionViewCellDelegate = self
        cell.cellIndex = indexPath.row
        
        let cellHeight = CellHeight(index: indexPath.row, height: defaultCellHeight + 20)
        if self.questionCellHeights.filter ({ $0.index == indexPath.row }).isEmpty {
            self.questionCellHeights.insert(cellHeight)
        }
        
        if postingService.postingQuestions.count > indexPath.row {
            let postingQuestion = postingService.postingQuestions[indexPath.row]
            cell.postingQuestion = postingQuestion
            checkIfConditionSatisfied()
        }
        
        if indexPath.row == postingService.postingQuestions.count - 1 {
            viewDidAppear(false)
        }
        
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
        
        var height: CGFloat = defaultCellHeight
        
        if let first = questionCellHeights.first(where: { cellHeight in
            cellHeight.index == indexPath.row })
        {
            height = first.height
        }
        print("sizeForItem: \(height), index: \(indexPath.row)")
        print("dequeueing height: \(height)")
        
        return CGSize(width: UIScreen.screenWidth - 40, height: height)
    }
}

extension PostingViewController: PostingBlockCollectionViewCellDelegate {
    
    func returnTapped(from cell: PostingBlockCollectionViewCell) {
        print("count: \(cell.postingQuestion?.selectableOptions.count)")
        if cell.postingQuestion?.selectableOptions.count != 1 {
            postingService.refineSelectableOptionsOfPostingQuestions()
            DispatchQueue.main.async {
                self.postingBlockCollectionView.reloadData()
            }
        }
    }
    
    func updateQuestionText(cellIndex: Int, questionText: String, postingQuestion: PostingQuestion) {
        postingQuestion.updateQuestionText(questionText: questionText)
        // TODO: Update PostingQuestion
    }
    
    func updateUI(cellIndex: Int, postingQuestion: PostingQuestion) {
        
        // cell 필요 없는거 아니야 ? 맞아.
        guard let correspondingCellHeight = questionCellHeights.first(where: { $0.index == cellIndex }) else { fatalError() }
        
        questionCellHeights.remove(correspondingCellHeight) // 뭐지? 지우는게 뭔가 있네?

        let numberOfSelectableOptions = postingQuestion.numberOfOptions
        
        let newCellHeight = CellHeight(
            index: cellIndex,
            height: defaultCellHeight + CGFloat(numberOfSelectableOptions) * self.selectableOptionHeight)
        
        questionCellHeights.insert(newCellHeight)
        
        postingBlockCollectionView.reloadItems(at: [IndexPath(row: cellIndex, section: 0)])
    }
    
    /// append 기능도 수행
    func setPostingQuestionToIndex(postingQuestion: PostingQuestion, index: Int) {
        print("setPostingQuestionToIndex called, index: \(index)")
        postingService.setPostingQuestion(postingQuestion: postingQuestion, index: index)
    }
}

extension PostingViewController: PostingBlockCollectionFooterDelegate {
    func addQuestionButtonTapped() {
        
        postingService.addQuestion()
        
        print("postingService's numberOfQuestion: \(postingService.postingQuestions.count)")
        
        // TODO: Need to update Cell Height
        DispatchQueue.main.async {
            self.postingBlockCollectionView.reloadData()
        }
    }
}

extension PostingViewController: CustomNavigationBarDelegate {
    func dismiss() {
        postingService.reset()
        self.navigationController?.popViewController(animated: true)
    }
}


extension PostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let title = textField.text else { return true }
        postingService.setSurveyTitle(title)
        self.view.dismissKeyboard()
        checkIfConditionSatisfied()
        return true
    }
}
