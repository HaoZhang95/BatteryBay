//
//  InitialViewController.swift
//MARK: if user loggin and doesn't logout last time,
// when reopen this open will lead to home page, instead of loggin one more time.

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //- MARK: Check if user is authenticated.
        //- MARK: Using UserDefaults to store 'token' which is provided from network response after you loggin
        if UserDefaults.standard.string(forKey: "token") != nil {
            self.performSegue(withIdentifier: "toMainScreen", sender: self)
        } else {
            self.performSegue(withIdentifier: "toLoginScreen", sender: self)
        }
    }
    

}
