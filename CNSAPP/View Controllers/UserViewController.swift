//
//  UsersPageViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 11/4/21.
//
import UIKit
import Foundation
import SwiftUI
import Firebase

class UserViewController: UIViewController {
 
    @IBOutlet weak var searchParents: UIButton!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
    /*    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        view.addSubview(button)
        button.center=view.center
        button.setTitle("Search For Parents/Staff", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        */
        setUpElementsTwo()
        emailText.isUserInteractionEnabled = false
        phoneText.isUserInteractionEnabled = false
        
    }
    
  @IBAction @objc func didTapButton(){
        //combinging swift ui and storyboard
        let vc = UIHostingController(rootView: SearchViewController())
        present(vc, animated: true)
    }
    
    @IBAction func logout(){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            let entryViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.entryViewController) as? EntryViewController
            
            self.view.window?.rootViewController = entryViewController
            self.view.window?.makeKeyAndVisible()
        }catch let signOutError as NSError {
            print("Error Signing Out: %@", signOutError)
        }
    }
    func setUpElementsTwo(){
        //Hide Error Label
      //  errorLabel.alpha = 0
        
      //  LoginStyling.styleTextField(emailTextField)
      //  LoginStyling.styleTextField(passwordTextField)
        //LoginStyling.styleHollowButtonTwo(addPicButton)
       // LoginStyling.styleHollowButtonThree(deleteEventButton)

       LoginStyling.styleFilledButton(logoutButton)
        LoginStyling.styleFilledButton(searchParents)
       // passwordTextField.isSecureTextEntry = true
    }
    
}
    
   // @ObservedObject var data = getUserData()
 /*
    var body: some View {
        NavigationView{
            
            List{
                
                Section{
            
                    Text("1320 Fairview Road Columbia, Missouri 65203")
                }   header:{ Text("Address")}
                Section{
                    Text("573-445-4111")
        
                }header:{ Text("Phone Number")}
                Section{
                    Text("cnskids@gmail.com")
                }header:{ Text("Email")
            }.listStyle(.insetGrouped)
                .navigationTitle("Contact Information")
        
    }
            
    
}
    } }
/*
    struct UserPageView_Previews: PreviewProvider {
       static var previews: some View {
    UserViewController()
       }}

    struct CustomSearchBar: View {
        @State var txt = ""
        @Binding var data : [dataType]
        
        
        var body : some View{
            
            VStack(spacing: 0){
                HStack{
                    TextField("Search", text: self.$txt)
                    
                    if self.txt != ""{
                        Button(action: {
                            self.txt = ""
                        }){
                            Text("Cancel")
                        }
                        .foregroundColor(.white)
                    }
                }.padding()
                
                if self.txt != ""{
                    
                    if  self.data.filter({$0.firstname.lowercased().contains(self.txt.lowercased())}).count == 0{
                        
                        Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                    }
                    else{
                        
                    List(self.data.filter{$0.firstname.lowercased().contains(self.txt.lowercased())}){i in
                                
                        NavigationLink(destination: Detail(data: i)) {
                            
                            Text(i.firstname)
                        }
                                
                            
                        }.frame(height: UIScreen.main.bounds.height / 5)
                    }

                }
                
                
            }.background(Color.white)
            .padding()
        }
    }



    class getUserData : ObservableObject{
        @Published var datas = [dataType]()
        
        init(){
            let db = Firestore.firestore()
            db.collection("users").getDocuments { (snap, err)in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documents{
                    let id = i.documentID
                    let firstname = i.get("firstname") as! String
                    let lastname = i.get("lastname") as! String
                    let email = i.get("email") as! String
                        
                    self.datas.append(dataType(id: id, firstname: firstname, lastname: lastname, email: email))
                }
            }
        }
    }
     */  /*  struct dataType : Identifiable {
        var id : String
        var firstname : String
        var lastname : String
        var email : String
    }

    struct Detail: View {
        
        var data: dataType
        var body : some View{
            Text(data.firstname)
            Text(data.lastname)
            Text(data.email)
        }
    }
*/
    

  */
