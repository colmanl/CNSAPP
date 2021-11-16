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
    var fetchingMore = false
    var counter = 0
    var subcounter = 0
    var subcounter1 = 0
    var subsubcounter = 0
    var numOfPics = 0
   
    
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
            self?.firstLoad()
            
        }
        
//        while counter < 3 && counter <= numOfPics{
//            setBaseViews()
//            counter = counter + 1
//        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PhotoPopupViewController{
            let vc = segue.destination as? PhotoPopupViewController
            vc?.numOfPics = numOfPics
            vc?.vc = self
            
        }
    }
    
    func addNum(){
        numOfPics = numOfPics + 1
        print("*****NEW nop: \(numOfPics)")
        
    }
    
    
    
   
    @IBOutlet weak var SkrollView: UIScrollView!
    
    
    @IBOutlet weak var BestStack: UIStackView!
    
    
    @IBAction func addPic(_ sender: Any) {
        
        let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                present(vc, animated: true)
        
        
    }
    
    
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
                   print("hello")
                   beginBatchFetch()
                   //counter = counter + 1
                }
            }
           //print("hello")
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
        print("subcounter: \(subcounter1)")
        print("docpath is: \(docPath)")
        
        let docRef = database.document(docPath)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["imgString"] as? String else {
                return
            }
            self.imgPath = text
            print("text is: \(text)")
            print("img path is: \(self.imgPath)")
            print("subcounter in doc ref is: \(self.subcounter)")
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
            print("subcounter: \(subsubcounter)")
            print("docpath is: \(docPath)")
            
            let docRef = database.document(docPath)
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["titleTxt"] as? String else {
                    return
                }
                
                //weeeeeeee
                self.title1.text = text
                
            }
            
            docRef.getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else{
                    return
                }

                guard let text = data["capTxt"] as? String else {
                    return
                }
                
                //weeeeeeee
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
            print("subcounter: \(subsubcounter)")
            print("docpath is: \(docPath)")
            
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
            print("imageview set :")
            print(self.subsubcounter)
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
        print("subcounter: \(subsubcounter)")
        print("docpath is: \(docPath)")
        
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
        print("imageview set :")
        print(self.subsubcounter)
      }
        
    }
    
    
    func setBaseViewsAutomatically(subKount: Int) -> Int{
        
        let docPath = "imageReference/" + String(subKount)
        print("auto subcounter: \(subKount)")
        print(" auto docpath is: \(docPath)")
        
        let docRef = database.document(docPath)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["imgString"] as? String else {
                return
            }
            self.imgPath = text
            print("autotext is: \(text)")
            print("auto img path is: \(self.imgPath)")
            print("subcounter in doc ref in auto is: \(subKount)")
            self.setAutoImage(imagPath: text, subKount: subKount)
            //subKount = subKount + 1
        }
        
        return subKount + 1
        
    }
    
    func setAutoImage(imagPath: String, subKount: Int){
        
        
        let newView = UIView()
        NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 550).isActive = true
        //newView.backgroundColor =
        
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
        let newLabel = UILabel(frame: CGRect(x: 8, y: 449, width: 325, height: 37))
        newLabel.font = UIFont.systemFont(ofSize: 28)
        newLabel.text = "Testing"
        
        let newTextView = UITextView(frame: CGRect(x: 8, y: 482, width: 378, height: 78))
        newLabel.font = UIFont.systemFont(ofSize: 19)
        newTextView.text = "testing testing 123"
        
        let docPath = "imageReference/" + String(subKount)
        print("text subcounter: \(subKount)")
        print("text docpath is: \(docPath)")
        
        let docRef = database.document(docPath)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["titleTxt"] as? String else {
                return
            }
            
            //
            print("label text is: \(text)")
            newLabel.text = text
            
        }
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let text = data["capTxt"] as? String else {
                return
            }
            
            //
            newTextView.text = text
            
        }
        
        
        
        newView.addSubview(newImageView)
        newView.addSubview(newLabel)
        newView.addSubview(newTextView)
        BestStack.addArrangedSubview(newView)
        
        
        self.fetchingMore = false
        BestStack.reloadInputViews()
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                  //starterImg.image = image
                
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


    
    
    
    }
    

