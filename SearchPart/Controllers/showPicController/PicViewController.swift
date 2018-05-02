

import UIKit
import FTIndicator

class PicViewController: UIViewController,UITextFieldDelegate {
  
    let defaults = UserDefaults.standard
    var selectedUIImage: UIImage?
    let defaultKeyword = "Battery"
    var category = ""
    
    @IBOutlet weak var selectedPic: UIImageView!
    @IBAction func reTakePicTap(_ sender: UIButton) {
        backToScan()
    }
    
    @IBAction func showAvaliableRecycleSpots(_ sender: UIButton) {
        print("showAvaliableRecycleSpots")

        if self.category == "" {
            self.category = defaultKeyword
        }
        let showAvaliableSpotsNotification = NSNotification.Name(rawValue: "showAvaliableSpots")
        NotificationCenter.default.post(name: showAvaliableSpotsNotification, object: self.category)
        
        let hintTitle = "\(self.category) detected"
        let hintSubtile = "Here are avaliable spots"
        DispatchQueue.main.asyncAfter(deadline: .now()+1)  {
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showNotification(with: #imageLiteral(resourceName: "UnlockSucess"), title: hintTitle, message: hintSubtile)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    @IBOutlet weak var showMapBtn: UIButton!
    @IBOutlet weak var reTakeBtn: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var detectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detect Category"
        detectBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retake", style: .plain, target: self, action: #selector(backToScan))
        
        categoryTextField.delegate = self

        selectedPic.image = selectedUIImage
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        self.category = text
        return true
    }
    
    @objc func backToScan()  {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func detectCategory(_ sender: UIButton) {
        print("begin detect category, do Some detection here")
        if self.category == "" {
            self.category = defaultKeyword
        }

        categoryTextField.text = self.category
    }
  
}

