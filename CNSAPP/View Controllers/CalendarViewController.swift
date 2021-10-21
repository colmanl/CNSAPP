//
//  CalendarViewController.swift
//  CNSAPP
//
//  Created by Meredith Spiers on 10/19/21.
//

import FSCalendar
import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet var calendar: FSCalendar!
    
    @IBOutlet weak var outputTextView: UITextView!
    
    @IBOutlet weak var inputEventTitle: UILabel!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. dd"
        let string = formatter.string(from: date)
        //outputTextView.text = ""
        outputTextView.text = "\(string) Announcements:"
    }
}
