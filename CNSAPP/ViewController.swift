//
//  ViewController.swift
//  CNSAPP
//
//  Created by Zech Watkins on 10/14/21.
//

<<<<<<< HEAD
import Foundation
=======
import FSCalendar
>>>>>>> main
import UIKit

class ViewController: UIViewController, FSCalendarDelegate{
    
    var calendar = FSCalendar()

    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        LoginStyling.styleFilledButton(signUpButton)
        LoginStyling.styleFilledButton(loginButton)
=======
        calendar.delegate = self
>>>>>>> main
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendar.frame = CGRect(x: 0,
                                y: 75,
                                width: view.frame.size.width,
                                height: view.frame.size.width)
        view.addSubview(calendar)
    }

<<<<<<< HEAD
    
=======
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. dd"
        let string = formatter.string(from: date)
        print("\(string) Announcements:")
    }
>>>>>>> main
}
