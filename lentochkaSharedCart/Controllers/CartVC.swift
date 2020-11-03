//
//  CartVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class CartVC: UITableViewController {
    
    var user: User
    var cartState: CartState
    
    let segmentedControl = UISegmentedControl(items: ["Личная", "Общая"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        //setUpSegmentedControl()
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    init(style: UITableView.Style, withUser user: User) {
        self.user = user
        self.cartState = .personal
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpSegmentedControl()
    }
    
    private func setUpSegmentedControl() {
        segmentedControl.selectedSegmentIndex = cartState.rawValue
        let color = UIColor(named: "MainColor") ?? UIColor.blue
        segmentedControl.backgroundColor = color
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
        
        let controlHeight: CGFloat = 40
        let padding: CGFloat = 20
        segmentedControl.frame = CGRect(x: 40,
                                        y: -controlHeight,
                                        width: tableView.frame.width - 80,
                                        height: controlHeight)
        tableView.contentInset = UIEdgeInsets(top: controlHeight + padding,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        view.addSubview(segmentedControl)
        print(segmentedControl.frame)
        segmentedControl.addTarget(self, action: #selector(changeCart), for: .valueChanged)
    }
    
    private func setUpViewController() {
        navigationController?.navigationBar.backgroundColor = .white
        // status bar не белый -> костыль:
        let statusBar =  UIView()
        statusBar.frame = UIApplication.shared.statusBarFrame
        statusBar.backgroundColor = .white
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Корзина"
        
        tableView.allowsSelection = false //
        tableView.register(CatalogItemCell.self, forCellReuseIdentifier: CatalogItemCell.reuseID)
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
    }
    
    @objc private func changeCart() {
        cartState.toggle()
        print(cartState)
        // здесь заменим dataSource: товары из личной корзины -> товары из общей корзины и наоборот
        print("!!!")
        tableView.reloadData()
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
            return countCartItems()
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    private func countCartItems() -> Int {
        switch cartState {
        case .personal:
            return user.personalCart.count
        case .shared:
            return user.sharedCart.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CatalogItemCell.reuseID, for: indexPath) as! CatalogItemCell
            let item = getCartItem(forRow: indexPath.row)
            cell.setUp(withItem: item)
            cell.buttonStackView.isHidden = true
            cell.accessoryType = .none
            return cell
        case let x where x == 1 || x == 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            if x == 1 {
                cell.setUp(cellType: .price, detailInfo: countTotalPrice())
            } else {
                cell.setUp(cellType: .weight, detailInfo: countTotalWeight())
            }
            return cell
        default:
            fatalError()
        }
    }
    
    private func getCartItem(forRow row: Int) -> CatalogItemCellModel {
        switch cartState {
        case .personal:
            return user.personalCart[row]
        case .shared:
            return user.sharedCart[row]
        }
    }
    
    private func countTotalPrice() -> String {
        let cart = (cartState == .personal) ? user.personalCart : user.sharedCart
        var total: Double = 0
        for item in cart {
            let quantity = (cartState == .personal) ? item.personalCartQuantity : item.sharedCartQuantity
            total += item.price * Double(quantity)
        }
        let isInteger = floor(total) == total
        return isInteger ? "\(Int(total)) ₽" : "\(total) ₽"
    }
    
    private func countTotalWeight() -> String {
        let cart = (cartState == .personal) ? user.personalCart : user.sharedCart
        var total: Double = 0
        for item in cart {
            let quantity = (cartState == .personal) ? item.personalCartQuantity : item.sharedCartQuantity
            let weight = Double(Array(item.weight) // переделать
                .compactMap { Int(String($0)) }
                .map { String($0) }
                .joined()) ?? 0
            total += weight * Double(quantity)
        }
        let isInteger = floor(total) == total
        return isInteger ? "\(Int(total)) г" : "\(total) г"
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
