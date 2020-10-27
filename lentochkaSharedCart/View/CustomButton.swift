//
//  CustomButton.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6.0
        backgroundColor = #colorLiteral(red: 0.168627451, green: 0.1294117647, blue: 0.5764705882, alpha: 1)
        tintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
}
