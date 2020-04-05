//
//  Extension.swift
//  OrbisAssignment
//
//  Created by Suraj on 4/5/20.
//  Copyright © 2020 Mobikasa. All rights reserved.
//

import Foundation
import UIKit


protocol SetViewControllerIntials {
    static var controllerIdentifier:String { get set }
}

extension UIButton{
    func setCustomButton(button:UIButton){
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 2.0
    }
}

struct Identifiers{
    static let timerViewController = "TimerViewController"
}
