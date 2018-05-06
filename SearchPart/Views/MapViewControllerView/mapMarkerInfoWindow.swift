
// MARK : Customized map marker

import UIKit
import SwiftyButton
import SnapKit

class mapMarkerInfoWindow: UIView {
    
    var onlyButton : FlatButton = FlatButton()
    var Name : UILabel = UILabel()
    var AddressLabel : UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
        self.VborderColor = UIColor.lightGray
        self.VborderWidth = 1.0
        
        Name.textColor = UIColor.black
        Name.font = UIFont(name: "Futura-Medium", size: 16)!
        Name.numberOfLines = 1
        Name.textAlignment = NSTextAlignment.left
        self.addSubview(Name)
        
        AddressLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        AddressLabel.text = "StillOpen: "
        AddressLabel.font = UIFont(name: "Futura-Medium", size: 13)!
        AddressLabel.textAlignment = NSTextAlignment.left
        self.addSubview(AddressLabel)
    
        
        Name.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self)
            make.height.equalTo(self.frame.height/3)
        }
        AddressLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(Name.snp.bottom)
            make.height.equalTo(self.frame.height/3)
            make.width.equalTo(120)
        }
    
        onlyButton.setTitle("See Details", for: .normal)
        onlyButton.color = Colors.darkGreen
        onlyButton.highlightedColor = Colors.lightGreen
        onlyButton.cornerRadius = 0
        onlyButton.titleLabel!.font = UIFont(name: "Futura-Medium", size: 13)!
        self.addSubview(onlyButton)
        
        onlyButton.snp.makeConstraints{(make) -> Void in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(self.frame.height/3)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
