//
//  ViewController.swift
//  CNSAPP
//
//  Created by Zech Watkins on 10/14/21.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        LoginStyling.styleFilledButton(signUpButton)
        LoginStyling.styleFilledButton(loginButton)
    }


    
}
