//
//  DetailCatalogItemVC.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import UIKit

protocol DismissDetailVC: AnyObject {
    func detailViewControllerDidDismiss(withItem item: CatalogItemCellModel, atIndexPath indexPath: IndexPath)
}

class DetailCatalogItemVC: UIViewController {
    
    let itemImageView   = UIImageView()
    let itemNameLabel   = UILabel()
    let weightLabel     = UILabel()
    let itemPriceLabel  = UILabel()
    let buttonsView     = UIView()
    let leftButtonsView = DetailButtonsView(withTitle: "Личная корзина")
    let rightButtonsView = DetailButtonsView(withTitle: "Общая корзина")
    
    weak var delegate: DismissDetailVC?

    var user: User
    var item: CatalogItemCellModel
    let indexPath: IndexPath
    
    init(withItem item: CatalogItemCellModel, atIndexPath indexPath: IndexPath, forUser user: User) {
        self.user = user
        self.item = item
        self.indexPath = indexPath
        super.init(nibName: .none, bundle: .none)
        setUpElements(withItem: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpElements(withItem item: CatalogItemCellModel) {
        itemNameLabel.text  = item.name
        weightLabel.text    = "Вес: \(item.weight)"
        itemPriceLabel.text = "\(item.price) ₽"
        let imageUrl        = URL(string: item.bigImage)!
        let image           = try! Data(contentsOf: imageUrl)
        itemImageView.image = UIImage(data: image)
        leftButtonsView.buttonsStackView.quantityLabel.text = "\(self.item.personalCartQuantity)"
        rightButtonsView.buttonsStackView.quantityLabel.text = "\(self.item.sharedCartQuantity)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "ItemBackground")
        setUpUI()
        setUpButtons()
        setUpConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.detailViewControllerDidDismiss(withItem: item, atIndexPath: indexPath)
    }
    
    private func setUpUI() {
        itemImageView.contentMode   = .scaleAspectFit
        let imageHeight             = view.bounds.size.height / 4
        itemImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        itemNameLabel.numberOfLines             = 4
        itemNameLabel.adjustsFontSizeToFitWidth = true
        itemPriceLabel.minimumScaleFactor       = 0.4
        itemNameLabel.font                      = UIFont.systemFont(ofSize: 34, weight: .bold)
        itemPriceLabel.font                     = UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    
    @objc func addToPersonalCart(_ sender: CatalogButton) {
        if item.personalCartQuantity == 0 {
            user.personalCart.append(item)
        }
        item.personalCartQuantity += 1
        DatabaseManager.shared.addItemInCart(with: item, to: user, cart: "personalCart")
        leftButtonsView.buttonsStackView.quantityLabel.text = "\(item.personalCartQuantity)"
    }
    
    @objc func removeFromPersonalCart(_ sender: CatalogButton) {
        if item.personalCartQuantity > 0 {
            item.personalCartQuantity -= 1
            let indexToRemove = user.personalCart.firstIndex(of: item)
            if item.personalCartQuantity == 0,
                let index = indexToRemove {
                user.personalCart.remove(at: index)
            }
        }
        DatabaseManager.shared.removeItemFromCart(with: item, from: user, cart: "personalCart")
        leftButtonsView.buttonsStackView.quantityLabel.text = "\(item.personalCartQuantity)"
    }
    
    @objc func addToSharedCart(_ sender: CatalogButton) {
        guard !user.groupHost.isEmpty else {
            presentErrorAlert()
            return
        }
        if item.sharedCartQuantity == 0 {
            var items = user.sharedCart[user.login] ?? [CatalogItemCellModel]()
            items.append(item)
            user.sharedCart[user.login] = items
        }
        item.sharedCartQuantity += 1
        if let indexToAdd = user.sharedCart[user.login]?.firstIndex(of: item) {
            user.sharedCart[user.login]![indexToAdd].sharedCartQuantity = item.sharedCartQuantity
        }
        DatabaseManager.shared.addItemInCart(with: item, to: user, cart: "sharedCart")
        rightButtonsView.buttonsStackView.quantityLabel.text = "\(item.sharedCartQuantity)"
    }
    
    @objc func removeFromSharedCart(_ sender: CatalogButton) {
        guard !user.groupHost.isEmpty else {
            presentErrorAlert()
            return
        }
        if item.sharedCartQuantity > 0 {
            item.sharedCartQuantity -= 1
            let indexToRemove = user.sharedCart[user.login]?.firstIndex(of: item)
            if let indexToRemove = indexToRemove {
                user.sharedCart[user.login]?[indexToRemove].sharedCartQuantity = item.sharedCartQuantity
                if item.sharedCartQuantity == 0 {
                    user.sharedCart[user.login]?.remove(at: indexToRemove)
                }
            }
        }
        DatabaseManager.shared.removeItemFromCart(with: item, from: user, cart: "sharedCart")
        rightButtonsView.buttonsStackView.quantityLabel.text = "\(item.sharedCartQuantity)"
    }
    
    func presentErrorAlert() {
        let errorAlert = UIAlertController(title: "Ошибка", message: "Добавьте друзей, чтобы пользоваться общей корзиной🛒", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true)
    }
    
    private func setUpButtons() {
        leftButtonsView.buttonsStackView.addButton.addTarget(self, action: #selector(addToPersonalCart(_:)), for: .touchUpInside)
        leftButtonsView.buttonsStackView.removeButton.addTarget(self, action: #selector(removeFromPersonalCart(_:)), for: .touchUpInside)
        rightButtonsView.buttonsStackView.addButton.addTarget(self, action: #selector(addToSharedCart(_:)), for: .touchUpInside)
        rightButtonsView.buttonsStackView.removeButton.addTarget(self, action: #selector(removeFromSharedCart(_:)), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        let bottomStackView             = UIStackView(arrangedSubviews: [weightLabel, itemPriceLabel])
        bottomStackView.axis            = .vertical
        bottomStackView.distribution    = .equalSpacing
        bottomStackView.spacing         = 5
        bottomStackView.alignment       = .leading
        
        let stackView           = UIStackView(arrangedSubviews: [itemImageView, itemNameLabel,
                                                                 bottomStackView])
        stackView.axis          = .vertical
        stackView.alignment     = .leading
        stackView.distribution  = .equalSpacing
        
        view.addSubview(stackView)
        view.addSubview(buttonsView)
        buttonsView.addSubview(leftButtonsView)
        buttonsView.addSubview(rightButtonsView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        leftButtonsView.translatesAutoresizingMaskIntoConstraints = false
        leftButtonsView.backgroundColor = .systemYellow
        rightButtonsView.translatesAutoresizingMaskIntoConstraints = false
        rightButtonsView.backgroundColor = .systemTeal

        let padding: CGFloat = 50
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let buttonHeight: CGFloat = 100 + bottomInset
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -padding),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            leftButtonsView.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            leftButtonsView.trailingAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            leftButtonsView.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            leftButtonsView.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            
            rightButtonsView.leadingAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            rightButtonsView.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            rightButtonsView.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            rightButtonsView.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor)
        ])
    }

}
