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
        BottomLine.backgroundColor = UIColor.blue.cgColor
        
        //Removes border on textfield
        textfield.borderStyle = .none
        
        //adds line to text field
        textfield.layer.addSublayer(BottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
         //Rounded corner styling
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
}
