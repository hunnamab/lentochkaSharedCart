//
//  ButtonsSettings.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import Foundation
import UIKit

func setUnselectedButtonColor(btn1: UIButton, btn2: UIButton, btn3: UIButton) {
    btn1.tintColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
    btn2.tintColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
    btn3.tintColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
}

func setSelectedButtonColor(btn: UIButton) {
    btn.tintColor = #colorLiteral(red: 0.168627451, green: 0.1294117647, blue: 0.5764705882, alpha: 1)
}
