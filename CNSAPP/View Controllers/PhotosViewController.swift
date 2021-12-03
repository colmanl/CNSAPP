//
//  ViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 10/5/21.
//
import UIKit
import Firebase
import FirebaseFirestore

class PhotosViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    let database = Firestore.firestore()
    var imgPath = ""
    var delArray = [String]()
    var delArray2 = [Photo]()
    var fetchingMore = false
    var dataFetch = false
    var counter = 0
    var subcounter = 0
    var subcounter1 = 0
    var subsubcounter = 0
    var numOfPics = 0
    var userEmailPhotos = LoginViewController.SetUserEmail.userEmail
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SkrollView.delegate=self
        
        let docRef = database.document("imageReference/imgCount")
        docRef.getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            guard let text = data["count"] as? Int else {
                return
            }
            self?.numOfPics = text
            print(text)
            
            self?.getThoseImages()
            
            
//            let timeInterval = String(NSDate().timeIntervalSince1970)
//            print(timeInterval)
    //bbbbbbbbbbbb
            self?.firstLoad()
            
        }
        
        deleteButton1.addTarget(self, action: #selector(deletePhoto), for:.touchUpInside)
        deleteButton2.addTarget(self, action: #selector(deletePhoto), for:.touchUpInside)
        deleteButton3.addTarget(self, action: #selector(deletePhoto), for:.touchUpInside)
        
        
        
        
        reducedPrivileges()
        setUpElementsTwo()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PhotoPopupViewController{
            let vc = segue.destination as? PhotoPopupViewController
            vc?.numOfPics = numOfPics
            vc?.vc = self
            
        }
    }
    
    func addNum(ref: Double){
        numOfPics = numOfPics + 1
        print("*****NEW nop: \(numOfPics)")
        
        
        let dataRef = database.collection("imageReference")
        dataRef.whereField("postID", isEqualTo: ref).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {

                    let fark = document.data()

                    var newPhoto = Photo(name: document.documentID)

                    newPhoto.capTxt = fark["capTxt"] as? String
                    newPhoto.titleTxt = fark["titleTxt"] as? String
                    newPhoto.postID = fark["postID"] as? Double
                    newPhoto.imgString = fark["imgString"] as? String
                    let fork = fark["imgString"] as? String
                    self.delArray.append(fork ?? "oops")
                    self.delArray2.append(newPhoto)

                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }
    
    
    
    @IBOutlet var mainThing: UIView!
    
    @IBOutlet weak var SkrollView: UIScrollView!
    
    
    @IBOutlet weak var BestStack: UIStackView!
    

    @IBAction func addPic(_ sender: Any) {
        
        let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                present(vc, animated: true)
        
        
    }
    

    @IBOutlet weak var addPicButton: UIButton!
    
    @IBOutlet weak var deleteButton1: UIButton!
    
    @IBOutlet weak var deleteButton2: UIButton!
    
    @IBOutlet weak var deleteButton3: UIButton!
    
    
    @IBOutlet weak var starterImg: UIImageView!
    

    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var caption1: UITextView!
    
    @IBOutlet weak var starterImg2: UIImageView!
    
    
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var caption2: UITextView!
    
    @IBOutlet weak var starterImg3: UIImageView!
    
    
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var caption3: UITextView!
    
    
    
    func scrollViewDidScroll(_ SkrollView: UIScrollView) {
        let offsetY = SkrollView.contentOffset.y
        let contentHeight = SkrollView.contentSize.height
        if offsetY > contentHeight - SkrollView.frame.height{
            

            
                if !fetchingMore{
         
                if numOfPics > counter{
                   
                   beginBatchFetch()
                
                }
                
                
                
            }
           
        }
    
    }
    
    
    func getThoseImages(){
        
        let dataRef = database.collection("imageReference")
        dataRef.order(by: "postID").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    
                    
                    let fark = document.data()
                    
                    var newPhoto = Photo(name: document.documentID)
                    
                    newPhoto.capTxt = fark["capTxt"] as? String
                    newPhoto.titleTxt = fark["titleTxt"] as? String
                    newPhoto.postID = fark["postID"] as? Double
                    newPhoto.imgString = fark["imgString"] as? String
                    let fork = fark["imgString"] as? String
                    self.delArray.append(fork ?? "oops")
                    self.delArray2.append(newPhoto)
                    
                   // print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
       
        
    }
    
    
    func beginBatchFetch(){
        fetchingMore = true
        print("fetching")
        
        if counter < 3 {
        setBaseViews()
        }else{
            
            counter = setBaseViewsAutomatically(subKount: counter)
            
            

        }

    
    }
    
    func setBaseViews(){
        
       
        let docPath = "imageReference/" + String(subcounter1)
        //print("subcounter: \(subcounter1)")
        //print("docpath is: \(docPath)")
        
        let docRef = database.document(docPath)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["imgString"] as? String else {
                return
            }
            self.imgPath = text
            //print("text is: \(text)")
            //print("img path is: \(self.imgPath)")
           // print("subcounter in doc ref is: \(self.subcounter)")
            self.setImageView()
            self.subcounter = self.subcounter + 1
        }
        
        subcounter1 = subcounter1 + 1
        
        
       //
    }
    
    func firstLoad(){
        
        while counter < 3 && counter <= numOfPics{
           
                setBaseViews()
            
            
            print("base view set = \(counter)")
            counter = counter + 1
            
        }
    }
    
    func setImageView(){
        
        if subsubcounter == 0 {
     let storageRef = Storage.storage().reference(withPath: imgPath)
     storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self](data, error) in
         if let error = error{
            print("Got an error fetching data: \(error.localizedDescription)")
            return
        }
         if let data = data {
                self?.starterImg.image = UIImage(data: data)
                self?.starterImg.reloadInputViews()
            

        }
         
      }
            let docPath = "imageReference/" + String(subsubcounter)
       
            
            let docRef = database.document(docPath)
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["titleTxt"] as? String else {
                    return
                }
                
                
                self.title1.text = text
                
            }
            
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["capTxt"] as? String else {
                    return
                }
                
              
                self.caption1.text = text
                
            }
            
                
            self.subsubcounter = self.subsubcounter + 1
            print("imageview set :")
            print(self.subsubcounter)
        }else if subsubcounter == 1{
        let storageRef = Storage.storage().reference(withPath: imgPath)
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self](data, error) in
            if let error = error{
                print("Got an error fetching data: \(error.localizedDescription)")
                return
            }
            if let data = data {
                    self?.starterImg2.image = UIImage(data: data)
                    self?.starterImg2.reloadInputViews()
                self?.subsubcounter = self!.subsubcounter + 1

            }
          }
            
            //
            let docPath = "imageReference/" + String(subsubcounter)
            //print("subcounter: \(subsubcounter)")
            //print("docpath is: \(docPath)")
            
            let docRef = database.document(docPath)
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["titleTxt"] as? String else {
                    return
                }
                
                //
                self.title2.text = text
                
            }
            
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["capTxt"] as? String else {
                    return
                }
                
                //
                self.caption2.text = text
                
            }
            
            
            
            self.subsubcounter = self.subsubcounter + 1
            //print("imageview set :")
            //print(self.subsubcounter)
    }else{
        let storageRef = Storage.storage().reference(withPath: imgPath)
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self](data, error) in
            if let error = error{
                print("Got an error fetching data: \(error.localizedDescription)")
                return
            }
            if let data = data {
                    self?.starterImg3.image = UIImage(data: data)
                    self?.starterImg3.reloadInputViews()
                    self?.subsubcounter = self!.subsubcounter + 1


            }
          }
        
        //
        let docPath = "imageReference/" + String(subsubcounter)
       // print("subcounter: \(subsubcounter)")
       // print("docpath is: \(docPath)")
        
        let docRef = database.document(docPath)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["titleTxt"] as? String else {
                return
            }
            
            //
            self.title3.text = text
            
        }
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["capTxt"] as? String else {
                return
            }
            
            //
            self.caption3.text = text
            
        }
        
        
        
        self.subsubcounter = self.subsubcounter + 1
        //print("imageview set :")
        //print(self.subsubcounter)
      }
        
    }
    
    
    func setBaseViewsAutomatically(subKount: Int) -> Int{
        
        var coolPath = "erm"
        
        if counter != delArray2.count{
            coolPath = delArray2[subKount].imgString ?? "nil"
        
        }
    
    
        
        self.setAutoImage(imagPath: coolPath, subKount: subKount)
        
        
        return subKount + 1
        
    }
    
    func setAutoImage(imagPath: String, subKount: Int){
        
        
        let newView = UIView()
        NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 570).isActive = true
        newView.backgroundColor = .secondarySystemBackground
        
        let newButton = UIButton(frame: CGRect(x: 363, y: 44, width: 43, height: 42))
        newButton.backgroundColor = .systemRed
        //newButton.setTitleColor(.white, for: .normal)
        newButton.tintColor = .white
        newButton.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        //newButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
        //newButton.currentTitleColor = .systemBackground
        //newButton.setTitle("Delete", for: .normal)
        //newButton.setTitleColor(.blue, for: .normal)
        newButton.tag = subKount
        newButton.addTarget(self, action: #selector(deletePhoto), for:.touchUpInside)
        
        let newImageView = UIImageView(frame: CGRect(x: 0, y: 37, width: 414, height: 414))
        newImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        let storageRef = Storage.storage().reference(withPath: imagPath)
        storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error{
                print("Got an error fetching data: \(error.localizedDescription)")
                return
            }
            if let data = data {
                newImageView.image = UIImage(data: data)
            }
        }
        
        //add
        let newLabel = UILabel(frame: CGRect(x: 13, y: 449, width: 393, height: 37))
        newLabel.textColor = .label
        // set label color to label. set view and wg
        
        var string = self.delArray2[subKount].capTxt ?? "No Title"
        var attributedtext = NSMutableAttributedString(string: string)
        attributedtext.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 28, weight: .bold),
            range: NSRange(location: 0, length: string.count)
        )
        newLabel.attributedText = attributedtext
        
        let newTextView = UITextView(frame: CGRect(x: 8, y: 482, width: 378, height: 78))
        newTextView.backgroundColor = .secondarySystemBackground
       
         string = self.delArray2[subKount].titleTxt ?? "Nothing to see here"
         attributedtext = NSMutableAttributedString(string: string)
        attributedtext.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 19, weight: .regular),
            range: NSRange(location: 0, length: string.count)
        )
        attributedtext.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: string.count))
      
        newTextView.attributedText = attributedtext
        
        
        newView.addSubview(newImageView)
        newView.addSubview(newLabel)
        newView.addSubview(newTextView)
        newView.addSubview(newButton)
        BestStack.addArrangedSubview(newView)
        
        
        self.fetchingMore = false
        BestStack.reloadInputViews()
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                 
                
                let randomID = UUID.init().uuidString
                let uploadRef = Storage.storage().reference(withPath: "images/\(randomID).png")
                guard let imageData = image.pngData() else { return }
                let uploadMetadata = StorageMetadata.init()
                uploadMetadata.contentType = "image/png"
                
                uploadRef.putData(imageData, metadata: uploadMetadata) { ( downloadMetadata, error ) in
                    if let error = error {
                        print("An error happend! \(error.localizedDescription)")
                        return
                    }
                    print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
                }
                
                let numRef = String(numOfPics)
                
                database.collection("imageReference").document(numRef).setData([
                    "imgString": "images/\(randomID).png"
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
                numOfPics = numOfPics + 1
                database.collection("imageReference").document("imgCount").setData([ "count": numOfPics ], merge: true)
                              
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    @objc func deletePhoto(sender:UIButton){
        
        let dog = sender.tag
        var numberPix = 0
        print(dog)
        //Replace view in UIStackview
            let newView = UIView()
            NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 650).isActive = true
            newView.backgroundColor = .secondarySystemBackground
        
       
        
            let newImageView = UIImageView(frame: CGRect(x: 0, y: 37, width: 414, height: 414))
            newImageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            newImageView.image = UIImage(named: "redx")
            newView.addSubview(newImageView)
            
        
            BestStack.replaceView(atIndex: dog, withView: newView)
            BestStack.reloadInputViews()
        
        //delete database reference
        
             //   let strink = String(dog)
        let imageSubstring = delArray2[dog].imgString ?? "ohno"
        let start = imageSubstring.index(imageSubstring.startIndex, offsetBy: 7)
        let range = start...
        let daSting = String(imageSubstring[range])

        let schmeckle = delArray2[dog].postID
        
        database.collection("imageReference").whereField("postID", isEqualTo: schmeckle ?? -1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        document.reference.delete()
                    }
                }
        }
        
        
        
        
        


                    let storageRef = Storage.storage().reference(withPath: "images")
                    let desertRef = storageRef.child(daSting)

                    // Delete the file
                    desertRef.delete { error in
                      if let error = error {
                        // Uh-oh, an error occurred!
                          print("error: \(error)")
                      } else {
                        // File deleted successfully
                          print("suck sess")
                      }
                    }





        //Change Image count
            let docRef = database.document("imageReference/imgCount")
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["count"] as? Int else {
                    return
                }
                numberPix = text
                numberPix = numberPix - 1
                self.database.collection("imageReference").document("imgCount").setData([ "count": numberPix ], merge: true)


            }



    }
    
    
    

    func reducedPrivileges(){
        if ( userEmailPhotos != "cnskids@gmail.com" ) {
            addPicButton.isHidden = true
        }
    }

    func setUpElementsTwo(){
        //Hide Error Label
      //  errorLabel.alpha = 0
        
      //  LoginStyling.styleTextField(emailTextField)
      //  LoginStyling.styleTextField(passwordTextField)
        //LoginStyling.styleHollowButtonTwo(addPicButton)
       // LoginStyling.styleHollowButtonThree(deleteEventButton)

       LoginStyling.styleFilledButton(addPicButton)
       // passwordTextField.isSecureTextEntry = true
    }
}


public struct Photo: Codable {

    let name: String
    var imgString: String?
    var postID: Double?
    var titleTxt: String?
    var capTxt: String?

    enum CodingKeys: String, CodingKey {
        case name
        case imgString = "nope"
        case postID
        case titleTxt = "No Title"
        case capTxt = "No caption entered."
    }

}

@available(iOS 9.0, *)
extension UIStackView {
    func replaceView(atIndex index: Int, withView view: UIView) {
        let viewToRemove = arrangedSubviews[index]
        removeArrangedSubview(viewToRemove)
        insertArrangedSubview(view, at: index)
    }
}

