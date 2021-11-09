//
//  ForgotPasswordViewController.swift
//  CNSAPP
//
//  Created by Zech Watkins on 11/7/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var loginBackButton: UIButton!
    
    @IBOutlet weak var sendLinkButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        //Hide Error Label
        errorLabel.alpha = 0
        
        LoginStyling.styleTextField(emailTextField)
        LoginStyling.styleHollowButton(sendLinkButton)
    }

 // Everything below controls what happens after a button is tapped
    
    //Sends user back to login view controller
    @IBAction func loginBackTapped(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as?
        LoginViewController
        
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func sendLinkTapped(_ sender: Any) {
        //The following two functions deal with vaildating and errror checking the email text field
        
        func emailValidation(_ email : String) -> Bool{
            //emals with one or more characters following an "@"; then one or more chars follwed by a dot; then followed by one or more chars
            let goodEmail = NSPredicate(format: "SELF MATCHES %@", #"^\S+@\S+\.\S+$"#)
            return goodEmail.evaluate(with: email)
        }
        func validateFields() -> String? {
            
        //check that fields are filled - zech
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
                return "Please Fill in All Fields."
            }
            //Validate the email.
            let validEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if emailValidation(validEmail) == false{
                //Error for invlaid email
                return "You have entered a non-standard email. \nExamples: dsu@npo.com or dsu.npo-work@domain.com"
            }
            return nil
        }
        
        // Clean Fields
         let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                self.errorLabel.text = "Email has been sent"
                self.errorLabel.alpha = 1
            }
        }
        
    }
}
