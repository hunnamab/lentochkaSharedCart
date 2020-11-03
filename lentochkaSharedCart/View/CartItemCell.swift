//
//  CartItemCell.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 03.11.2020.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    static let reuseID  = "CartItemCell"
    let itemImageView   = UIImageView()
    let itemNameLabel   = UILabel()
    let itemPriceLabel  = UILabel()
    let itemTotalLabel  = UILabel()
    
    func setUp(withItem item: CatalogItemCellModel, forCart cart: CartState) {
        configureData(withItem: item, forCart: cart)
        setUpElements()
        setUpConstraints()
    }
    
    private func configureData(withItem item: CatalogItemCellModel, forCart cart: CartState) {
        guard let imageUrl = URL(string: item.image) else { return }
        let imageData = try! Data(contentsOf: imageUrl)
        itemImageView.image = UIImage(data: imageData)
        itemNameLabel.text  = item.name
        itemPriceLabel.text = "\(item.price) ₽ / \(item.unitName)"
        let quantity = (cart == .personal) ? item.personalCartQuantity : item.sharedCartQuantity
        let totalPrice = Double(quantity) * item.price
        itemTotalLabel.text = "\(quantity) \(item.unitName) : \(totalPrice) ₽"
    }
    
    private func setUpElements() {
        itemImageView.contentMode       = .scaleAspectFit
        itemNameLabel.numberOfLines     = 0
        itemNameLabel.font              = UIFont.systemFont(ofSize: 18, weight: .medium)
        itemPriceLabel.font             = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        itemTotalLabel.font             = UIFont.systemFont(ofSize: 16, weight: .medium)
        itemTotalLabel.textColor        = .white
        itemTotalLabel.backgroundColor = UIColor(named: "MainColor")?.withAlphaComponent(0.8)
        itemTotalLabel.layer.cornerRadius = 5
        itemTotalLabel.layer.masksToBounds = true
        itemTotalLabel.textAlignment = .center
    }
    
    private func setUpConstraints() {
        itemTotalLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        let widthWithPadding: CGFloat = itemTotalLabel.intrinsicContentSize.width + 20
        itemTotalLabel.widthAnchor.constraint(equalToConstant: widthWithPadding).isActive = true
        
        let itemPriceStackView = UIStackView(arrangedSubviews: [itemPriceLabel, itemTotalLabel])
        itemPriceStackView.axis         = .vertical
        itemPriceStackView.spacing      = 5
        itemPriceStackView.alignment    = .leading
        
        let itemStackView = UIStackView(arrangedSubviews: [itemNameLabel, itemPriceStackView])
        itemStackView.axis      = .vertical
        itemStackView.alignment = .fill
        itemStackView.spacing   = 7
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemStackView)
        
        let padding: CGFloat    = 20
        let imageSize: CGFloat  = 70
        NSLayoutConstraint.activate([
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            itemImageView.widthAnchor.constraint(equalToConstant: imageSize),
            
            itemStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            itemStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: padding),
            itemStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
}
