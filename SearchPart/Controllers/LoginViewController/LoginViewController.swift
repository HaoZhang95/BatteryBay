//MARK: Do login Here

import UIKit
import FTIndicator

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupDismissKeyboard()
    }
    
    fileprivate func setupDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Simple form validation, if input is not empty then return true
    
    func validate() -> Bool {
        
        if let username = emailTextField.text, let password = passwordTextField.text{
            self.username = username
            self.password = password
        }
        
        if self.username.trimmingCharacters(in: .whitespaces) != ""
            && self.password.trimmingCharacters(in: .whitespaces) != "" {
            return true
        }
        return false
    }
    
    //MARK: login and jump page
    
    @IBAction func loginButton(_ sender: UIButton) {
        if validate() {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            print("有效, 开始登录")
            print(self.username)
            print(self.password)
        
            let loginService = UserLoginService(username: self.username, password: self.password)
            
            let dispatcher = NetworkingDispatcher (environment: Environment(name: "Test", host: Constants.USER_HOSTNAME))
            
            loginService.execute(in: dispatcher) { (user) in
                // Open user session
                if let user = user {
                    print("login done")
                    UserSessionController.shared.updateCurrentSession(user: user, userToken: user.token)
                    self.performSegue(withIdentifier: "toMainScreen", sender: nil)
                } else {
                    ToastHelper.showFailedToast(title: "Login Failed", subTitle: "Incorrect username or password")
                }
            } 
        } else {
            ToastHelper.showFailedToast(title: "Login Failed", subTitle: "Empty username or password")
        }
        activityIndicator.stopAnimating()
    }
    
}


