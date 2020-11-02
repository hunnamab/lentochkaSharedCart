//
//  ViewController.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 26.10.2020.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    private var loginTextField      = UITextField()
    private var passwordTextField   = UITextField()
    private var loginButton         = UIButton(type: .system)
    private var forgotPasswordLabel = UILabel()
    weak    var delegate: CreateUser?
    
    var viewModel: LoginVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.text         = "alex"
        passwordTextField.text      = "123456"
        self.modalPresentationStyle = .fullScreen
        setUpUI()
        setUpConstraints()
        loginButton.addTarget(self, action: #selector(loginButtonWasTapped),
                              for: .touchUpInside)
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc private func loginButtonWasTapped () {
        guard let login = loginTextField.text,
            let password = passwordTextField.text,
            !login.isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
            alertUserLoginError()
            return
        }
        let email = login + "@mail.ru"
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] result, error in
            guard let strongSelf = self else { return }
            guard result != nil, error == nil else {
                print("Failed to log in.")
                return
            }
            DatabaseManager.shared.fetchUserData(login: login) {
                [weak self] user in
                guard let self = self, let user = user else { return }
                //DatabaseManager.shared.addUser(with: user)
                strongSelf.delegate?.setNewUser(user)
            }
            strongSelf.self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Вы ввели неправильный логин или пароль",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать снова", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

extension LoginVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonWasTapped()
        }
        return true
    }
    
}

extension LoginVC {
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        loginTextField.placeholder              = "Логин"
        loginTextField.autocapitalizationType   = .none
        loginTextField.textAlignment            = .center
        loginTextField.textColor                = .black
        loginTextField.font                     = UIFont.systemFont(ofSize: 20,
                                                                    weight: .regular)
        loginTextField.layer.borderColor        = UIColor.lightGray.cgColor
        loginTextField.layer.borderWidth        = 1
        loginTextField.layer.cornerRadius       = 8
        loginTextField.returnKeyType            = .continue
        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.placeholder           = "Пароль"
        passwordTextField.isSecureTextEntry     = true
        passwordTextField.textAlignment         = .center
        passwordTextField.textColor             = .black
        passwordTextField.font                  = UIFont.systemFont(ofSize: 20,
                                                                    weight: .regular)
        passwordTextField.layer.borderColor     = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth     = 1
        passwordTextField.layer.cornerRadius    = 8
        passwordTextField.returnKeyType         = .done
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font            = UIFont.systemFont(ofSize: 22,
                                                                    weight: .medium)
        loginButton.layer.cornerRadius          = 6.0
        loginButton.backgroundColor             = UIColor(named: "MainColor")
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        forgotPasswordLabel.text        = "Забыли пароль?"
        forgotPasswordLabel.font        = UIFont.systemFont(ofSize: 16, weight: .regular)
        forgotPasswordLabel.textColor   = .black
    }
    
}

extension LoginVC {
    
    private func setUpConstraints() {
        let loginStackView              = UIStackView(arrangedSubviews: [loginTextField,
                                                                         passwordTextField])
        loginStackView.axis             = .vertical
        loginStackView.distribution     = .equalSpacing
        loginStackView.spacing          = 20
        loginStackView.alignment        = .fill
        
        let buttonStackView             = UIStackView(arrangedSubviews: [loginButton,
                                                                         forgotPasswordLabel])
        buttonStackView.axis            = .vertical
        buttonStackView.distribution    = .fillEqually
        buttonStackView.spacing         = 40
        buttonStackView.alignment       = .center
        
        let stackView                   = UIStackView(arrangedSubviews: [loginStackView,
                                                                         buttonStackView])
        stackView.axis                  = .vertical
        stackView.distribution          = .equalSpacing
        stackView.spacing               = 30
        stackView.alignment             = .fill
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    
}
