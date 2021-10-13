//
//  ViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 10/5/21.
//

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

