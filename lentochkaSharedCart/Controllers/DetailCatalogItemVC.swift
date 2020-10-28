//
//  DetailCatalogItemVC.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import UIKit

class DetailCatalogItemVC: UIViewController {
    
    let itemImageView = UIImageView()
    let itemNameLabel = UILabel()
    let weightLabel = UILabel()
    let itemPriceLabel = UILabel()
    let button = CatalogButton(currentState: .add, title: "Добавить")
    
    init(withItem item: CatalogItemModel) {
        super.init(nibName: .none, bundle: .none)
        
        let fullName = item.name.components(separatedBy: "   ")
        itemNameLabel.text = fullName[0]
        weightLabel.text = "Вес: \(fullName[1])"
        itemPriceLabel.text = "\(item.goodsUnitList[0].price) ₽"
        let imageUrl = URL(string: item.imageHighURL)!
        let image = try! Data(contentsOf: imageUrl)
        itemImageView.image = UIImage(data: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        setUpUI()
        setUpConstraints()
    }
    
    private func setUpUI() {
        itemImageView.contentMode = .scaleAspectFit
        let imageHeight = view.bounds.size.height / 3
        itemImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        itemNameLabel.numberOfLines = 0
        itemNameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        itemPriceLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    private func setUpConstraints() {
        let stackView = UIStackView(arrangedSubviews: [itemImageView, itemNameLabel, weightLabel, itemPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let buttonHeight: CGFloat = 70
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -buttonHeight),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
