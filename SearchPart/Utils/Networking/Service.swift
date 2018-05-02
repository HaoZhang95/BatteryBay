//
//  Service.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 29/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation

public protocol Service {
    associatedtype output
    
    var request: Request { get }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (output?) -> ())
}
