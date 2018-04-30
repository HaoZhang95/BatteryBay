//
//  UserRequest.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 30/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation

public enum UserRequest: Request {
    
    case signUpUser(username: String, password: String)
    
    public var path: String {
        switch self {
        case .signUpUser(let username, let password):
            return "signup"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .signUpUser(_, _):
            return .post
        }
    }
    
    public var parameters: RequestParams? {
        switch self {
        case .signUpUser(let username, let password):
            return RequestParams.body(["username" : username, "password" : password])
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .signUpUser(_, _):
            return nil
        }
    }
    
    public var dataType: DataType {
        return .JSON
    }
    
}
