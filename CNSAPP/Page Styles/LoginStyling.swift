//
//  LoginStyling.swift
//  CNSAPP
//
//  Created by Zech Watkins on 10/10/21.
//

import Foundation
import UIKit

class LoginStyling{
    
    static func styleTextField(_ textfield:UITextField){
        //makes the bottomline
        let BottomLine = CALayer()
        
        BottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        //makes the line yellow
        BottomLine.backgroundColor = UIColor.systemYellow.cgColor
        
        //Removes border on textfield
        textfield.borderStyle = .none
        
        //adds line to text field
        textfield.layer.addSublayer(BottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
         //Rounded corner styling
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton){
        //Hollow Button
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.systemBlue
        
    }
    static func styleHollowButtonTwo(_ button:UIButton){
        //Hollow Button
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.systemYellow
        
    }
    static func styleHollowButtonThree(_ button:UIButton){
        //Hollow Button
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.systemRed
        
    }
  
}
