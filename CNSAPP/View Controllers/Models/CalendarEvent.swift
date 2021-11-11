//
//  Events.swift
//  CNSAPP
//
//  Created by Meredith Spiers on 11/9/21.
//

import Foundation

struct CalenderEvent: Identifiable {
    
    var id: String // Document id in db
    var eventTitle: String
    var eventDescription: String
    var eventDate: String
}
