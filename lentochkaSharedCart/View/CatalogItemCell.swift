//
//  ItemCell.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import UIKit

class CatalogItemCell: UITableViewCell {

    static let reuseID  = "CatalogItemCell"
    let itemImageView   = UIImageView()
    let itemNameLabel   = UILabel()
    let itemPriceLabel  = UILabel()
    let removeButton    = CatalogButton(currentState: .remove(.small), title: "﹣") //
    let quantityLabel   = UILabel() //
    let button          = CatalogButton(currentState: .add(.small), title: "+")

    func setUp(withItem item: CatalogItemCellModel) {
        itemImageView.image = UIImage(data: item.image)
        itemNameLabel.text  = item.name
        itemPriceLabel.text = "\(item.price) ₽ / \(item.unitName)"
        
        setUpElements()
        setUpConstraints()
    }
    
    private func setUpElements() {
        accessoryType                   = .disclosureIndicator
        removeButton.layer.cornerRadius = 6 //
        removeButton.isHidden           = true //
        quantityLabel.text              = "0" //
        quantityLabel.font              = UIFont.systemFont(ofSize: 16, weight: .medium) //
        quantityLabel.textColor         = UIColor(named: "MainColor")
        button.layer.cornerRadius       = 6
        itemImageView.contentMode       = .scaleAspectFit
        itemNameLabel.numberOfLines     = 0
        itemNameLabel.font              = UIFont.systemFont(ofSize: 18, weight: .medium)
        itemPriceLabel.font             = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    private func setUpConstraints() {
        let buttonStackView = UIStackView(arrangedSubviews: [removeButton, quantityLabel, button])
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        buttonStackView.axis        = .horizontal
        buttonStackView.spacing     = 5
        buttonStackView.alignment   = .center
        
        let itemPriceStackView = UIStackView(arrangedSubviews: [itemPriceLabel, buttonStackView])
        itemPriceStackView.axis         = .horizontal
        itemPriceStackView.distribution = .fill
        itemPriceStackView.alignment    = .center
        
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
