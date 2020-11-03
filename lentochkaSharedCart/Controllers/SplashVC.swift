//
//  SplashVC.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 04.11.2020.
//

import UIKit
import Firebase
import FirebaseAuth

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showLoadingVC()
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            AppDelegate.shared.rootViewController.showLoginScreen()
        } else {
            let currentUser = FirebaseAuth.Auth.auth().currentUser
            let login = String(currentUser?.email?.split(separator: "@")[0] ?? "")
            DatabaseManager.shared.fetchUserData(login: login) { user in
                guard let user = user else { return }
                AppDelegate.shared.rootViewController.showMainScreen(withUser: user)
            }
        }
    }
    
    private func showLoadingVC() {
        let loadingVC                       = UIViewController()
        loadingVC.view.backgroundColor      = .white
        loadingVC.modalPresentationStyle    = .fullScreen
        
        let activityIndicator               = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        let transfrom                       = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        activityIndicator.transform         = transfrom
        activityIndicator.color             = UIColor(named: "MainColor")
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 300),
            activityIndicator.heightAnchor.constraint(equalToConstant: 300)
        ])
        activityIndicator.startAnimating()
    }

}
