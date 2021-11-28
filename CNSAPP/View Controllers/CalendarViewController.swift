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
    
    var didLoadData: Bool = false
     
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var deleteEventButton: UIButton!
    
    @IBAction func addEvent(_ sender: Any) {}
    
    var dateStringOutput = ""
    
    func getCurrentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM. d"
        print("\(dateFormatter.string(from: date))")
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
                                            //Sign out action
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }

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
        print("Hit Calendar viewdidload")
        reducedPrivileges()
        calendar.dataSource = self
        calendar.delegate = self
        outputTextView.delegate = self
        getCurrentDate()
    }
    
    var datesArray = ["01-01-2021"]
    
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
    
    // FSCalendarDelegate for when user selects a date on the calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        var outputEvents = ""
        var eventsExist = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. d"
        dateStringOutput = formatter.string(from: date)
        
        //addDbDatesToDatesArray()
        
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
        if ( userEmailCalendar != "Email_test@test.com" ) {
            addEventButton.isHidden = true
            deleteEventButton.isHidden = true
        }
    }
    func setUpElements(){
        //LoginStyling.styleHollowButtonTwo(addEventButton)
        //LoginStyling.styleHollowButtonThree(deleteEventButton)
    }

}
