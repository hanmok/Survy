//
//  MoreInfoTableViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/04/04.
//

import UIKit

class MoreInfoTableViewCell: UITableViewCell {

    var moreInfo: Info? {
        didSet {
            setupLayout()
            configureLayout()
        }
    }
    
    private func configureLayout() {
        guard let moreInfo = moreInfo else { return }
        titleLabel.text = moreInfo.text

    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.rightChevron
        return imageView
    }()
    
    private func setupLayout() {
        
        [titleLabel, chevronImageView].forEach {
            self.contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    // 다음 화면에 대한 것 정보,
    // 텍스트 정보 필요.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

struct Info {
    var text: String
    var nextViewController: UIViewController
}

