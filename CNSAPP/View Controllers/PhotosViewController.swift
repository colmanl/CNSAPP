//
//  ViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 10/5/21.
//
import UIKit
import Firebase

class PhotosViewController: UIViewController, UIScrollViewDelegate{
    
    let database = Firestore.firestore()
    var fetchingMore = false
    var counter = 0
    var numOfPics = 8
    let images = ["images/bby.png","images/ABBA_Gold_cover.png","images/VroomVroomEP.png","images/dead-kennedys-plastic-surgery-disasters.png", "images/Exmilitary.png", "images/hounds.png", "images/kidzbop.png", "images/kingcrimson.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bumber.image = UIImage(named: "AppIcon2x")
        self.SkrollView.delegate=self
        
        //let docRef = database.document("imageReference/imgCount")
        
        while counter < 3{
            setBaseViews()
            counter = counter + 1
        }
        
        
        
    }
    
   
    @IBOutlet weak var SkrollView: UIScrollView!
    
    
    @IBOutlet weak var BestStack: UIStackView!
    
    
    @IBOutlet weak var starterImg: UIImageView!
    
    @IBOutlet weak var starterImg2: UIImageView!
    
    @IBOutlet weak var starterImg3: UIImageView!
    
    
    func scrollViewDidScroll(_ SkrollView: UIScrollView) {
        let offsetY = SkrollView.contentOffset.y
        let contentHeight = SkrollView.contentSize.height
        if offsetY > contentHeight - SkrollView.frame.height{
            if !fetchingMore{
                if numOfPics > counter{
                   print("hello")
                   beginBatchFetch()
                   counter = counter + 1
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
            
        let newView = UIView()
        NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300).isActive = true
        newView.backgroundColor = .systemOrange
        
        let newImageView = UIImageView(frame: CGRect(x: 50, y: 37, width: 315, height: 276))
        newImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        let storageRef = Storage.storage().reference(withPath: images[counter])
        storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error{
                print("Got an error fetching data: \(error.localizedDescription)")
                return
            }
            if let data = data {
            newImageView.image = UIImage(data: data)
            }
        }
        
        //newImageView.image = UIImage(named: "bby")
        
        newView.addSubview(newImageView)
        BestStack.addArrangedSubview(newView)
        }
        
        self.fetchingMore = false
        BestStack.reloadInputViews()
        
        
    }
    
    func setBaseViews(){
        
        if counter == 0 {
         let storageRef = Storage.storage().reference(withPath: images[counter])
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
        }else if counter == 1{
            let storageRef = Storage.storage().reference(withPath: images[counter])
            storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self](data, error) in
                if let error = error{
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                        self?.starterImg2.image = UIImage(data: data)
                        self?.starterImg2.reloadInputViews()

                }
              }
        }else{
            let storageRef = Storage.storage().reference(withPath: images[counter])
            storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self](data, error) in
                if let error = error{
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                        self?.starterImg3.image = UIImage(data: data)
                        self?.starterImg3.reloadInputViews()

                }
              }
        }
        
        
        
        
    }
    
    
}
