//
//  MyPageViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import SnapKit
import UIKit

class MyPageViewController: TabController, Coordinating {
    var coordinator: Coordinator?
    
    let collectedMoney = 56000
    
    var moreInfos: [Info] = [
        Info(text: "친구초대", nextViewController: UIViewController()),
        Info(text: "이용안내", nextViewController: UIViewController()),
        Info(text: "고객센터", nextViewController: UIViewController()),
        Info(text: "회원탈퇴", nextViewController: UIViewController())
    ]
    
    var userService: UserServiceType
    
    init(index: Int, userService: UserServiceType) {
        self.userService = userService
        super.init(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIView()

        view.backgroundColor = .white
        configureTableView()
        setupLayout()
        configureLayout()
        setupTargets() 
    }
    
    private func setupTargets() {
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }
    
    @objc func logoutAction() {
        UserDefaults.standard.autoLoginEnabled = false
        // TODO: Logout
//        coordinator?.move(to: .log)
        coordinator?.move(to: .root)
        
        
    }
    
    private func configureTableView() {
        moreInfosTableView.register(MoreInfoTableViewCell.self, forCellReuseIdentifier: MoreInfoTableViewCell.reuseIdentifier)
        moreInfosTableView.delegate = self
        moreInfosTableView.dataSource = self
    }
    
    private func setupLayout() {
        [profileButton, nicknameLabel, detailInfoLabel,
         modifyingProfileButton,
         pointLabel, pointButton,
         creditInfoBoxView,
         horizontalSeparatorView1, horizontalSeparatorLabel,
         moreInfosTableView,
         logoutButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        profileButton.snp.makeConstraints { make in
            make.leading.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.width.height.equalTo(66)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(17)
            make.top.equalTo(profileButton.snp.top).offset(15)
        }
        
        detailInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
        }
        
        modifyingProfileButton.snp.makeConstraints { make in
            make.leading.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(detailInfoLabel.snp.bottom).offset(30)
            make.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(36)
        }
        
        pointLabel.snp.makeConstraints { make in
            make.leading.equalTo(modifyingProfileButton.snp.leading).offset(20)
            make.top.equalTo(modifyingProfileButton.snp.bottom).offset(18)
        }
        
        pointButton.snp.makeConstraints { make in
            make.trailing.equalTo(modifyingProfileButton.snp.trailing).offset(-20)
            make.top.equalTo(modifyingProfileButton.snp.bottom).offset(18)
        }
        
        creditInfoBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(140)
            make.top.equalTo(pointLabel.snp.bottom).offset(18)
        }
        
        creditInfoBoxView.addShadowToAll(color: .gray, opacity: 0.5, radius: 5.0)
        
        [creditLabel, wholeGageView, partialGageView, postedSurveyNumberLabel, postedSurveyGuideLabel, respondedSurveyNumberLabel, respondedSurveyGuideLabel, verticalSeparatorView].forEach { creditInfoBoxView.addSubview($0)}
        
        creditLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }
        
        wholeGageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(creditLabel.snp.bottom).offset(12)
            make.height.equalTo(6)
        }
        
        partialGageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(creditLabel.snp.bottom).offset(12)
            make.height.equalTo(6)
            make.width.equalTo(wholeGageView.snp.width).dividedBy(2)
        }
        
        verticalSeparatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(30)
            make.top.equalTo(wholeGageView.snp.bottom).offset(30)
        }
        
        postedSurveyNumberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(verticalSeparatorView.snp.leading).offset(-80)
            make.top.equalTo(verticalSeparatorView.snp.top).offset(-10)
        }
        postedSurveyGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(postedSurveyNumberLabel.snp.bottom).offset(8)
            make.centerX.equalTo(postedSurveyNumberLabel)
        }
        
        respondedSurveyNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(verticalSeparatorView.snp.trailing).offset(80)
            make.top.equalTo(verticalSeparatorView.snp.top).offset(-10)
        }
        
        respondedSurveyGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(respondedSurveyNumberLabel.snp.bottom).offset(8)
            make.centerX.equalTo(respondedSurveyNumberLabel)
        }
        
        horizontalSeparatorView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(creditInfoBoxView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }
        
        moreInfosTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(horizontalSeparatorView1.snp.bottom)
            make.height.equalTo(moreInfos.count * 50)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(36)
            make.top.equalTo(moreInfosTableView.snp.bottom).offset(12)
        }
        
        horizontalSeparatorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
    
    private func configureLayout(){
        // profile image
        profileButton.setImage(UIImage.profile, for: .normal)
        
        // nickname
        nicknameLabel.text = "오늘도 꾸준히 재테크"
        detailInfoLabel.text = ["서울특별시", "사무", "기술직", "남성", "만 30세"].joined(separator: " • ")
        
        // 포인트
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let text = numberFormatter.string(from: collectedMoney as NSNumber) else { return }
        
        pointLabel.addFrontImage(
            image: UIImage.coin, string: " \(text)P",
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            color: UIColor.black)
        
        let attributedCreditText = NSMutableAttributedString(string: "  Credit Level", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        
        attributedCreditText.append(NSAttributedString(string: " 5", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold), .foregroundColor: UIColor.blueTextColor]))
        
        creditLabel.addFrontImage(image: UIImage.medal, attrString: attributedCreditText)
        
        postedSurveyNumberLabel.attributedText = NSAttributedString(string: "2", attributes: [.font: UIFont.systemFont(ofSize: 20)])
        
        respondedSurveyNumberLabel.attributedText = NSAttributedString(string: "101", attributes: [.font: UIFont.systemFont(ofSize: 20)])
        
        
        
    }
    
    
    private let profileButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let detailInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blurredTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let modifyingProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.blurredMainColor
//        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
//        button.layer.borderColor = UIColor.clear.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let pointButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.rightChevron, for: .normal)
        return button
    }()
    
    private let creditInfoBoxView: UIView = {
        let view = UIView()
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.clear.cgColor
////        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
//        view.backgroundColor = .magenta
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
//        view.clipsToBounds = true
        return view
    }()

    private let creditLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let partialGageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.filledGageColor
//        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 3
//        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    private let wholeGageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.unfilledGageColor
//        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 3
//        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    private let postedSurveyNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let postedSurveyGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "요청한 설문"
        label.textColor = UIColor.blurredTextColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let respondedSurveyNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let moreInfosTableView: UITableView = {
        let tableView = UITableView()
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let respondedSurveyGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "참여한 설문"
        label.textColor = UIColor.blurredTextColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separatorViewColor
        return view
    }()
    
    private let horizontalSeparatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.bigSeparatorViewColor
        return view
    }()
    
    private let horizontalSeparatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.bigSeparatorViewColor
        label.text = "개인정보 처리방침 • 서비스 약관"
        label.textAlignment = .center
        label.textColor = UIColor.blurredTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor.logoutButtonText, for: .normal)
        button.backgroundColor = UIColor.logoutButtonBackground
//        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
//        button.layer.borderColor = UIColor.clear.cgColor
        button.clipsToBounds = true
        return button
    }()
}




extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreInfoTableViewCell.reuseIdentifier) as! MoreInfoTableViewCell
        cell.moreInfo = moreInfos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
