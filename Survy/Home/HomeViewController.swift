//
//  HomeViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit
import SnapKit
import Model



class HomeViewController: UIViewController, Coordinating {
    
    var participationService: ParticipationServiceType
    var userService: UserServiceType
    var coordinator: Coordinator?
    
    var surveyCellHeights = Set<CellHeight>()
    var tableViewTotalHeight: CGFloat {
        return surveyCellHeights.map { $0.height }.reduce(0, +)
    }
    
    var hasCategoryPinnedToTheTop = false
    
    var surveyDataSource: UITableViewDiffableDataSource<Section, Survey>! = nil
    
    enum Section {
        case main
    }
    
    var topViewHeightConstraint: NSLayoutConstraint?

    
    private var isAnimationInProgress = false
    
    
    private let categoryHeight: CGFloat = 50
    
    init(participationService: ParticipationServiceType,
         userService: UserServiceType) {
        self.participationService = participationService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableView()
        
        configureDataSource()
        updateUI()
        
        setupDelegates()
        setupTargets()
        setupCollectionView()
        setupLayout()
        
        view.backgroundColor = UIColor.mainBackgroundColor
    }
    private func setupDelegates() {
        wholeScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard navigationController != nil else { fatalError() }
        
        coordinator?.testSetup()
        setupLayout()
    }
    
    private func configureDataSource() {
        self.surveyDataSource = UITableViewDiffableDataSource<Section, Survey>(tableView: surveyTableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.reuseIdentifier, for: indexPath) as! SurveyTableViewCell
            cell.survey = participationService.surveysToShow[indexPath.row]
            cell.surveyDelegate = self
            return cell
        })
    }
    
    private func registerTableView() {
        surveyTableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        surveyTableView.delegate = self

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: 50))
        surveyTableView.tableFooterView = footerView
    }
    
    private func setupCollectionView(){
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    private func updateUI() {
        surveyCellHeights.removeAll()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Survey>()
        snapshot.appendSections([.main])
        snapshot.appendItems(participationService.surveysToShow)
        
        self.surveyDataSource.apply(snapshot)
        DispatchQueue.main.async {
            self.surveyTableView.reloadData()
        }
        
        print("updateUI Called")
    }
    
    private func setupTargets() {
        requestingButton.addTarget(self, action: #selector(moveToPostSurvey), for: .touchUpInside)
    }
    
    @objc func moveToPostSurvey() {
        coordinator?.move(to: .postingController)
    }
    
    private func setupLayout() {
//        navigationItem.titleView = UIView()
//        navigationController?.hidesBarsOnTap = true
//        navigationItem.titleView?.isHidden = true
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(wholeScrollView)
        self.view.addSubview(requestingButton)
        self.view.addSubview(topCoverView)
        topCoverView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        [
         collectedRewardLabel, surveyTableView, categorySelectionButton, categoryCollectionView].forEach {
             self.wholeScrollView.addSubview($0)
         }
        
        wholeScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabbarHeight - 50)
        }
        
        collectedRewardLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIScreen.screenWidth - 12 - 100)
            make.height.equalTo(28)
            make.top.equalToSuperview()
        }
        
        categorySelectionButton.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth / 6)
            make.height.equalTo(categoryHeight)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
//            make.leading.equalTo(categorySelectionButton.snp.trailing).offset(12)
//            make.width.equalTo(UIScreen.screenWidth - 24)
            make.leading.equalTo(categorySelectionButton.snp.trailing)
            make.width.equalTo(UIScreen.screenWidth * 5 / 6)
            make.height.equalTo(categorySelectionButton.snp.height)
        }
        
        requestingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-tabbarHeight)
            make.height.equalTo(50)
//            make.leading.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
        }
        
        surveyTableView.snp.makeConstraints { make in
//            make.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(categoryHeight + 20)
//            make.leading.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
            make.bottom.equalTo(requestingButton.snp.top)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let text = numberFormatter.string(from: userService.collectedMoney as NSNumber) else { return }

        collectedRewardLabel.addFrontImage(
            image: UIImage.coin, string: text + "P",
            font: UIFont.systemFont(ofSize: collectedRewardLabel.font.pointSize, weight: .bold),
            color: UIColor.blueTextColor)
    }
    
    // MARK: - Views
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        wholeScrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: tableViewTotalHeight + 150)
        print("tableViewTotalHeight applied: \(tableViewTotalHeight)")
        print("viewDidAppear Called")
    }
    
    private let wholeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let requestingButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: "설문 요청", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.white, .paragraphStyle: NSMutableParagraphStyle.centerAlignment])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = UIColor.deeperMainColor
        return button
    }()
    
    private let upperContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let collectedRewardLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textAlignment = .right
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.backgroundColor = UIColor.mainColor
        return label
    }()
    
    private let categorySelectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .mainBackgroundColor
//        button.inset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
//        button.addInsets(top: 8, bottom: 12, left: 8, right: 12)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return button
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: UIScreen.screenWidth / 6, height: categoryHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBackgroundColor
        collectionView.isScrollEnabled = false
//        collectionView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return collectionView
    }()
    
    private let surveyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let topCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackgroundColor
        view.isHidden = true
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let approximatedWidthOfBioTextView = UIScreen.screenWidth - 16 * 2 - 12 * 2
        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)
        let estimatedFrame1 = NSString(string: " ").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil)

        let estimatedFrame2 = NSString(string: " ").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 13)], context: nil)

        let estimatedFrame3 = NSString(string: participationService.surveysToShow[indexPath.row].title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        // 12 + 10 + 12 + 20 + 12
        let spacings: CGFloat = 66
        let sizes: CGFloat = 30
        let frameHeight = [estimatedFrame1, estimatedFrame2, estimatedFrame3].map { $0.height }.reduce(0, +)
        let heightSum = frameHeight + spacings + sizes

        let cellHeight = CellHeight(index: indexPath.row, height: heightSum)
        surveyCellHeights.insert(cellHeight)
        print("tableViewTotalHeight: \(tableViewTotalHeight), indexPath: \(indexPath.row), addedAmount: \(heightSum)")
        viewDidAppear(false)
        return heightSum
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        surveyCellHeights.removeAll()
        let result = userService.interestedCategories.count
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell

        collectionViewCell.category = userService.interestedCategories[indexPath.row]
        collectionViewCell.categoryCellDelegate = self
        return collectionViewCell
    }
}

extension HomeViewController: CategoryCellDelegate {
    func categoryTapped(category: String, selected: Bool) {
        participationService.toggleCategory(category)
        updateUI()
    }
}

extension HomeViewController: SurveyTableViewDelegate {
    func surveyTapped(_ cell: SurveyTableViewCell) {
        guard let selectedSurvey = cell.survey else { fatalError() }
        participationService.currentSurvey = selectedSurvey
        coordinator?.move(to: .questionController)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let edgeHeight: CGFloat = 24.0
        if scrollView.contentOffset.y > edgeHeight && hasCategoryPinnedToTheTop == false {
            topCoverView.isHidden = false
            hasCategoryPinnedToTheTop = true
            
            // TODO: pin to the top
            [categorySelectionButton, categoryCollectionView].forEach {
                $0.removeFromSuperview()
                self.view.addSubview($0)
            }
            
            self.view.addSubview(topCoverView)
            
            categorySelectionButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.leading.equalToSuperview()
                make.width.equalTo(UIScreen.screenWidth / 6)
                make.height.equalTo(categoryHeight)
            }
            
            categoryCollectionView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.leading.equalTo(categorySelectionButton.snp.trailing)
                make.width.equalTo(UIScreen.screenWidth * 5 / 6)
                make.height.equalTo(categoryHeight)
            }
        } else if scrollView.contentOffset.y <= edgeHeight && hasCategoryPinnedToTheTop == true {
            topCoverView.isHidden = true

            hasCategoryPinnedToTheTop = false
            
            [categorySelectionButton, categoryCollectionView].forEach {
                $0.removeFromSuperview()
                self.wholeScrollView.addSubview($0)
            }
            
            categorySelectionButton.snp.makeConstraints { make in
                make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
                make.leading.equalToSuperview()
                make.width.equalTo(UIScreen.screenWidth / 6)
                make.height.equalTo(categoryHeight)
            }
            
            categoryCollectionView.snp.makeConstraints { make in
                make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
                make.leading.equalTo(categorySelectionButton.snp.trailing)
                make.width.equalTo(UIScreen.screenWidth * 5 / 6)
                make.height.equalTo(categorySelectionButton.snp.height)
            }
        }
    }
}
