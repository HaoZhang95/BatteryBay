//
//  Extensions.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//
import UIKit
import Foundation
import Alamofire

extension UserDefaults {
    enum UserDefaultKey: String{
        case isLoggedIn
    }
    func setUserLoggedIn(value: Bool) {
        UserDefaults.standard.set(value, forKey: UserDefaultKey.isLoggedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKey.isLoggedIn.rawValue)
    }
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func movieTintColor() -> UIColor {
        return UIColor.rgb(red: 238, green: 23, blue: 87)
    }
    
    static func mainColor() -> UIColor {
        return UIColor.rgb(red: 22, green: 25, blue: 30)
    }
    
    static func userProfileTintColor() -> UIColor {
        return UIColor.rgb(red: 162, green: 82, blue: 229)
    }
    
    static func tvShowCellTextColor() -> UIColor {
        return UIColor.rgb(red: 97, green: 99, blue: 107)
    }
    
    static func onBoardTitle() -> UIColor {
        return UIColor.rgb(red: 158, green: 158, blue: 158)
    }
    
    static func onBoardText() -> UIColor {
        return UIColor(white: 0, alpha: 0.7)
    }
    
    static func pageControlTintColor() -> UIColor {
        return UIColor.rgb(red: 204, green: 204, blue: 204)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top,  constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}
