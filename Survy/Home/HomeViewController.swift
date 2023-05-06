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
    
    var surveyService: SurveyServiceType
    var coordinator: Coordinator?
    
    init(surveyService: SurveyServiceType) {
        self.surveyService = surveyService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let surveys: [Survey] = [
        Survey(id: 1, numOfParticipation: 153, participationGoal: 200, title: "체형 교정 운동을 추천해주세요", rewardRange: [100], categories: ["운동"]),
        
        Survey(id: 2, numOfParticipation: 273, participationGoal: 385, title: "애견인과 비애견인의 동물 관련 음식 소비패턴에 대한 조사입니다. 참여 부탁드려요!", rewardRange: [500], categories: ["애견", "음식"]),
        
        Survey(id: 3, numOfParticipation: 132, participationGoal: 1000, title: "다이어트 운동, 약물에 대한 간단한 통계 조사입니다.", rewardRange: [100], categories: ["운동", "다이어트"])
    ]
    
    var surveysToShow = [Survey]()
    
    let collectedMoney = 56000
    
    let categories = ["애견", "운동", "음식", "피부"]
    
    var selectedCategories = Set(["애견", "운동", "음식", "피부"])
    
    private func setupTargets() {
        requestingButton.addTarget(self, action: #selector(moveToPostSurvey), for: .touchUpInside)
    }
    
    @objc func moveToPostSurvey() {
        coordinator?.move(to: .postingController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setupTargets()
        setupCollectionView()
        setupLayout()
        
        view.backgroundColor = UIColor.mainBackgroundColor
    }
    
    private func registerTableView() {
        surveyTableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: 50))
        surveyTableView.tableFooterView = footerView
    }
    
    private func setupLayout() {
        navigationController?.title = "홈"
        
        [
         collectedRewardLabel, surveyTableView, categorySelectionButton, categoryCollectionView, requestingButton].forEach { self.view.addSubview($0) }
        
        collectedRewardLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(28)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-35)
        }
        
        categorySelectionButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth / 6)
            make.height.equalTo(categoryHeight)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(categorySelectionButton.snp.centerY)
            make.leading.equalTo(categorySelectionButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
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
        guard let text = numberFormatter.string(from: collectedMoney as NSNumber) else { return }

        collectedRewardLabel.addFrontImage(
            image: UIImage.coin, string: text + "P",
            font: UIFont.systemFont(ofSize: collectedRewardLabel.font.pointSize, weight: .bold),
            color: UIColor.blueTextColor)
    }
    
    private let requestingButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: "설문 요청", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.white, .paragraphStyle: NSMutableParagraphStyle.centerAlignmentStyle])
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
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.clear.cgColor
        label.clipsToBounds = true
        label.backgroundColor = UIColor.mainColor
        return label
    }()
    
    // TODO: Make it CollectionView
    
    private func setupCollectionView(){
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    private let categorySelectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let categoryHeight: CGFloat = 50
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: UIScreen.screenWidth / 6, height: categoryHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let surveyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.reuseIdentifier, for: indexPath) as! SurveyTableViewCell
        cell.survey = surveysToShow[indexPath.row]
        cell.surveyDelegate = self
        return cell
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        surveysToShow = surveys.filter {
            let categories = Set($0.categories)
            return categories.intersection(selectedCategories).isEmpty == false
        }
        return surveysToShow.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let result = categories.count
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        // TODO: 이미 선택된 것들 고려하기.
        collectionViewCell.category = categories[indexPath.row]
        collectionViewCell.categoryCellDelegate = self
        return collectionViewCell
    }
}

extension HomeViewController: CategoryCellDelegate {
    func categoryTapped(category: String, selected: Bool) {
        selectedCategories.toggle(category)
        DispatchQueue.main.async {
            self.surveyTableView.reloadData()
        }
    }
}

extension HomeViewController: SurveyTableViewDelegate {
    func surveyTapped(_ cell: SurveyTableViewCell) {
        
//        print("umm1")
        guard let selectedSurvey = cell.survey else { fatalError() }
        surveyService.currentSurvey = selectedSurvey
//        let surveyId = selectedSurvey.id
//        let section = Section(surveyId: surveyId, numOfQuestions: 3)
//        let questionViewController = QuestionViewController(question: dietQuestion1, section: section)
        
        coordinator?.move(to: .questionController)
        
//        print(coordinator)
//        self.navigationController?.pushViewController(questionViewController, animated: true)
    }
}
