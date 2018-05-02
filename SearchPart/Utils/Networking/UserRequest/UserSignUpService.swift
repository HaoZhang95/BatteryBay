//
//  UserSignUpServicec.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 30/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserSignUpService: Service {
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (User?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let user = User(json: json["user"], token: json["token"].stringValue)
                    
                    completionHandler(user)
                case .error(let errorCode, _):
                    print(errorCode)
                    completionHandler(nil)
                default:
                    completionHandler(nil)
                }
            })
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    var request: Request
    
    typealias output = User
    
    init(username: String, password: String) {
        self.request = UserRequest.signUpUser(username: username, password: password)
    }
    
}
