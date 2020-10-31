//
//  CartVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class CartVC: UITableViewController {
    
    let segmentedControl = UISegmentedControl(items: ["Личная", "Общая"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        setUpSegmentedControl()
        setUpViewController()
    }
    
    private func setUpSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        let color = UIColor(red: 0.168627451,
        green: 0.1294117647,
        blue: 0.5764705882,
        alpha: 1) // заменить на константу
        segmentedControl.backgroundColor = color
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
        
        let controlHeight: CGFloat = 40
        let padding: CGFloat = 20
        segmentedControl.frame = CGRect(x: 40, y: -controlHeight, width: view.frame.width - 80, height: controlHeight)
        tableView.contentInset = UIEdgeInsets(top: controlHeight + padding, left: 0, bottom: 0, right: 0)
        view.addSubview(segmentedControl)
        
        segmentedControl.addTarget(self, action: #selector(changeCart), for: .valueChanged)
    }
    
    private func setUpViewController() {
        navigationController?.navigationBar.backgroundColor = .white // status bar не белый
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Корзина"
        
        tableView.allowsSelection = false //
        tableView.register(CatalogItemCell.self, forCellReuseIdentifier: CatalogItemCell.reuseID)
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
    }
    
    @objc private func changeCart() {
        // здесь заменим dataSource: товары из личной корзины -> товары из общей корзины и наоборот
        print("!!!")
    }
    
}

// MARK: - TableViewDataSource

extension CartVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5 // вернуть количество айтемов в корзине
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CatalogItemCell.reuseID, for: indexPath) as! CatalogItemCell
//            cell.setUp(withItem: <#T##CatalogItemCellModel#>)
//            cell.button.isHidden = true
            return cell
        case let x where x == 1 || x == 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            if x == 1 {
//                cell.setUp(cellType: .price, detailInfo: <#T##String#>)
            } else {
//                cell.setUp(cellType: .weight, detailInfo: <#T##String#>)
            }
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Список товаров"
        case 1:
            return "Сумма заказа"
        case 2:
            return "Общий вес"
        default:
            return nil
        }
    }
    
}

// MARK: - TableViewDelegate:

extension CartVC {
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        //
    //    }
    
}
