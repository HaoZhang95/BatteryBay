
//- MARK: Battery detail page
import UIKit
import FTIndicator

class BatteryDetailsController: UIViewController {
    
    @IBOutlet weak var showInfo: UILabel!
    
    var batteryModel = ""
    
    @IBAction func showRecycleSpots(_ sender: UIButton) {
        let hintTitle = "Code number: \(batteryModel)"
        let hintSubtile = "Here are avaliable spots"
        DispatchQueue.main.asyncAfter(deadline: .now()+1)  {
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showNotification(with: #imageLiteral(resourceName: "UnlockSucess"), title: hintTitle, message: hintSubtile)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Battery Details"
        self.navigationItem.hidesBackButton = true
        showInfo.text = "Model: " + batteryModel + " (Not finnished yet)"
        
        let showAvaliableSpotsNotification = NSNotification.Name(rawValue: "showAvaliableSpots")
        NotificationCenter.default.post(name: showAvaliableSpotsNotification, object: "Battery")
    }
    
    
}

