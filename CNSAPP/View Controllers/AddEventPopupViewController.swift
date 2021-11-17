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
    /*
    @IBOutlet weak var inputEventTitle: UITextField!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var selectDateLabel: UILabel!
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    */
    private var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self;
        inputTextView.text = "Enter event description (optional)"
        inputTextView.textColor = UIColor.lightGray
    }
    
    @IBAction override func addEventBtnTapped(_ sender: Any) {
        let eventTitle = inputEventTitle.text!
        let eventDescription = inputTextView.text!
        let eventDate = inputDate.date
        
        // EXPLANATION: turning date input into a string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateString = formatter.string(from: eventDate)

        if eventTitle == "" {
            showErrorMessage("ERROR: Please enter an event title")
        }
        else {
            db.collection("calendarEvents").addDocument(data: ["eventTitle":eventTitle, "eventDescription":eventDescription, "eventDate":dateString]) { error in
                
                if error == nil
                {
                    self.getData()
                    self.addDbDatesToDatesArray()
                }
                else {
                    self.showErrorMessage("ERROR: Unable to add event")
                }
            }
            
            inputEventTitle.text = nil
            inputTextView.text = nil
     
            // EXPLANATION: adding new event to the event array
            addDbDatesToDatesArray()
            print("datesArray contains: ", datesArray)
    
            // ADD: only display this alert when eventTitle is found within the db
            showSimpleAlert()
        }
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "(Optional) Enter event description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // EXPLANATION: Alert when an new event is successfully added
    override func showSimpleAlert() {
        let alert = UIAlertController(title: "Success!", message: "Your event was successfully added", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func showErrorMessage(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
