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
    var numberOfSections = 1
    
    let segmentedControl = UISegmentedControl(items: ["Личная", "Общая"])
    
    var swipeDown = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        swipeDown.attributedTitle = NSAttributedString(string: "Обновляется")
        swipeDown.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl = swipeDown
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
    
    @objc func refresh(_ sender: AnyObject) {
        switch cartState {
        case .personal:
            self.refreshControl?.endRefreshing()
        case .shared:
            if self.user.groupHost != self.user.login {
                DatabaseManager.shared.fetchUserData(login: self.user.login, completion: { [weak self] user in
                    guard let self = self else { return }
                    guard let user = user else { return }
                    self.user = user
                    self.tableView.reloadData()
                }
            )}
            self.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: - TableViewDataSource

extension CartVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let segmentedControlSections = 1
        let totalSections = 2
        var totalUsers = 0
        switch cartState {
        case .personal:
            totalUsers = 1
        case .shared:
            totalUsers = user.sharedCart.keys.count
        }
        numberOfSections = segmentedControlSections + totalSections + totalUsers
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case let x where x > 0 && x < numberOfSections - 2:
            if cartState == .personal {
                return countCartItems()
            } else {
                let key = user.sharedCart.keys.sorted()[x-1]
                return user.sharedCart[key]!.count
            }
        case numberOfSections - 2:
            return 1
        case numberOfSections - 1:
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
        case let x where x > 0 && x < numberOfSections - 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseID, for: indexPath) as! CartItemCell
            let item = getCartItem(forIndexPath: indexPath)
            cell.setUp(withItem: item, forCart: cartState)
            return cell
        case let x where x == numberOfSections - 2 || x == numberOfSections - 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            if x == numberOfSections - 2 {
                cell.setUp(cellType: .price, detailInfo: countTotalPrice())
            } else {
                cell.setUp(cellType: .weight, detailInfo: countTotalWeight())
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            return cell
        }
    }
    
    private func getCartItem(forIndexPath indexPath: IndexPath) -> CatalogItemCellModel {
        switch cartState {
        case .personal:
            return user.personalCart[indexPath.row]
        case .shared:
            let x = indexPath.section
            let key = user.sharedCart.keys.sorted()[x-1]
            return user.sharedCart[key]![indexPath.row]
        }
    }
    
    private func countTotalPrice() -> String {
        var total: Double = 0
        switch cartState {
        case .personal:
            let cart = user.personalCart
            for item in cart {
                let quantity = item.personalCartQuantity
                total += item.price * Double(quantity)
            }
        case .shared:
            let cart = user.sharedCart
            for (_, items) in cart {
                for item in items {
                    let quantity = item.sharedCartQuantity
                    total += item.price * Double(quantity)
                }
            }
        }
        let isInteger = floor(total) == total
        return isInteger ? "\(Int(total)) ₽" : "\(String(format: "%.2f", total)) ₽"
    }
    
    private func countTotalWeight() -> String {
        var total: Double = 0
        switch cartState {
        case .personal:
            let cart = user.personalCart
            for item in cart {
                let quantity = item.personalCartQuantity
                let weight = splitWeight(weight: item.weight)
                total += weight * Double(quantity)
            }
        case .shared:
            let cart = user.sharedCart
            for (_, items) in cart {
                for item in items {
                    let quantity = item.sharedCartQuantity
                    let weight = splitWeight(weight: item.weight)
                    total += weight * Double(quantity)
                }
            }
        }
        let isInteger = floor(total) == total
        return isInteger ? "\(Int(total)) г" : "\(String(format: "%.2f", total)) г"
    }
    
    private func splitWeight(weight: String) -> Double {
        Double(Array(weight)
            .compactMap { Int(String($0)) }
            .map { String($0) }
            .joined()) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case let x where x > 0 && x < numberOfSections - 2:
            if cartState == .personal {
                return "Список товаров"
            } else {
                return user.sharedCart.keys.sorted()[x-1]
            }
        case numberOfSections - 2:
            return "Сумма заказа"
        case numberOfSections - 1:
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
