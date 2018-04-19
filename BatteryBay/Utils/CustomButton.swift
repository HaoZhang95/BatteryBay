//
//  CustomButton.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override open var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.mainColor() : UIColor.clear
            if isSelected {
                setTitleColor(.white, for: .normal)
            } else {
                setTitleColor(.darkGray, for: .normal)
            }
        }
    }
}

