//
//  CatalogVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit
import FirebaseAuth

class CatalogVC: UITableViewController {
    
    private var extendedCatalogItems    = [CatalogItemModel]()
    private var filteredExtendedItems   = [CatalogItemModel]()
    
    private var catalogItems    = [CatalogItemCellModel]()
    private var filteredItems   = [CatalogItemCellModel]()

    private var isSearching = false
    private var id: String?
    
    private var viewModel: CatalogVM!
    
    var user: User
    
    init(withUser user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        setUpViewController()
        setUpSearchBar()
        viewModel = CatalogVM(extendedCatalogItems: extendedCatalogItems, catalogItems: catalogItems)
        viewModel.parseJSON()
        extendedCatalogItems = viewModel.extendedCatalogItems
        catalogItems = viewModel.catalogItems
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
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addButtonTapped(_ sender: CatalogButton) {
        let item = isSearching ? filteredItems[sender.tag] : catalogItems[sender.tag]
        switch sender.currentState {
        case .add(let size):
//            if size == .small {
//                let indexPath = IndexPath(row: sender.tag, section: 0)
//                let cell = tableView(tableView, cellForRowAt: indexPath) as! CatalogItemCell
//                cell.removeButton.isHidden = false
//            }
            user.personalCart.append(item)
            DatabaseManager.shared.addItemInCart(with: item, to: "alex", cart: "personalCart")
        case .remove:
//            let itemToRemove = user.personalCart.filter { $0.id == item.id }
            DatabaseManager.shared.removeItemFromCart(with: item, from: "alex", cart: "personalCart")
        }
        sender.toggleState()
    }
    
}

// MARK: - TableViewDelegate:

extension CatalogVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = isSearching ? filteredExtendedItems[indexPath.row] : extendedCatalogItems[indexPath.row]
        let detailCatalogItemVC = DetailCatalogItemVC(withItem: item)
        present(detailCatalogItemVC, animated: true)
//        navigationController?.pushViewController(detailCatalogItemVC, animated: true)
    }
    
}

// MARK: - SearchResultsUpdating, SearchBarDelegate

extension CatalogVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        isSearching = true
        filteredItems = catalogItems.filter { $0.name.lowercased().contains(filter.lowercased())}
        filteredExtendedItems = extendedCatalogItems.filter { $0.name.lowercased().contains(filter.lowercased())}
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
