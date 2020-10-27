//
//  ViewController.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 26.10.2020.
//

import UIKit

class LoginVC: UIViewController {

    var loginTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    var forgotPasswordLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        loginTextField.placeholder = "Логин"
        loginTextField.textAlignment = .center
        loginTextField.textColor = .black
        loginTextField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        loginTextField.layer.borderColor = UIColor.lightGray.cgColor
        loginTextField.layer.borderWidth = 1
        loginTextField.layer.cornerRadius = 8
        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.textAlignment = .center
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.purple, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        
        forgotPasswordLabel.text = "Забыли пароль?"
        forgotPasswordLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        forgotPasswordLabel.textColor = .black
    }
    
    private func setConstraints() {
        let loginStackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField])
        loginStackView.axis = .vertical
        loginStackView.distribution = .equalSpacing
        loginStackView.spacing = 20
        loginStackView.alignment = .fill
        
        let buttonStackView = UIStackView(arrangedSubviews: [loginButton, forgotPasswordLabel])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 50
        buttonStackView.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [loginStackView, buttonStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
    }
}

