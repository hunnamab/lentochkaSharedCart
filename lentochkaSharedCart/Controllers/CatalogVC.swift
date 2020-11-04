//
//  CatalogVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit
import FirebaseAuth

class CatalogVC: UITableViewController {
    
    private var catalogItems    = [CatalogItemCellModel]()
    private var filteredItems   = [CatalogItemCellModel]()

    private var isSearching = false
    
    private var viewModel: CatalogVM!
    
    var user: User
    
    init(withUser user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for item in user.personalCart {
            print("{\(item.name) - \(item.personalCartQuantity)}")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        setUpViewController()
        setUpSearchBar()
        viewModel = CatalogVM(catalogItems: catalogItems, forUser: user)
        viewModel.parseJSON()
        catalogItems = viewModel.catalogItems // лучше из json'а возвращать
        
    }
    
    private func setUpViewController() {
        tableView.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Каталог"
        
        tableView.register(CatalogItemCell.self, forCellReuseIdentifier: CatalogItemCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setUpSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = UIColor(named: "MainColor")
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по каталогу"
        navigationItem.searchController = searchController
    }

}

// MARK: - TableViewDataSource:

extension CatalogVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredItems.count : catalogItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogItemCell.reuseID, for: indexPath) as! CatalogItemCell
        let item = isSearching ? filteredItems[indexPath.row] : catalogItems[indexPath.row]
        // создать в фабрике модель (добавить в нее поле "добавлено в корзину"
        // - отдельный метод, который берет инфу с сервера и проверяет)
        cell.setUp(withItem: item)
        cell.buttonStackView.addButton.tag = indexPath.row
        cell.buttonStackView.removeButton.tag = indexPath.row
        cell.buttonStackView.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        cell.buttonStackView.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        cell.buttonStackView.quantityLabel.text = "\(item.personalCartQuantity)"
        if item.personalCartQuantity > 0 {
            cell.buttonStackView.removeButton.isHidden = false
        } else {
            cell.buttonStackView.removeButton.isHidden = true
        }
        return cell
    }
    
    @objc func addButtonTapped(_ sender: CatalogButton) {
        let item = isSearching ? filteredItems[sender.tag] : catalogItems[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if item.personalCartQuantity == 0 {
            user.personalCart.append(item)
        }
        let indexToAdd = user.personalCart.firstIndex(of: item)
        if let index = indexToAdd {
            user.personalCart[index].personalCartQuantity += 1
            item.personalCartQuantity = user.personalCart[index].personalCartQuantity
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        DatabaseManager.shared.addItemInCart(with: item, to: user.login, cart: "personalCart")
    }
    
    @objc func removeButtonTapped(_ sender: CatalogButton) {
        let item = isSearching ? filteredItems[sender.tag] : catalogItems[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let indexToRemove = user.personalCart.firstIndex(of: item)
        if let index = indexToRemove, item.personalCartQuantity > 0 {
            user.personalCart[index].personalCartQuantity -= 1
            item.personalCartQuantity = user.personalCart[index].personalCartQuantity
        }
        if item.personalCartQuantity == 0 {
            if let index = indexToRemove {
                user.personalCart.remove(at: index)
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        DatabaseManager.shared.removeItemFromCart(with: item, from: user.login, cart: "personalCart")
    }
    
}

// MARK: - TableViewDelegate:

extension CatalogVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = isSearching ? filteredItems[indexPath.row] : catalogItems[indexPath.row]
        let detailCatalogItemVC = DetailCatalogItemVC(withItem: item, atIndexPath: indexPath, forUser: user)
        detailCatalogItemVC.delegate = self
        present(detailCatalogItemVC, animated: true)
    }
    
}

// MARK: - SearchResultsUpdating, SearchBarDelegate

extension CatalogVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        isSearching = true
        filteredItems = catalogItems.filter { $0.name.lowercased().contains(filter.lowercased())}
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
        }
    }
    
}

extension CatalogVC: DismissDetailVC {
    func detailViewControllerDidDismiss(withItem item: CatalogItemCellModel, atIndexPath indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
