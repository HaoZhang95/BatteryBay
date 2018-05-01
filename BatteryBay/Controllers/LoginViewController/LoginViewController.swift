//
//  LoginViewController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let dontHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = createAttributedString(firstString: "Don't have an account? ", secondString: "Sign Up")
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUpVC), for: .touchUpInside)
        return button
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor.lightGray
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.lightGray
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 249, green: 82, blue: 132)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupInputFields()
        
        setupDismissKeyboard()
    }
    
    fileprivate func setupDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.mainColor()
        view.addSubview(dontHaveAnAccountButton)
        view.addSubview(logoContainerView)
        
        dontHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height / 4)
        
    }
    
    private func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, logInButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
    }
    
    @objc private func handleShowSignUpVC() {
        // Handle showing sign up vc
        
        let signUp = SignUpViewController()
        
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!
        if isFormValid {
            logInButton.backgroundColor = UIColor.movieTintColor()
            logInButton.isEnabled = true
        } else {
            logInButton.backgroundColor = UIColor.rgb(red: 249, green: 82, blue: 132)
            logInButton.isEnabled = false
        }
    }
    
    @objc private func handleLogIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let signUpService = UserLoginService(username: email, password: password)
        
        let dispatcher = NetworkingDispatcher(environment: Environment(name: "Test", host: Constant.USER_HOSTNAME))
        
        
        
        signUpService.execute(in: dispatcher) { (user) in
            // Open user session
            
            UserSessionController.shared.updateCurrentSession(user: user, userToken: user.token)
            
            NotificationCenter.default.post(name: NSNotification.Name("loginOK"), object: nil)
        }
        
        
        
        print(123)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private static func createAttributedString(firstString: String, secondString: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: firstString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: secondString, attributes: [NSAttributedStringKey.foregroundColor: UIColor.movieTintColor(), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        return attributedText
    }
}
