//
//  CalendarViewController.swift
//  CNSAPP
//
//  Created by Meredith Spiers on 10/19/21.
//

import FSCalendar
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation

class CalendarViewController: UIViewController, UITextViewDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var outputTextView: UITextView!
    
    @IBOutlet weak var inputEventTitle: UITextField!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        inputTextView.delegate = self;
        inputTextView.text = "Enter event description (optional)"
        inputTextView.textColor = UIColor.lightGray
    }
    
    var testDates = ["2021-08-11", "2021-16-11"]
    
    @IBAction func addEventBtnTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let eventTitle = inputEventTitle.text!
        let eventDescription = inputTextView.text!
        let eventDate = inputDate.date
        
        // EXPLANATION: turning date input into a string
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-MM"
        let dateString = formatter.string(from: eventDate)

        if eventTitle == "" {
            showErrorMessage("Please enter an event title")
        }
        else {
            db.collection("calendarEvents").addDocument(data: ["eventTitle":eventTitle, "eventDescription":eventDescription, "eventDate":dateString])
            
            inputEventTitle.text = nil
            inputTextView.text = nil
            
            // ADD: only display this alert when eventTitle is found within the db
            showSimpleAlert()
     
            // EXPLANATION: adding new event to the event array
            testDates.append(dateString)
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
    
    // FSCalendarDelegate for when user selects a date on the calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. d"
        let dateString = formatter.string(from: date)
        outputTextView.text = "\(dateString) Events:"
        // ADD bool var = query for the calendarEvents db's eventDate contains dateString
        // if var == true
        // outputTextView.text = "\(dateString) Events:\n", display the eventTitle and eventDescription associated with this day
        // else
        // outputTextView.text = "\(dateString) Events:\nThere are no events on this day."
    }

    // FSCalendarDataSource
     func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-dd-MM"
         let dateString = formatter.string(from: date)
         // ADD bool var = query for the calendarEvents db's eventDate contains dateString
         // if var == true
           if self.testDates.contains(dateString) {
             return 1
           }
         
         else {
             return 0
         }
     }

     // FSCalendarDelegateAppearance
     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-dd-MM"
         let dateString = formatter.string(from: date)
         // ADD bool var = query for the calendarEvents db's eventDate contains dateString
         // if var == true
         if testDates.contains(dateString) {
             return [UIColor.blue]
         }
         else {
             return [UIColor.white]
         }
     }
 
    // EXPLANATION: Alert when an new event is successfully added
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
}

