//
//  DetailButtonsView.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 01.11.2020.
//

import UIKit

class DetailButtonsView: UIView {
    
    let titleLabel = UILabel()
    let buttonsStackView = CatalogButtonsStackView()

    init(withTitle title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setUpUI()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        buttonsStackView.distribution = .equalSpacing
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(named: "MainColor")
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.3
        titleLabel.textAlignment = .center
    }
    
    private func setUpConstraints() {
        buttonsStackView.distribution = .equalSpacing
        let stackView = UIStackView(arrangedSubviews: [titleLabel, buttonsStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
}
