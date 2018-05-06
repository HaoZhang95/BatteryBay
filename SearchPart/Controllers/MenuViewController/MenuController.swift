
//- MARK: Side Bar Page

import UIKit

class MenuController: UITableViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var certImgeView: UIImageView!
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var certLable: UILabel!
    @IBOutlet var belanceLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImage.image = #imageLiteral(resourceName: "profileImg")
        certImgeView.image = #imageLiteral(resourceName: "KeyTification_homePage")
        
        if let user = UserSessionController.shared.user{
            nameLable.text = user.username
            certLable.text = "Regular User"
            belanceLable.text = "\(user.points)"
            if user.status == 1 {
                certLable.text = "Administrator"
            }
        } else {}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
