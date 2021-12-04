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

class CalendarViewController: UIViewController, UITextViewDelegate, ObservableObject, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var outputTextView: UITextView!
    
    var didLoadData: Bool = false
    
    @IBOutlet weak var newEventLabel: UILabel!
    
    @IBOutlet weak var deleteEventButton: UIButton!
    
    @IBOutlet weak var inputEventTitle: UITextField!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var selectDateLabel: UILabel!
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
        
    var dateStringOutput = ""
    
    var dateDBFormat = Date()
    
    var datesArray = ["01-01-2021"]

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
        setUpElements()
        reducedPrivileges()
        calendar.dataSource = self
        calendar.delegate = self
        outputTextView.delegate = self
        inputEventTitle.delegate = self
        getCurrentDate()
        inputTextView.delegate = self;
        //inputTextView.text = "(Optional) Enter event description"
        inputTextView.textColor = UIColor.lightGray
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //view.addGestureRecognizer(tap)
        
    }
    
    func getCurrentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM. d"
        dateStringOutput = dateFormatter.string(from: date)
        
    }
    
    @IBAction func showDeletionAlert() {
        let alert = UIAlertController(title: "Delete Event(s)?", message: "This will delete all events on \(dateStringOutput)", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                self.dismiss(animated: true)
            }))
        alert.addAction(UIAlertAction(title: "Delete",
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                self.deleteEvent(self.dateDBFormat)
            }))
        self.present(alert, animated: true, completion: nil)
        }
    
    @objc func handleTap(){
        inputTextView.resignFirstResponder()
        inputEventTitle.resignFirstResponder()
    }
    
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
        print("getData Hit")
    }
    
    func deleteEvent(_ date: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateStringFromDb = formatter.string(from: date)
        
        for event in eventList {
            if event.eventDate == dateStringFromDb {
                db.collection("calendarEvents").document(event.id).delete()
            }
            else {
                
            }
        }
        didLoadData = true
        getData()
        addDbDatesToDatesArray()
    }
    
    // FSCalendarDelegate for when user selects a date on the calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        dateDBFormat = date
        var outputEvents = ""
        var eventsExist = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. d"
        dateStringOutput = formatter.string(from: date)
        
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
         
         if datesArray.contains(dateString) {
             return [UIColor.blue]
         }
         else {
             return [UIColor.white]
         }
     }
    
    func reducedPrivileges(){
        if ( userEmailCalendar != "cnskids@gmail.com" ) {
            newEventLabel.isHidden = true
            inputEventTitle.isHidden = true
            inputTextView.isHidden = true
            selectDateLabel.isHidden = true
            inputDate.isHidden = true
            submitButton.isHidden = true
            deleteEventButton.isHidden = true
        }
    }
    func setUpElements(){
        LoginStyling.styleFilledButton(submitButton)
        LoginStyling.styleHollowButtonThree(deleteEventButton)
    }

    @IBAction func submitBtnTapped(_ sender: Any) {
        let eventTitle = inputEventTitle.text!
        var eventDescription = inputTextView.text!
        let eventDate = inputDate.date
        
        // EXPLANATION: turning date input into a string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateString = formatter.string(from: eventDate)

        if eventTitle == "" {
            showErrorMessage("Error: Please enter an event title")
        }
        else {
            if eventDescription == "(Optional) Enter event description" {
                eventDescription = ""
                print("eventDescription =", eventDescription)
            }
            print("eventDescription2 =", eventDescription)
            db.collection("calendarEvents").addDocument(data: ["eventTitle":eventTitle, "eventDescription":eventDescription, "eventDate":dateString]) { error in
                
                if error == nil
                {
                    self.getData()
                    self.addDbDatesToDatesArray()
                    self.showSimpleAlert()
                }
                else {
                    self.showErrorMessage("Error: Unable to add event")
                }
            }
            
            inputEventTitle.text = nil
            inputTextView.text = nil
            showErrorMessage("")
            
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
    
    func textFieldShouldReturn(_ inputEventTitle: UITextField) -> Bool{
        inputEventTitle.resignFirstResponder()
        return true
    }
    
    private func textViewShouldReturn(_ inputTextView: UITextView) -> Bool {
        inputTextView.resignFirstResponder()
        return true
     }
}
