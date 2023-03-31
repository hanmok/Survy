//
//  SurveyTableViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit
import SnapKit

class SurveyTableViewCell: UITableViewCell {

    public var survey: Survey? {
        didSet {
            setupLayout()
            configureLayout()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func configureLayout() {
        guard let survey = survey else { return }
        
        dateLeftLabel.text = "\(survey.dateLeft)일 남음"
        
        let categoriesText = survey.categories.joined(separator: "•")
        categoryLabel.text = categoriesText
        
        let participants = survey.participants.map { String($0)}.joined(separator: " / ") + " 참여"
        participantsLabel.text = participants
        
        rewardLabel.text = "\(survey.reward)P"
        
        questionLabel.text = survey.question
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset2 = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        backgroundColor = UIColor(hex6: 0xECEDF3)
        contentView.frame = contentView.frame.inset(by: inset2)
        print("contentView height: \(contentView.frame.height)")
        contentView.backgroundColor = .white
    }
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 16
        
        [dateLeftLabel, categoryLabel, questionLabel, participantsLabel, rewardLabel, answerTextField, dividerView, coinImageView, testView, participateButton].forEach {
            self.contentView.addSubview($0)
        }
        
        dateLeftLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLeftLabel.snp.trailing).offset(10)
            make.centerY.equalTo(dateLeftLabel.snp.centerY)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(dateLeftLabel.snp.bottom).offset(10)
        }
        
        participantsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.equalTo(participantsLabel.snp.trailing).offset(10)
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(participantsLabel.snp.centerY)
        }
        
        coinImageView.snp.makeConstraints { make in
            make.leading.equalTo(dividerView.snp.trailing).offset(8)
            make.width.height.equalTo(14)
            make.centerY.equalTo(participantsLabel.snp.centerY)
        }
        
        rewardLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(7)
            make.centerY.equalTo(participantsLabel.snp.centerY)
        }
        
        participateButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
//        testView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(30)
//        }
    }
    
    private let participateButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.backgroundColor = .white
        return button
    }()
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.coin
        return imageView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dividerColor
        return view
    }()
    
    private let dateLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.participantsColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private let answerTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private let participantsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.participantsColor
        return label
    }()
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rewardColor
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}