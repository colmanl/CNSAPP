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
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private var db = Firestore.firestore()
    
    @Published var eventList = [CalenderEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        addDbDatesToDatesArray()
        print("datesArray contains: ", datesArray)
        calendar.dataSource = self
        calendar.delegate = self
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
  
    // code below retrieved from CodeWithChris
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
                    }
                }
            }
            else {
                print("No documents")
                return
            }
        }
        print("Hit getData")
    }
    
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
            print("datesArray contains: ", datesArray)
    
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
        print("datesArray contains: ", datesArray)
        
        // EXPLANATION: dateQuery attempt
        formatter.dateFormat = "MM-dd-yyyy"
        let dateStringFromDb = formatter.string(from: date)
        
        for event in eventList {
            if event.eventDate == dateStringFromDb {
                outputEvents.append("\t\(event.eventTitle)\n")
                outputEvents.append("\t\(event.eventDescription)")
                eventsExist = true
            }
        }
        if eventsExist {
            outputTextView.text = "\(dateStringOutput) Events:\n\(outputEvents)"
        }
        else {
            outputTextView.text = "\(dateStringOutput) Events:\n\tThere are no events on this day."
        }
    }

    // FSCalendarDataSource
     func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
         print("Hit FSCalendarDataSource")
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
         print("Hit FSCalendarDelegateAppearance")
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
}
