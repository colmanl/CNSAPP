//
//  ViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 10/5/21.
//
import UIKit
import Firebase
import FirebaseFirestore

class PhotoPopupViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate{
    
    let database = Firestore.firestore()
    var vc:PhotosViewController?
    var fetchingMore = false
    var numOfPics = 0
    @IBOutlet weak var inputPhotoTitle: UITextField!
    @IBOutlet weak var inputPhotoDescription: UITextView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoPopupViewController.imageTapped(gesture:)))

        coolImg.addGestureRecognizer(tapGesture)
        
        
        setUpElements()
        
           
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        }
    
    @objc func imageTapped(gesture: UITapGestureRecognizer){
        
        if (gesture.view as? UIImageView) != nil {
        
            let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.delegate = self
                    vc.allowsEditing = true
                    present(vc, animated: true)
        
        }
        
    }
    
    

    
    @IBOutlet weak var coolImg: UIImageView!
    
   
    @IBOutlet weak var titleSpot: UITextField!
    
    
    @IBOutlet weak var capSpot: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitPhoto(_ sender: Any) {
        
        
        vc?.toggleScroll()
        
     var numberPix = 100000
     let timeInterval = Double(NSDate().timeIntervalSince1970)
     print(timeInterval)
        
     let randomID = UUID.init().uuidString
     let uploadRef = Storage.storage().reference(withPath: "images/\(randomID).png")
        guard let imageData = coolImg.image?.pngData() else { return }
     let uploadMetadata = StorageMetadata.init()
     uploadMetadata.contentType = "image/png"
        
     uploadRef.putData(imageData, metadata: uploadMetadata) { ( downloadMetadata, error ) in
                            if let error = error {
                                print("An error happend! \(error.localizedDescription)")
                                return
                            }
                            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
         self.vc?.toggleScroll()
                        }
        
        let numRef = UUID.init().uuidString
        print("******vc =num of pics is: \(numOfPics) *****")
        
        database.collection("imageReference").document(numRef).setData([
                            "imgString": "images/\(randomID).png"
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
        
        //numOfPics = numOfPics + 1
        
        let docRef = database.document("imageReference/imgCount")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["count"] as? Int else {
                return
            }
            numberPix = text
            numberPix = numberPix + 1
            self.database.collection("imageReference").document("imgCount").setData([ "count": numberPix ], merge: true)


        }
        
        
        
       // database.collection("imageReference").document("imgCount").setData([ "count": numOfPics ], merge: true)
        database.collection("imageReference").document(numRef).setData([ "postID": timeInterval ], merge: true)
        
        let newTitle = titleSpot.text
        let newCap = capSpot.text
        
        database.collection("imageReference").document(numRef).setData([ "titleTxt": newTitle ?? "" ], merge: true)
        
        database.collection("imageReference").document(numRef).setData([ "capTxt": newCap ?? "" ], merge: true)
        
        
        vc?.addNum(ref: timeInterval)
        
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                  coolImg.image = image

            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }


    func setUpElements(){
        //Hide Error Label
       // errorLabel.alpha = 0
        
        //LoginStyling.styleTextField(emailTextField)
       // LoginStyling.styleTextField(passwordTextField)
      //  LoginStyling.styleHollowButton(loginButton)
        LoginStyling.styleFilledButton(submitButton)
       // passwordTextField.isSecureTextEntry = true
    }
    
    @objc func handleTap(){
        inputPhotoTitle.resignFirstResponder()
        inputPhotoDescription.resignFirstResponder()
    }
    
}
    

