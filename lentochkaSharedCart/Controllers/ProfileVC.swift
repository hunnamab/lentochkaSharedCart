//
//  ProfileVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    private var logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        setUI()
        setConstraints()
        logoutButton.addTarget(self, action: #selector(logoutButtonWasTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonWasTapped () {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print("Error signing out.")
            return
        }
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let rootVC = LoginVC()
            rootVC.modalPresentationStyle = .fullScreen
            present(rootVC, animated: false)
        }
    }

}

extension ProfileVC {
    
    private func setUI() {
        view.backgroundColor = .white
        
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        logoutButton.layer.cornerRadius = 6.0
        logoutButton.backgroundColor = UIColor(red: 0.168627451,
                                              green: 0.1294117647,
                                              blue: 0.5764705882,
                                              alpha: 1)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
}

extension ProfileVC {
    
    private func setConstraints() {
        
        let buttonStackView = UIStackView(arrangedSubviews: [logoutButton])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 40
        buttonStackView.alignment = .center
        
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            //stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
    }
    
}

