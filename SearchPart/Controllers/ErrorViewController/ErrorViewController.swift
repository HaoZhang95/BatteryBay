
//- MARK: Show error view when user scan an invalid bar code.

import UIKit
import MIBlurPopup

class ErrorViewController: UIViewController {
    
    let reloadScanNotification = NSNotification.Name(rawValue: "reloadScan")
    
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
        self.close()
    }
    
    @IBOutlet weak var myPopupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func closeBtnTap(_ sender: Any) {
        NotificationCenter.default.post(name: reloadScanNotification, object: nil)
        close()
    }
    
    func close()  {
        self.dismiss(animated: true)
    }
}

extension ErrorViewController: MIBlurPopupDelegate {
    var popupView: UIView {
        return myPopupView
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    
    var initialScaleAmmount: CGFloat {
        return 0.2
    }
    
    var animationDuration: TimeInterval {
        return 0.2
    }
}

