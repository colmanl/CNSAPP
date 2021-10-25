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

class CalendarViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet var calendar: FSCalendar!
    
    @IBOutlet weak var outputTextView: UITextView!
    
    @IBOutlet weak var inputEventTitle: UITextField!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var inputDate: UIDatePicker!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBAction func addEventBtnTapped(_ sender: Any) {
        let db = Firestore.firestore()
        var eventTitle = inputEventTitle.text!
        var eventDescription = inputTextView.text!
        let eventDate = inputDate.date
        
        db.collection("calendarEvents").addDocument(data: ["eventTitle":eventTitle, "eventDescription":eventDescription, "eventDate":eventDate])
        
        eventTitle = ""
        eventDescription = ""
        
        showSimpleAlert()
        // signal on the calendar that an event is there at the eventDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        //let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. d"
        let string = formatter.string(from: date)
        outputTextView.text = "\(string) Announcements:"
        /*
        formatter.dateFormat = "MMMM d, YYYY"
        let string2 = formatter.string(from: date)
        print ("Query result: ", db.collection("calendarEvents").whereField("eventDate", isEqualTo: [string2]))
        
        db.collection("calendarEvents").whereField("eventDate", isEqualTo: [string2])
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("2nd Query Result: ","\(document.documentID) => \(document.data())")
                    }
                }
         */
        }

      /*
        if (true){
            
            //"state", isEqualTo: "CA"
            // outputTextView = db.collection("calendarEvents").addDocument(data: ["eventTitle":eventTitle, "eventDescription":eventDescription])
        }
        // find formatter in db
        // display the eventTitle and eventDescription in the outputTextView
    }

    func textViewBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    */
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Success!", message: "Your event was successfully added", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
}

