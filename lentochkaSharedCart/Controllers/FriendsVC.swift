//
//  FriendsVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class FriendsVC: UITableViewController {
    
    var friends = [User]()
    let reuseIdentifier = "TableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        configureBarButtonItems()
    }
    
    private func setUpViewController() {
        tableView.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Люди"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureBarButtonItems() {
        let leftBarButton = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(editFriendTapped))
        navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriendTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func addFriendTapped() {
        // будем добавлять по email или по имени?
        let alertController = UIAlertController(title: "Добавить друга", message: "Добавьте друга, чтобы пользоваться общей корзиной🛍", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        
        let addFriend = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // здесь логика для проверки, есть ли у нас в базе такой пользователь
            // если нет, можно вывести еще один alert с ошибкой
            // по идее, если пользователь есть, здесь надо с сервера подтянуть всю информацию о нем в
            // свойство friends
            
            // пока сделаю просто
            guard let name = alertController.textFields?.first?.text,
                !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            let newFriend = User(login: name, cart: nil, group: nil)
            self.friends.append(newFriend)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(addFriend)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func editFriendTapped() {
        tableView.isEditing = !tableView.isEditing
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Готово" : "Изменить"
    }
}

// MARK: - TableViewDataSource:

extension FriendsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = friends[indexPath.row].login
        cell.isUserInteractionEnabled = false
        return cell
    }
}

// MARK: - TableViewDelegate:

extension FriendsVC {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] action, sourceView, completionHandler in
            guard let self = self else { return }
            self.friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // добавить удаление друга из структуры юзера и на сервере
            completionHandler(true)
        }
        deleteAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
