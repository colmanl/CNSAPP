//
//  EntryViewController.swift
//  CNSAPP
//
//  Created by Zech Watkins on 10/14/21.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
                setUpElements()
        
            func setUpElements(){
                LoginStyling.styleFilledButton(signUpButton)
                LoginStyling.styleHollowButton(loginButton)
            }
    }


            
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
