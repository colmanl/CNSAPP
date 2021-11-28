//
//  DeleteEventPopupVIewController.swift
//  CNSAPP
//
//  Created by Meredith Spiers on 11/23/21.
//

import FSCalendar
import UIKit
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

class DeleteEventPopupViewController: CalendarViewController {
    
    @IBOutlet weak var backButton: UIButton!

    private var db = Firestore.firestore()

    override func viewDidLoad() {
        //super.viewDidLoad()

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
