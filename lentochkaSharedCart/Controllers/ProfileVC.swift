//
//  ProfileVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileVC: UIViewController {
    
    let user: User
    
    init(withUser user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var avatarImageView: UIImageView = {
        let imageView                   = UIImageView()
        imageView.layer.cornerRadius    = 50
        imageView.clipsToBounds         = true
        imageView.layer.masksToBounds   = true
        return imageView
    }()
    private let loginLabel      = UILabel()
    private let addAvatarButton = UIButton(type: .system)
    private var logoutButton    = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        setUpViewController()
        setUpUI()
        setUpConstraints()
        logoutButton.addTarget(self, action: #selector(logoutButtonWasTapped), for: .touchUpInside)
    }
    
    private func setUpViewController() {
        view.backgroundColor                                    = .white
        navigationController?.navigationBar.prefersLargeTitles  = true
        navigationItem.largeTitleDisplayMode                    = .always
        navigationItem.title                                    = "Профиль"
    }
    
    @objc private func logoutButtonWasTapped () {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print("Error signing out.")
            return
        }
        if FirebaseAuth.Auth.auth().currentUser == nil {
            AppDelegate.shared.rootViewController.showLoginScreen()
        }
    }
    
    @objc private func addAvatar() {
        let picker              = UIImagePickerController()
        picker.allowsEditing    = true
        picker.delegate         = self
        present(picker, animated: true)
    }
    
}

extension ProfileVC {
    
    private func setUpUI() {
        view.backgroundColor = .white

        addAvatarButton.setTitle("Изменить фото", for: .normal)
        addAvatarButton.setTitleColor(.blue, for: .normal)
        addAvatarButton.addTarget(self, action: #selector(addAvatar),
                                  for: .touchUpInside)
        addAvatarButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,
                                                             weight: .regular)

        DatabaseManager().fetchProfileImage(forUser: user.login) { (url) in
            let imageData = try! Data(contentsOf: url)
            self.avatarImageView.image = UIImage(data: imageData)
        }
        avatarImageView.backgroundColor     = UIColor(named: "MainColor")
        avatarImageView.contentMode         = .scaleAspectFit
        avatarImageView.layer.cornerRadius  = 100
        avatarImageView.layer.masksToBounds = true
        avatarImageView.clipsToBounds       = true
        
        loginLabel.text = user.login
        loginLabel.textColor = .black
        loginLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font   = UIFont.systemFont(ofSize: 22,
                                                        weight: .medium)
        logoutButton.layer.cornerRadius = 6.0
        logoutButton.backgroundColor    = UIColor(named: "MainColor")
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
}

extension ProfileVC {
    
    private func setUpConstraints() {
        
        let stackView           = UIStackView(arrangedSubviews: [addAvatarButton, logoutButton])
        stackView.axis          = .vertical
        stackView.distribution  = .fillEqually
        stackView.spacing       = 40
        stackView.alignment     = .center
        
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 200),
            avatarImageView.heightAnchor.constraint(equalToConstant: 200),
            avatarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            
            stackView.topAnchor.constraint(equalTo: loginLabel.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        avatarImageView.image = image
        DatabaseManager().uploadProfileImage(forUser: user.login, photo: image)
        dismiss(animated: true, completion: nil)
    }
    
}
