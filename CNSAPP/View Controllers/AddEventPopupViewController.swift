//
//  AddEventViewController.swift
//  CNSAPP
//
//  Created by Meredith Spiers on 11/17/21.
//

import FSCalendar
import UIKit
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

class AddEventPopupViewController: CalendarViewController {
    
    @IBOutlet weak var inputEventTitle: UITextField!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var selectDateLabel: UILabel!
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    private var db = Firestore.firestore()
    
    override func viewDidLoad() {
       // super.viewDidLoad()
        inputTextView.delegate = self;
        inputTextView.text = "Enter event description (optional)"
        inputTextView.textColor = UIColor.lightGray
        setUpElementsTwo()
        print("starting eventList:", eventList)
        print("starting datesArray:", datesArray)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        let eventTitle = inputEventTitle.text!
        let eventDescription = inputTextView.text!
        let eventDate = inputDate.date
        didLoadData = false
        
        // EXPLANATION: turning date input into a string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateString = formatter.string(from: eventDate)

        if eventTitle == "" {
            showErrorMessage("Error: Please enter an event title")
        }
        else {
            db.collection("calendarEvents").addDocument(data: ["eventTitle":eventTitle, "eventDescription":eventDescription, "eventDate":dateString]) { error in
                
                if error == nil
                {
                    self.addDbDatesToDatesArray()
                    print("middle eventList:", self.eventList)
                    print("middle datesArray:", self.datesArray)
                }
                else {
                    self.showErrorMessage("Error: Unable to add event")
                }
            }
            
            inputEventTitle.text = nil
            inputTextView.text = nil
            showErrorMessage("")
            
            addDbDatesToDatesArray()
            print("ending eventList:", eventList)
            print("ending datesArray:", datesArray)
            
            showSimpleAlert()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "(Optional) Enter event description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Success!", message: "Your event was successfully added", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showErrorMessage(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setUpElementsTwo(){
        LoginStyling.styleFilledButton(submitButton)
    }
}
