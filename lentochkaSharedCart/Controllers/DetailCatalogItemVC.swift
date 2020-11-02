//
//  DetailCatalogItemVC.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import UIKit

class DetailCatalogItemVC: UIViewController {
    
    let itemImageView   = UIImageView()
    let itemNameLabel   = UILabel()
    let weightLabel     = UILabel()
    let itemPriceLabel  = UILabel()
    let buttonsView     = UIView()
    let leftButtonsView = DetailButtonsView(withTitle: "Личная корзина")
    let rightButtonsView = DetailButtonsView(withTitle: "Общая корзина")

    var user: User
    //нужно отделить item для общей и для личной корзины
    var item: CatalogItemCellModel
    
    init(withExtItem extendedItem: CatalogItemModel, with item: CatalogItemCellModel, forUser user: User) {
        self.user = user
        self.item = item
        super.init(nibName: .none, bundle: .none)
        setUpElements(withItem: extendedItem)
        print(extendedItem.name)
        print(item.name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpElements(withItem item: CatalogItemModel) {
        let fullName        = item.name.components(separatedBy: "   ")
        itemNameLabel.text  = fullName[0]
        weightLabel.text    = "Вес: \(fullName[1])"
        itemPriceLabel.text = "\(item.goodsUnitList[0].price) ₽"
        let imageUrl        = URL(string: item.imageHighURL)!
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
    // нужно, чтобы кол-во товаров плюсовалось отдельно для общей корзины и для личной
    @objc func addToPersonalCart(_ sender: CatalogButton) {
        item.personalCartQuantity += 1
        user.personalCart.append(item)
        DatabaseManager.shared.addItemInCart(with: item, to: "alex", cart: "personalCart")
        leftButtonsView.buttonsStackView.quantityLabel.text = "\(item.personalCartQuantity)"
        print("ADD TO PERSONAL CART")
    }
    
    @objc func removeFromPersonalCart(_ sender: CatalogButton) {
        item.personalCartQuantity -= 1
        DatabaseManager.shared.removeItemFromCart(with: item, from: "alex", cart: "personalCart")
        leftButtonsView.buttonsStackView.quantityLabel.text = "\(item.personalCartQuantity)"
        print("REMOVE FROM PERSONAL CART")
    }
    
    @objc func addToGroupCart(_ sender: CatalogButton) {
        item.sharedCartQuantity += 1
        user.sharedCart.append(item)
        DatabaseManager.shared.addItemInCart(with: item, to: "alex", cart: "sharedCart")
        rightButtonsView.buttonsStackView.quantityLabel.text = "\(item.sharedCartQuantity)"
        print("ADD TO GROUP CART")
    }
    
    @objc func removeFromGroupCart(_ sender: CatalogButton) {
        item.sharedCartQuantity -= 1
        DatabaseManager.shared.removeItemFromCart(with: item, from: "alex", cart: "sharedCart")
        rightButtonsView.buttonsStackView.quantityLabel.text = "\(item.sharedCartQuantity)"
        print("REMOVE FROM GROUP CART")
    }
    
    private func setUpButtons() {
        leftButtonsView.buttonsStackView.addButton.addTarget(self, action: #selector(addToPersonalCart(_:)), for: .touchUpInside)
        leftButtonsView.buttonsStackView.removeButton.addTarget(self, action: #selector(removeFromPersonalCart(_:)), for: .touchUpInside)
        rightButtonsView.buttonsStackView.addButton.addTarget(self, action: #selector(addToGroupCart(_:)), for: .touchUpInside)
        rightButtonsView.buttonsStackView.removeButton.addTarget(self, action: #selector(removeFromGroupCart(_:)), for: .touchUpInside)
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
        leftButtonsView.backgroundColor = .systemYellow //
        rightButtonsView.translatesAutoresizingMaskIntoConstraints = false
        rightButtonsView.backgroundColor = .systemTeal //

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
