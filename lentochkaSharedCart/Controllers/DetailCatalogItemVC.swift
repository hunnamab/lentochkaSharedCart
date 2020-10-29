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
    let button = CatalogButton(currentState: .add(.large), title: "Добавить")
    
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
        
        itemNameLabel.numberOfLines = 4
        itemNameLabel.adjustsFontSizeToFitWidth = true
        itemPriceLabel.minimumScaleFactor = 0.5
        itemNameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        itemPriceLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func addButtonTapped(_ sender: CatalogButton) {
        sender.toggleState()
    }
    
    private func setUpConstraints() {
        let bottomStackView = UIStackView(arrangedSubviews: [weightLabel, itemPriceLabel])
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .leading
        bottomStackView.spacing = 5
        
        let stackView = UIStackView(arrangedSubviews: [itemImageView, itemNameLabel, bottomStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.setCustomSpacing(30, after: itemImageView)
        stackView.setCustomSpacing(20, after: itemNameLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let buttonHeight: CGFloat = 70
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -buttonHeight),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
