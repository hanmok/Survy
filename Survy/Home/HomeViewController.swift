//
//  HomeViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    let surveys: [Survey] = [
        Survey(id: 1, numOfParticipation: 153, participationGoal: 200, title: "체형 교정 운동을 추천해주세요", rewardRange: [100], categories: ["운동"]),
        
        Survey(id: 2, numOfParticipation: 273, participationGoal: 385, title: "애견인과 비애견인의 동물 관련 음식 소비패턴에 대한 조사입니다. 참여 부탁드려요!", rewardRange: [500], categories: ["애견", "음식"]),
        
        Survey(id: 3, numOfParticipation: 132, participationGoal: 1000, title: "다이어트 운동, 약물에 대한 간단한 통계 조사입니다.", rewardRange: [100], categories: ["운동", "다이어트"])
    ]
    
    let collectedMoney = 56000
    let interestedCategories = ["애견", "운동", "음식", "피부"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setupLayout()
        view.backgroundColor = UIColor.mainBackgroundColor
    }
    
    private func registerTableView() {
        surveyTableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
    }
    
    private func setupLayout() {
        
        navigationController?.title = "홈"
        
        [
//            upperContainer,
         collectedRewardLabel, surveyTableView, categoriesLabel, requestingButton].forEach { self.view.addSubview($0) }
        
//        [collectedRewardLabel].forEach {
//            self.upperContainer.addSubview($0)
//        }
        
//        upperContainer.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalToSuperview()
//            make.height.equalTo(100)
//        }
        
        collectedRewardLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(28)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        categoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        surveyTableView.snp.makeConstraints { make in
            make.top.equalTo(categoriesLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(surveys.count * 200)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let text = numberFormatter.string(from: collectedMoney as NSNumber) else { return }

        collectedRewardLabel.addFrontImage(
            image: UIImage.coin, string: text + "P",
            font: UIFont.systemFont(ofSize: collectedRewardLabel.font.pointSize, weight: .bold),
            color: UIColor.blueTextColor)
        
        categoriesLabel.text = "Categories"
        
        requestingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-tabbarHeight)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
        }
        
//        requestingButton.addShadow(offset: CGSize(width: 5.0, height: 5.0), color: .gray, opacity: 0.8, radius: 5.0)
        
        // MARK: - Initial Setup for selected Upper Bar
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
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.clear.cgColor
        label.clipsToBounds = true
        label.backgroundColor = UIColor.mainColor
        return label
    }()
    
    // TODO: Make it CollectionView

    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .magenta
        return label
    }()
    
    private let surveyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.reuseIdentifier, for: indexPath) as! SurveyTableViewCell
        cell.survey = surveys[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let estimatedTitle =
        let approximatedWidthOfBioTextView = UIScreen.screenWidth - 16 * 2 - 12 * 2
        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)
        let estimatedFrame1 = NSString(string: " ").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil)
        
        let estimatedFrame2 = NSString(string: " ").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 13)], context: nil)
        
        let estimatedFrame3 = NSString(string: surveys[indexPath.row].title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
        // 12 + 10 + 12 + 20 + 12
        let spacings: CGFloat = 66
        let sizes: CGFloat = 30 + 30 //
        let frameHeight = [estimatedFrame1, estimatedFrame2, estimatedFrame3].map { $0.height }.reduce(0, +)
        let heightSum = frameHeight + spacings + sizes
        return heightSum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
