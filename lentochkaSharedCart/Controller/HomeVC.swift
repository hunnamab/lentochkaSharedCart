//
//  HomeVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 27.10.2020.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var catalogButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func catalogBtnWasPressed(_ sender: Any) {
        setSelectedButtonColor(btn: catalogButton)
        setUnselectedButtonColor(btn1: friendsButton, btn2: cartButton, btn3: profileButton)
    }
    
    @IBAction func friendsBtnWasPressed(_ sender: Any) {
        setSelectedButtonColor(btn: friendsButton)
        setUnselectedButtonColor(btn1: catalogButton, btn2: cartButton, btn3: profileButton)
    }
    
    @IBAction func cartBtnWasPressed(_ sender: Any) {
        setSelectedButtonColor(btn: cartButton)
        setUnselectedButtonColor(btn1: friendsButton, btn2: catalogButton, btn3: profileButton)
    }
    
    @IBAction func profileBtnWasPressed(_ sender: Any) {
        setSelectedButtonColor(btn: profileButton)
        setUnselectedButtonColor(btn1: cartButton, btn2: friendsButton, btn3: catalogButton)
    }

}
