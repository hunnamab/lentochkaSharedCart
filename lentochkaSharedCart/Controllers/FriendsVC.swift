//
//  FriendsVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class FriendsVC: UITableViewController {
    
    var user: User
    
    var swipeDown = UIRefreshControl()
    
    init(withUser user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        configureBarButtonItems()
        swipeDown.attributedTitle = NSAttributedString(string: "Обновляется")
        swipeDown.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl = swipeDown
    }
    
    private func setUpViewController() {
        tableView.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Люди"
        tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseID)
    }
    
    func configureBarButtonItems() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let image           = UIImage(named: "AddFriend")
        let imageView       = UIImageView(image: image)
        imageView.image     = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "MainColor")
        navigationBar.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let rightPadding: CGFloat   = 20
        let bottomPadding: CGFloat  = 12
        let imageSize: CGFloat      = 25
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationController!.navigationBar.rightAnchor, constant: -rightPadding),
            imageView.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor, constant: -bottomPadding),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize)
        ])
        
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFriendTapped))
        imageView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func addFriendTapped() {
        let alertController = UIAlertController(title: "Добавить друга", message: "Добавьте друга, чтобы пользоваться общей корзиной 🛍", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        
        let addFriend = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let name = alertController.textFields?.first?.text,
                !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            DatabaseManager.shared.fetchUserData(login: name) { [weak self] friend in
                guard let self = self else { return }
                guard let friend = friend, !friend.login.isEmpty else {
                    self.presentErrorAlert(withError: .userNotFound)
                    return
                }
                guard friend.login != self.user.login else {
                    self.presentErrorAlert(withError: .userAlreadyLoggedIn)
                    return
                }
                guard friend.groupHost.isEmpty else {
                    self.presentErrorAlert(withError: .userAlreadyInGroup)
                    return
                }
                if self.user.groupHost.isEmpty {
                    DatabaseManager.shared.addHost(login: self.user.login, to: self.user.login)
                    DatabaseManager.shared.addHost(login: self.user.login, to: friend.login)
                    self.user.groupHost = self.user.login
                    if self.user.group.firstIndex(of: friend) == nil {
                        self.user.group.append(self.user)
                        self.user.group.append(friend)
                    }
                    DatabaseManager.shared.addFriendToCart(friend: friend, to: self.user.login)
                    DatabaseManager.shared.addFriendToCart(friend: self.user, to: self.user.login)
                    self.tableView.reloadData()
                } else {
                    guard self.user.group.firstIndex(of: friend) == nil else {
                        self.presentErrorAlert(withError: .userAlreadyInGroup)
                        return
                    }
                    self.user.group.append(friend)
                    DatabaseManager.shared.addFriendToCart(friend: friend, to: self.user.groupHost)
                    DatabaseManager.shared.addHost(login: self.user.groupHost, to: friend.login)
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(addFriend)
        alertController.addAction(cancelAction)
        if user.login == user.groupHost || user.groupHost.isEmpty {
            present(alertController, animated: true)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if self.user.groupHost != self.user.login {
            DatabaseManager.shared.fetchUserData(login: user.login) { [weak self] user in
                guard let self = self else { return }
                guard let user = user else { return }
                self.user = user
                self.tableView.reloadData()
            }
        }
        self.refreshControl?.endRefreshing()
    }
    
    func presentErrorAlert(withError error: FriendsError) {
        let errorAlert = UIAlertController(title: "Ошибка", message: error.rawValue, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true)
    }
    
}

// MARK: - TableViewDataSource:

extension FriendsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.group.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseID, for: indexPath) as! FriendCell
        let friend = user.group[indexPath.row].login
        if friend == user.login {
            cell.textLabel?.text = friend + " (вы)"
        } else {
            cell.textLabel?.text = friend
        }
        print(user.group[indexPath.row].login)
        cell.isUserInteractionEnabled = false
        cell.setUp(forUser: user, andFriend: friend)
        return cell
    }
    
}

// MARK: - TableViewDelegate:

extension FriendsVC {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if user.login == user.groupHost {
            let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] action, sourceView, completionHandler in
                guard let self = self else { return }
                self.deleteUser(atIndexPath: indexPath)
                completionHandler(true)
            }
            deleteAction.backgroundColor = .orange
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            return nil
        }
    }
    
    private func deleteUser(atIndexPath indexPath: IndexPath) {
        let friend = self.user.group[indexPath.row]
        if friend.login == self.user.login {
            for person in self.user.group {
                DatabaseManager.shared.removeFriendFromCart(friend: person, from: self.user)
            }
            DatabaseManager.shared.removeFriendFromCart(friend: self.user.group[indexPath.row], from: self.user)
            self.user.group.removeAll()
            tableView.reloadData()
        } else {
            DatabaseManager.shared.removeFriendFromCart(friend: self.user.group[indexPath.row], from: self.user)
            self.user.group.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
