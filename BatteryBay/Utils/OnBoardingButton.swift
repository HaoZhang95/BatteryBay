//
//  OnBoardingButton.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingButton: UIButton {
    override open var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.movieTintColor() : UIColor.movieTintColor()
            if isSelected {
                setTitleColor(.white, for: .normal)
            } else {
                setTitleColor(.white, for: .normal)
            }
        }
    }
}

