//
//  SignUpViewController.swift
//  CNSAPP
//
//  Created by Zech Watkins on 10/6/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        //Hide Error Label
        errorLabel.alpha = 0
        
        LoginStyling.styleTextField(firstNameTextField)
        LoginStyling.styleTextField(lastNameTextField)
        LoginStyling.styleTextField(emailTextField)
        LoginStyling.styleTextField(phoneNumberTextField)
        LoginStyling.styleTextField(passwordTextField)
        LoginStyling.styleFilledButton(signUpButton)
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
    //Check the fields and validate the fields to see if the data is correct. Correct returns nil, otherwise error message is sent
    
    //Password Regular expression  function
    func passwordValidation(_ password : String) -> Bool{
        //Password must be min 8 chars long, have 1 uppercase letter, 1 lowercase letter, 1 digit, and 1 special character -Zech
        let matchPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        return matchPassword.evaluate(with: password)
    }
    
    //Email Regualr expression function check
    func emailValidation(_ email : String) -> Bool{
        //emals with one or more characters following an "@"; then one or more chars follwed by a dot; then followed by one or more chars
        let goodEmail = NSPredicate(format: "SELF MATCHES %@", #"^\S+@\S+\.\S+$"#)
        return goodEmail.evaluate(with: email)
    }
    
    func phoneNumValidation(_ phoneNum : String) -> Bool{
        //Checks for standard number config ex. 1234567890; can include "()", "-", and spaces to group numbers
        let goodPhoneNum = NSPredicate(format: "SELF MATCHES %@", #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#)
        return goodPhoneNum.evaluate(with: phoneNum)
    }
    
    func validateFields() -> String? {
        
    //check that fields are filled - zech
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
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
        
        //Validate the Phone Number
        let validPhoneNum = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if phoneNumValidation(validPhoneNum) == false{
            //Error for improperly formatted phone number
            return  "You have entered the your phone number improperly. Try entering it like this (###)-###-####"
        }
        return nil
    }

    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Vaildate the Fields - Zech
        let error = validateFields()
        
        if error != nil {
            //Something went wrong show error message -Zech
            showError(error!)
            
        }
        else{
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Creating User- zech
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Check for Errors
                if err != nil {
                    //there was an error creating the user
                    self.showError("Error Creating user")
                }
                else{
                    //User was created succuesfully, store the rest of the data
                    
                    //this is the line of code that link the firestore database to our code.
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "email":email, "phoneNumber":phoneNumber, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            //show Error message
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    self.goToHomeScreen()
                }
            }
            
        }
       
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func goToHomeScreen(){
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
