//
//  CatalogButtonsStackView.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 01.11.2020.
//

import UIKit

class CatalogButtonsStackView: UIStackView {
    
    let removeButton    = CatalogButton(currentState: .remove(.small), title: "﹣") //
    let quantityLabel   = UILabel() //
    let addButton          = CatalogButton(currentState: .add(.small), title: "+")
    
    init() {
        super.init(frame: .zero)
        setUpArrangedSubviews()
        setUpElements()
        setUpStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpArrangedSubviews() {
        addArrangedSubview(removeButton)
        addArrangedSubview(quantityLabel)
        addArrangedSubview(addButton)
    }
    
    private func setUpElements() {
        removeButton.layer.cornerRadius = 6
        quantityLabel.text              = "0"
        quantityLabel.font              = UIFont.systemFont(ofSize: 15, weight: .bold)
        quantityLabel.textColor         = UIColor(named: "MainColor")
        addButton.layer.cornerRadius       = 6
    }
    
    private func setUpStackView() {
        axis        = .horizontal
        spacing     = 5
        alignment   = .center
        addButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
