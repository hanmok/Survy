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
        
        let categoriesText = survey.categories.joined(separator: " • ")
        categoryLabel.text = categoriesText
        
        let participants = survey.participants.map { String($0)}.joined(separator: " / ")
        participantsLabel.text = participants
        
        if let rewardText = survey.rewardString {
            rewardLabel.addFrontImage(image: UIImage.coin, string: rewardText, font: UIFont.systemFont(ofSize: rewardLabel.font.pointSize))
        }
        
        questionLabel.text = survey.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let selectedView = UIView()
//        selectedView.backgroundColor = UIColor.clear
//        backgroundView = selectedView
        
//        selectedBackgroundView
//        let inset2 = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
//        let inset2 = UIEdgeInsets(top: 12, left: 30, bottom: 12, right: 30)
        let inset2 = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        backgroundColor = UIColor(hex6: 0xECEDF3)
        contentView.frame = contentView.frame.inset(by: inset2)
        print("contentView height: \(contentView.frame.height)")
        contentView.backgroundColor = .white
    }
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 16
        contentView.addShadow(offset: CGSize(width: 5.0, height: 5.0))
        [dateLeftLabel, categoryLabel, questionLabel, participantsLabel, rewardLabel, answerTextField, dividerView, testView, participateButton].forEach {
            self.contentView.addSubview($0)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
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
        
        rewardLabel.snp.makeConstraints { make in
            make.leading.equalTo(dividerView.snp.trailing).offset(8)
            make.centerY.equalTo(participantsLabel.snp.centerY)
        }
        
        participateButton.snp.makeConstraints { make in
//            make.trailing.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
//            make.top.equalTo(participantsLabel.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        participateButton.setTitleWithImage(image: UIImage.rightChevron, title: "참여하기")
        participateButton.addInsets(top: 10.0, bottom: 10.0, left: 8.0, right: 8.0)
    }
    
    private let participateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.backgroundColor = .white
        return button
    }()
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
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
        label.font = UIFont.systemFont(ofSize: 13)
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
