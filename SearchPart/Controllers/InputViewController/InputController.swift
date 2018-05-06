
//- MARK: Input bar code manully page

import UIKit
import APNumberPad

class InputController: UIViewController,APNumberPadDelegate,UITextFieldDelegate {
    var isFlashOn = false
    var isVoiceOn = true
    let defaults = UserDefaults.standard
    var code = ""
    
    @IBAction func flashBtnTap(_ sender: UIButton) {

        Util.turnTorch()
        
        if isFlashOn {
            flashBtn.setImage(#imageLiteral(resourceName: "lightclose"), for: .normal)
            defaults.set(true, forKey: "isFlashOn")
            
        } else {
            flashBtn.setImage(#imageLiteral(resourceName: "lightopen"), for: .normal)
            defaults.set(false, forKey: "isFlashOn")
            
        }
        
        isFlashOn = !isFlashOn
    }
    
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        isVoiceOn = !isVoiceOn
        
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
            
            
            defaults.set(true, forKey: "isVoiceOn")
            
        } else {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
            
            defaults.set(false, forKey: "isVoiceOn")
        }
        
        
    }
    
    
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var goBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bar Code"
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(backToScan))
        
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("OK", for: .normal)
        inputTextField.inputView = numberPad
        inputTextField.delegate = self
        
        goBtn.isEnabled = false  
    }
    
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        checkPass()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        if newLength > 0 {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            //goBtn.backgroundColor = UIColor.ofo
            goBtn.isEnabled = true
            
        } else {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
            goBtn.backgroundColor = UIColor.groupTableViewBackground
            goBtn.isEnabled = false
        }
        
        
        return newLength <= 8
        
    }
    
    
    @objc func backToScan()  {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBtnTap(_ sender: UIButton) {
        checkPass()
    }
    
    var passArray: [String] = []
    
    
    func checkPass()  {
        if !inputTextField.text!.isEmpty {
            code = inputTextField.text!
            self.performSegue(withIdentifier: "showResultFromInput", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultFromInput" {
            let destVC = segue.destination as! BatteryDetailsController
            destVC.batteryModel = self.code
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
