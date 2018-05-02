// MARK: - Sign up

import UIKit

class SignUpViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    var username = ""
    var password = ""
    
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
    
    func validate() -> Bool {
        
        if let username = emailTextField.text, let password = passwordTextField.text{
            self.username = username
            self.password = password
        }
        
        if self.password.trimmingCharacters(in: .whitespaces) != ""
            && self.username.trimmingCharacters(in: .whitespaces) != ""{
            
            return true
        }
        return false
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doSignUp(_ sender: UIButton) {
        if validate() {
            print(self.username)
            print(self.password)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            
            let signUpService = UserSignUpService(username: self.username, password: self.password)
            let dispatcher = NetworkingDispatcher(environment: Environment(name: "Test", host: Constants.USER_HOSTNAME))
            signUpService.execute(in: dispatcher) { (user) in
                if let user = user {
                    print("sign up done")
                    UserSessionController.shared.updateCurrentSession(user: user, userToken: user.token)
                    
//                    NotificationCenter.default.post(name: NSNotification.Name("loginOK"), object: nil)
                    
                    self.performSegue(withIdentifier: "toMainScreen", sender: nil)
                } else {
                    ToastHelper.showFailedToast(title: "Sign Up Failed", subTitle: "Username already exists")
                }
            }
        }else {
           ToastHelper.showFailedToast(title: "Sign Up Failed", subTitle: "Empty username or password")
        }
        activityIndicator.stopAnimating()
    }
    

}


