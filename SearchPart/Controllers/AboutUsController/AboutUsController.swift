//- MARK: About US page

import UIKit
import SWRevealViewController

class AboutUsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //- MARK: Side Bar initialization
        if let revealVC = revealViewController() {
            
            revealVC.rearViewRevealWidth = 280
            
            navigationItem.leftBarButtonItem?.target = revealVC
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
