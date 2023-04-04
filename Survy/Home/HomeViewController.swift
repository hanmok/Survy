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
        Survey(dateLeft: 11, categories: ["운동", "다이어트"], question: "다이어트 운동, 약물에 대한 간단한 통계 조사입니다.", participants: [132, 1000], reward: 100),
        Survey(dateLeft: 13, categories: ["애견", "음식"],question: "애견인과 비애견인의 동물 관련 음식 소비패턴에 대한 조사입니다. 참여 부탁드려요!", participants: [273, 385],reward: 500),
        Survey(dateLeft: 15, categories: ["운동"], question: "근육이 약한데 어떻게 하면 좋아질 수 있을까요?", availableOptions: ["필라테스", "헬스", "걷기", "수영", "도수치료"], textFieldPlaceHolder: "선택하신 운동을 추천하시는 이유도 알려주세요~", participants: [98, 100], reward: 100)
    ]
    
    let collectedMoney = 56000
    let interestedCategories = ["애견", "운동", "음식", "피부"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setupLayout()
        setupTargets()
        view.backgroundColor = UIColor.mainBackgroundColor
        
    }
    
    private func registerTableView() {
        surveyTableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
    }
    
    
    
    private func setupLayout() {
        

        navigationController?.title = "홈"
        
        [upperContainer, surveyTableView, categoriesLabel, requestingButton].forEach { self.view.addSubview($0) }
        
        [collectedRewardLabel, leftUnderlineView, rightUnderlineView, indivisualTabButton, companyTabButton].forEach {
            self.upperContainer.addSubview($0)
        }
        
        upperContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
            make.height.equalTo(160)
        }
        
        indivisualTabButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(30)
        }
        
        companyTabButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(30)
        }
        
        collectedRewardLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(28)
            make.bottom.equalTo(indivisualTabButton.snp.top).offset(-12)
        }
        
        leftUnderlineView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        rightUnderlineView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        categoriesLabel.snp.makeConstraints { make in
//            make.top.equalTo(upperContainer.snp.bottom).offset(15)
            make.top.equalTo(upperContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        surveyTableView.snp.makeConstraints { make in
//            make.top.equalTo(categoriesLabel.snp.bottom).offset(15)
            make.top.equalTo(categoriesLabel.snp.bottom)
//            make.leading.trailing.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(surveys.count * 200)
        }
        
        if UserDefaults.standard.isIndivisualSelected {
            leftButtonAction()
        } else {
            rightButtonAction()
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
            make.bottom.equalToSuperview().inset(tabbarHeight + 30)
            make.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(70)
        }
        
        requestingButton.addShadow(offset: CGSize(width: 5.0, height: 5.0), color: .gray, opacity: 0.8, radius: 5.0)
        // MARK: - Initial Setup for selected Upper Bar
    }
    
    private func setupTargets() {
        indivisualTabButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        companyTabButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    private func leftButtonAction() {
        indivisualTabButton.setTitleColor(UIColor.selectedUpperTabColor, for: .normal)
        companyTabButton.setTitleColor(UIColor.unselectedUpperTabColor, for: .normal)
        leftUnderlineView.backgroundColor = .black
        rightUnderlineView.backgroundColor = .clear
        
        let indiAttr = NSAttributedString(string: "개인", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.selectedUpperTabColor])
        indivisualTabButton.setAttributedTitle(indiAttr, for: .normal)
        
        let comAttr = NSAttributedString(string: "기업", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.unselectedUpperTabColor])
        companyTabButton.setAttributedTitle(comAttr, for: .normal)
    }
    
    private func rightButtonAction() {
        indivisualTabButton.setTitleColor(UIColor.unselectedUpperTabColor, for: .normal)
        companyTabButton.setTitleColor(UIColor.selectedUpperTabColor, for: .normal)
        leftUnderlineView.backgroundColor = .clear
        rightUnderlineView.backgroundColor = .black
        
        let indiAttr = NSAttributedString(string: "개인", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.unselectedUpperTabColor])
        indivisualTabButton.setAttributedTitle(indiAttr, for: .normal)
        
        let comAttr = NSAttributedString(string: "기업", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.selectedUpperTabColor])
        companyTabButton.setAttributedTitle(comAttr, for: .normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if sender.tag == 1 {
           leftButtonAction()
            UserDefaults.standard.isIndivisualSelected = true
        } else if sender.tag == 2 {
            rightButtonAction()
            UserDefaults.standard.isIndivisualSelected = false
        }
        
    }
    
    private let requestingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.filledGageColor
        button.setImage(UIImage.requesting_image, for: .normal)
        button.layer.cornerRadius = 35
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
    
    private let leftUnderlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let rightUnderlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let indivisualTabButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        let attr = NSAttributedString(string: "개인", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.unselectedUpperTabColor])
        button.setAttributedTitle(attr, for: .normal)
        return button
    }()
    
    private let companyTabButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        let attr = NSAttributedString(string: "기업", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.unselectedUpperTabColor])
        button.setAttributedTitle(attr, for: .normal)
        return button
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
        
//        let selectedView = UIView()
//        selectedView.backgroundColor = UIColor.mainBackgroundColor
//        cell.backgroundView = selectedView
        
//        cell.selectionStyle = UITableViewCell.SelectionStyle.gray
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
