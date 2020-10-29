//
//  CatalogVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class CatalogVC: UITableViewController {
    
    var extendedCatalogItems = [CatalogItemModel]()
    var filteredExtendedItems = [CatalogItemModel]()
    
    var catalogItems = [CatalogItemCellModel]()
    var filteredItems = [CatalogItemCellModel]()

    var isSearching = false
    
    var viewModel: CatalogVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CatalogItemCell.self, forCellReuseIdentifier: CatalogItemCell.reuseID)
        
//        setUpViewController()
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
    }
    
    private func setUpSearchBar() {
        let searchController = UISearchController()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogItemCell.reuseID) as! CatalogItemCell
        let item = isSearching ? filteredItems[indexPath.row] : catalogItems[indexPath.row]
        cell.setUp(withItem: item)
        
        return cell
    }
}

// MARK: - TableViewDelegate:
extension CatalogVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
