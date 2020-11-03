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
//        setUpSegmentedControl()
    }
    
    private func setUpSegmentedControlView() -> UIView {
        setUpSegmentedControl()
        let segmentedControlView = UIView()
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let sidePadding: CGFloat = 40
        let topPadding: CGFloat = 30
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlView.leadingAnchor, constant: sidePadding),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlView.trailingAnchor, constant: -sidePadding),
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlView.topAnchor, constant: topPadding),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlView.bottomAnchor)
        ])
        return segmentedControlView
    }
    
    private func setUpSegmentedControl() {
        segmentedControl.selectedSegmentIndex = cartState.rawValue
        let color = UIColor(named: "MainColor") ?? UIColor.blue
        segmentedControl.backgroundColor = color
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
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
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.reuseID)
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
    }
    
    @objc private func changeCart() {
        cartState.toggle()
        tableView.reloadData()
    }
    
}

// MARK: - TableViewDataSource

extension CartVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return countCartItems()
        case 2:
            return 1
        case 3:
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseID, for: indexPath) as! CartItemCell
            let item = getCartItem(forRow: indexPath.row)
            print(item.name, item.personalCartQuantity, item.sharedCartQuantity)
            cell.setUp(withItem: item, forCart: cartState)
            return cell
        case let x where x == 2 || x == 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            if x == 2 {
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
        case 1:
            return "Список товаров"
        case 2:
            return "Сумма заказа"
        case 3:
            return "Общий вес"
        default:
            return nil
        }
    }
    
}

// MARK: - TableViewDelegate:

extension CartVC {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 70
        } else {
            return tableView.sectionHeaderHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return setUpSegmentedControlView()
        } else {
            return nil
        }
    }
    
}
