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

    var surveyDataSource: UITableViewDiffableDataSource<Section, Survey>! = nil
    var currentSurveySnapshot: NSDiffableDataSourceSnapshot<Section, Survey>! = nil
    
    enum Section {
        case main
    }
    
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
        
        setupTargets()
        setupCollectionView()
        setupLayout()
        
        view.backgroundColor = UIColor.mainBackgroundColor
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
        currentSurveySnapshot = NSDiffableDataSourceSnapshot<Section, Survey>()
        currentSurveySnapshot.appendSections([.main])
        
        currentSurveySnapshot.appendItems(participationService.surveysToShow)
        
        self.surveyDataSource.apply(currentSurveySnapshot)
    }
    
    private func setupTargets() {
        requestingButton.addTarget(self, action: #selector(moveToPostSurvey), for: .touchUpInside)
    }
    
    @objc func moveToPostSurvey() {
        coordinator?.move(to: .postingController)
    }
    
    private func setupLayout() {
        navigationItem.titleView = UIView()
//        navigationController?.hidesBarsOnTap = true
        
        [
         collectedRewardLabel, surveyTableView, categorySelectionButton, categoryCollectionView, requestingButton].forEach { self.view.addSubview($0) }
        
        collectedRewardLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(28)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        categorySelectionButton.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth / 6)
            make.height.equalTo(categoryHeight)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(categorySelectionButton.snp.centerY)
            make.leading.equalTo(categorySelectionButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(categorySelectionButton.snp.height)
        }
        
        requestingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-tabbarHeight)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
        }
        
        surveyTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
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
        return button
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: UIScreen.screenWidth / 6, height: categoryHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBackgroundColor
        return collectionView
    }()
    
    private let surveyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
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

        let estimatedFrame3 = NSString(string: surveys[indexPath.row].title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        // 12 + 10 + 12 + 20 + 12
        let spacings: CGFloat = 66
        let sizes: CGFloat = 30
        let frameHeight = [estimatedFrame1, estimatedFrame2, estimatedFrame3].map { $0.height }.reduce(0, +)
        let heightSum = frameHeight + spacings + sizes
        return heightSum
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let result = userService.interestedCategories.count
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell

        // TODO: 이미 선택된 것들 고려하기.
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
