//
//  LoginViewController.swift
//  CNSAPP
//
//  Created by Zech Watkins on 10/6/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
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
        LoginStyling.styleTextField(passwordTextField)
        LoginStyling.styleHollowButton(loginButton)
        passwordTextField.isSecureTextEntry = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginTapped(_ sender: Any) {
        
        //Validate Text Fields
        func passwordValidation(_ password : String) -> Bool{
            //Password must be min 8 chars long, have 1 uppercase letter, 1 lowercase letter, 1 digit, and 1 special character -Zech
            let matchPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$")
            return matchPassword.evaluate(with: password)
        }
        func emailValidation(_ email : String) -> Bool{
            //emals with one or more characters following an "@"; then one or more chars follwed by a dot; then followed by one or more chars
            let goodEmail = NSPredicate(format: "SELF MATCHES %@", #"^\S+@\S+\.\S+$"#)
            return goodEmail.evaluate(with: email)
        }
        func validateFields() -> String? {
            
        //check that fields are filled - zech
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                return "Please Fill in All Fields."
            }
            
            //Validate the password
            let validPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if passwordValidation(validPassword) == false{
                //Error for non secure password- zech
                return "Your password must be: \n8 characters long \nhave 1 Uppercase Letter \n1 Lower case Letter \n1 special character"
            }
            
            //Validate the email.
            let validEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if emailValidation(validEmail) == false{
                //Error for invlaid email
                return "You have entered a non-standard email. \nExamples: dsu@npo.com or dsu.npo-work@domain.com"
            }
            
        
            return nil
        }
        
        //Clean Fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Signing in User
        Auth.auth().signIn(withEmail: email, password: password) { (result , error) in
            //error signing in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as?
                HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
