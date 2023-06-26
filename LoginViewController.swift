//
//  LoginViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/06/26.
//

import UIKit
import SnapKit


class LoginViewController: UIViewController {

    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: UIColor(white: 0.3, alpha: 1)])
        tf.layer.borderColor = UIColor.deeperMainColor.cgColor
        tf.layer.borderWidth = 2
        tf.backgroundColor = UIColor.mainColor
        tf.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.setLeftPaddingPoints(10)
        return tf
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: UIColor(white: 0.3, alpha: 1)])
        tf.textColor = .black
        tf.layer.borderColor = UIColor.deeperMainColor.cgColor
        tf.layer.borderWidth = 2
//        tf.backgroundColor = UIColor.mainColor
        tf.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.setLeftPaddingPoints(10)
        return tf
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "sampleIcon")
        return imageView
    }()
    
    private let thirdPartyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let kakaoLogin = UIButton()
    private let googleLogin = UIButton()
    private let appleLogin = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        setupLayout()
        
        // Do any additional setup after loading the view.
    }
    
    private func configureLayout() {
        
    }
    
    private func setupLayout() {
        [
            logoImageView,
            usernameTextField, passwordTextField,
            separatorView,
            thirdPartyStackView
        ].forEach { self.view.addSubview($0)}
        
        
        logoImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(300)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.height.equalTo(2)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.top.equalTo(logoImageView.snp.bottom).offset(80)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.top.equalTo(usernameTextField.snp.bottom).offset(12)
        }
        
        thirdPartyStackView.addArrangedSubviews([kakaoLogin, googleLogin, appleLogin])
        thirdPartyStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(120)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        
        
    }
}
