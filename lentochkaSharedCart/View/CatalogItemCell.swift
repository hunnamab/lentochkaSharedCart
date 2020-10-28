//
//  ItemCell.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import UIKit

class CatalogItemCell: UITableViewCell {
    
    static let reuseID = "CatalogItemCell"
    let itemImageView = UIImageView()
    let itemNameLabel = UILabel()
    let itemPriceLabel = UILabel()
    let button = CatalogButton(currentState: .add, title: "+")
    
    func setUp(withItem item: CatalogItemCellModel) {
        itemImageView.image = UIImage(data: item.image)
        itemNameLabel.text = item.name
        itemPriceLabel.text = "\(item.price) ₽ / \(item.unitName)"
        
        setUpElements()
        setUpConstraints()
    }
    
    private func setUpElements() {
        accessoryType = .disclosureIndicator
        
        button.layer.cornerRadius = 6
        itemImageView.contentMode = .scaleAspectFit
        itemNameLabel.numberOfLines = 0
        itemNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        itemPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    private func setUpConstraints() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemImageView)
        
        let buttonStackView = UIStackView(arrangedSubviews: [itemPriceLabel, button])
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.alignment = .center
        
        let itemStackView = UIStackView(arrangedSubviews: [itemNameLabel, buttonStackView])
        itemStackView.axis = .vertical
        itemStackView.alignment = .fill
        itemStackView.spacing = 7
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemStackView)
        
        let padding: CGFloat = 20
        let imageSize: CGFloat = 70
        NSLayoutConstraint.activate([
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            itemImageView.widthAnchor.constraint(equalToConstant: imageSize),
            
            itemStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: padding),
            itemStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
    }
    
}
