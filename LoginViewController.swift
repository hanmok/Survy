//
//  LoginViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/06/26.
//

import UIKit
import SnapKit
import API
import Model

class LoginViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    var userService: UserServiceType
    
    init(userService: UserServiceType, coordinator: Coordinator) {
        self.userService = userService
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var username: String = ""
    private var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupTargets()
        setupDelegates()
        
        autoLogin()
    }
    
    private func autoLogin() {
        usernameTextField.text = UserDefaults.standard.defaultUsername
        username = UserDefaults.standard.defaultUsername
        
        UserDefaults.standard.autoLoginEnabled = true
        
        if UserDefaults.standard.autoLoginEnabled {
            coordinator?.setIndicatorSpinning(true)
            if let refreshToken = KeychainManager2.shared.loadRefreshToken() {
                APIService.shared.autoLogin(username: username, refreshToken: refreshToken) { [weak self] user, message in
                    guard let self = self else { return }
                    guard let user = user else {
                        self.coordinator?.handleAPIFailWithMessage(title: "AutoLogin Failed", message: nil)
                        return
                    }
                    self.enterAction(self.username, user: user)
                    self.userService.setUser(user)
                }
            } else {
                coordinator?.setIndicatorSpinning(false)
            }
        }
    }
    
    private func setupTargets() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        passwordTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(passwordDoneTapped(_:)))
        usernameTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(usernameDoneTapped(_:)))
    }
    
    @objc func usernameDoneTapped(_ sender: UITextField) {
        guard let usernameInput = sender.text else { return }
        username = usernameInput
    }
    
    @objc func passwordDoneTapped(_ sender: UITextField) {
        guard let passwordInput = sender.text else { return }
        password = passwordInput
    }
    
    @objc func loginTapped() {
        guard username != "", password != "" else { fatalError("username: \(username), password: \(password)") }
        loginAction(username, password)
    }
    
    private func enterAction(_ username: String, user: User) {
        UserDefaults.standard.defaultUsername = username
        UserDefaults.standard.autoLoginEnabled = true
        coordinator?.setIndicatorSpinning(false)
        self.coordinator?.move(to: .mainTab)
    }
    
    private func loginAction(_ username: String, _ password: String) {
        coordinator?.setIndicatorSpinning(true)
        APIService.shared.login(username: username, password: password) { [weak self] user, message in
            guard let user = user else {
                self?.coordinator?.handleAPIFailWithMessage(title: "Login Failed", message: nil)
                return
            }
            self?.userService.setUser(user)
            self?.enterAction(username, user: user)
        }
    }
    
    @objc func registerTapped() {
        guard username != "", password != "" else { fatalError() }
        registerAction(username, password)
    }
    
    private func registerAction(_ username: String, _ password: String) {
        coordinator?.setIndicatorSpinning(true)
        APIService.shared.postUser(username: username, password: password) { [weak self] user, errorMessage in
            guard let self = self else { fatalError() }
            if let user = user {
                self.enterAction(username, user: user)
            } else {
                self.coordinator?.handleAPIFailWithMessage(title: "account with \(username) and \(password) cannot be created", message: nil)
            }
        }
    }
    
    private func setupDelegates() {
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    @objc func doneTapped(_ sender: UITextField) {
        
    }
    
    private func setupLayout() {
        [
            logoImageView,
            usernameTextField, passwordTextField,
            loginStackView,
            separatorView,
            thirdPartyStackView
        ].forEach { self.view.addSubview($0) }
        
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
        
        loginStackView.addArrangedSubviews([loginButton, registerButton])
        
        loginStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        
        thirdPartyStackView.addArrangedSubviews([kakaoLogin, googleLogin, appleLogin])
        thirdPartyStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(120)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "sampleIcon")
        return imageView
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: UIColor(white: 0.5, alpha: 1)])
        tf.layer.borderColor = UIColor.deeperMainColor.cgColor
        tf.layer.borderWidth = 2
        tf.backgroundColor = UIColor.mainColor
        tf.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.setLeftPaddingPoints(10)
        tf.tag = 1
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor(white: 0.5, alpha: 1)])
        tf.textColor = .black
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.deeperMainColor.cgColor
        tf.layer.borderWidth = 2
        tf.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        
        tf.setLeftPaddingPoints(10)
        tf.tag = 2
        return tf
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // true -> 키보드 사라짐
        guard let text = textField.text else { return true }
        if textField.tag == 1 {
            // Username
            username = text
            passwordTextField.becomeFirstResponder()
            return false
        } else {
            // Password
            password = text
            textField.resignFirstResponder()
            // perform login
            return true
        }
    }
}
