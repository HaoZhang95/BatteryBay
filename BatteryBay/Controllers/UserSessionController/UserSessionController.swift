//
//  UserSessionController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 29/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation

enum UserState {
    case Undefined, Opened, Closed, Invalid
}

class UserSessionController {
    
    static let shared = UserSessionController()
    
    // MARK: Properties
    
    private(set) var state: UserState = .Undefined
    
    private(set) var user: User?
    
    init() {
        
    }
    
    public func updateCurrentSession(user: User, userToken: String) {
        self.user = user
        state = .Opened
        
        // Save user token as well
        
        UserDefaults.standard.set(userToken, forKey: user.id)
    }
    
    public func closeCurrentSession() {
        
        guard let user = user else { return }
        
        // Remove user token
        
        UserDefaults.standard.removeObject(forKey: user.id)
        
        self.user = nil
        state = .Closed
    
    }
    
}
