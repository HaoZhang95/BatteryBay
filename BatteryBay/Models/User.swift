//
//  User.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 29/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    let id: String
    let username: String
    let status: Int
    var points: Int
    var token: String
    
    init(json: JSON, token: String) {
        self.id = json["_id"].stringValue
        self.username = json["username"].stringValue
        self.status = json["status"].intValue
        self.points = json["points"].intValue
        self.token = token
    }
}
