//
//  UserLoginService.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 01/05/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserLoginService: Service {
    
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (User?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let user = User(json: json["user"], token: json["token"].stringValue)
                    
                    completionHandler(user)
                case .error(let errorCode, _):
                    print(errorCode!)
                    completionHandler(nil)
                default:
                    completionHandler(nil)
                }
            })
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    typealias output = User
    
    init(username: String, password: String) {
        self.request = UserRequest.logInUser(username: username, password: password)
    }
    
}
