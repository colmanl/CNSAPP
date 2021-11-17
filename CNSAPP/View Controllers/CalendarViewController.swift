//
//  CalendarViewController.swift
//  CNSAPP
//
//  Created by Meredith Spiers on 10/19/21.
//

import FSCalendar
import UIKit
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

class CalendarViewController: UIViewController, UITextViewDelegate, ObservableObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var outputTextView: UITextView!

    @IBOutlet weak var inputEventTitle: UITextField!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var selectDateLabel: UILabel!
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var didLoadData: Bool = false
     
    /* New stuff starts */
    @IBOutlet weak var addNewEventButton: UIButton!
    
    @IBOutlet weak var deleteEventButton: UIButton!
    
    @IBAction func addNewEvent(_ sender: Any) {
        print("New event tapped")
    }
    /* New stuff ends */
    private var db = Firestore.firestore()
    
    @Published var eventList = [CalenderEvent]()
    
    var userEmailCalendar = LoginViewController.SetUserEmail.userEmail
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if didLoadData == false {
            getData()
            didLoadData = true
        }
        
        addDbDatesToDatesArray()
        reducedPrivileges()
        calendar.dataSource = self
        calendar.delegate = self
        outputTextView.delegate = self
        inputTextView.delegate = self;
        inputTextView.text = "Enter event description (optional)"
        inputTextView.textColor = UIColor.lightGray
    }
    
    var datesArray = ["11-08-2021"]
    
    func addDbDatesToDatesArray() {
        datesArray.removeAll()
        for event in eventList {
            datesArray.append(event.eventDate)
        }
    }
  
    func getData() {
        db.collection("calendarEvents").getDocuments{ [self] snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        self.eventList = snapshot.documents.map { d in
                            
                            return CalenderEvent ( id: d.documentID,
                                                  eventTitle: d["eventTitle"] as? String ?? "",
                                                  eventDescription: d["eventDescription"] as? String ?? "",
                                                  eventDate: d["eventDate"] as? String ?? "")
                        }
                        calendar.reloadData()
                        self.viewDidLoad()
                        self.viewWillAppear(true)
                        
                    }
                }
            }
            else {
                print("No documents")
                return
            }
        }
    }
    /* comment out for now
    func deleteDate(eventToDelete: CalenderEvent){
        db.collection("calendarEvents").document(eventToDelete.id).delete { error in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.eventList.removeAll { event in
                        return event.id == eventToDelete.id
                    }
                }
            }
            else {
                self.showErrorMessage("ERROR: Unable to delete event")
            }
        }
    }
     */
    
    @IBAction func addEventBtnTapped(_ sender: Any) {
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
            
            // ADD: only display this alert when eventTitle is found within the db
            showSimpleAlert()
     
            // EXPLANATION: adding new event to the event array
            addDbDatesToDatesArray()
    
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
        
        var outputEvents = ""
        var eventsExist = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. d"
        let dateStringOutput = formatter.string(from: date)
        
        addDbDatesToDatesArray()
        
        // EXPLANATION: dateQuery attempt
        formatter.dateFormat = "MM-dd-yyyy"
        let dateStringFromDb = formatter.string(from: date)
        
        for event in eventList {
            if event.eventDate == dateStringFromDb {
                outputEvents.append("\n\t\u{2022}\(event.eventTitle)")
                outputEvents.append("\n\t\t\(event.eventDescription)")
                eventsExist = true
            }
        }
        if eventsExist {
            outputTextView.text = "\(dateStringOutput) Events:\(outputEvents)"
        }
        else {
            outputTextView.text = "\(dateStringOutput) Events:\n\tThere are no events on this day."
        }
    }

    // FSCalendarDataSource
     func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
         let formatter = DateFormatter()
         formatter.dateFormat = "MM-dd-yyyy"
         let dateString = formatter.string(from: date)
         // ADD bool var = query for the calendarEvents db's eventDate contains dateString
         // if var == true
           if self.datesArray.contains(dateString) {
             return 1
           }
         
         else {
             return 0
         }
     }

     // FSCalendarDelegateAppearance
     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
         let formatter = DateFormatter()
         formatter.dateFormat = "MM-dd-yyyy"
         let dateString = formatter.string(from: date)
         // ADD bool var = query for the calendarEvents db's eventDate contains dateString
         // if var == true
         if datesArray.contains(dateString) {
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
    
    func reducedPrivileges(){
        if ( userEmailCalendar != "Email_test@test.com" ) {
            addNewEventButton.isHidden = true
            deleteEventButton.isHidden = true
        }
    }
}
