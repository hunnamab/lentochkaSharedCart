//
//  ItemCell.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import UIKit

class CatalogItemCell: UITableViewCell {
    
<<<<<<< HEAD
    static let reuseID = "CatalogItemCell"
    let itemImageView = UIImageView()
    let itemNameLabel = UILabel()
    let itemPriceLabel = UILabel()
    let removeButton = CatalogButton(currentState: .remove(.small), title: "﹣") //
    let quantityLabel = UILabel() //
    let button = CatalogButton(currentState: .add(.small), title: "+")
=======
    static let reuseID  = "CatalogItemCell"
    let itemImageView   = UIImageView()
    let itemNameLabel   = UILabel()
    let itemPriceLabel  = UILabel()
    let removeButton    = CatalogButton(currentState: .remove(.small), title: "﹣") //
    let button          = CatalogButton(currentState: .add(.small), title: "+")
>>>>>>> 1c3c106837027ca2ec8d3881507166cebdc3c323
    
    func setUp(withItem item: CatalogItemCellModel) {
        itemImageView.image = UIImage(data: item.image)
        itemNameLabel.text  = item.name
        itemPriceLabel.text = "\(item.price) ₽ / \(item.unitName)"
        
        setUpElements()
        setUpConstraints()
    }
    
    func toggleState() {
        button.setTitle("﹣", for: .normal)
        button.setTitleColor(.red, for: .normal)
    }
    
    private func setUpElements() {
        accessoryType                   = .disclosureIndicator
        removeButton.layer.cornerRadius = 6 //
<<<<<<< HEAD
//        removeButton.isHidden = true //
        quantityLabel.text = "0" //
        quantityLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium) //
        quantityLabel.textColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 6
        itemImageView.contentMode = .scaleAspectFit
        itemNameLabel.numberOfLines = 0
        itemNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        itemPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
=======
        removeButton.isHidden           = true //
        button.layer.cornerRadius       = 6
        itemImageView.contentMode       = .scaleAspectFit
        itemNameLabel.numberOfLines     = 0
        itemNameLabel.font              = UIFont.systemFont(ofSize: 18, weight: .medium)
        itemPriceLabel.font             = UIFont.systemFont(ofSize: 16, weight: .regular)
>>>>>>> 1c3c106837027ca2ec8d3881507166cebdc3c323
    }
    
    private func setUpConstraints() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemImageView)
        
        let buttonStackView = UIStackView(arrangedSubviews: [itemPriceLabel, removeButton, quantityLabel, button])
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
<<<<<<< HEAD
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .center
=======
        buttonStackView.axis            = .horizontal
        buttonStackView.distribution    = .fillProportionally
        buttonStackView.alignment       = .center
>>>>>>> 1c3c106837027ca2ec8d3881507166cebdc3c323
        
        let itemStackView = UIStackView(arrangedSubviews: [itemNameLabel, buttonStackView])
        itemStackView.axis      = .vertical
        itemStackView.alignment = .fill
        itemStackView.spacing   = 7
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
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
