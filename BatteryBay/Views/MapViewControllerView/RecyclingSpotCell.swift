//
//  RecyclingSpotCell.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 01/05/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import UIKit

class RecyclingSpotCell: UICollectionViewCell {
    
    var spot: RecyclingSpot? {
        didSet {
            guard let spot = spot else { return }
            
            titleView.text = spot.address
            descriptionText.text = spot.descriptionOfSpot
            distanceFromYou.text = "\(spot.distanceFromYourLocation ?? 0) km from you"
        }
    }
    
    let distanceFromYou: UILabel = {
        let distanceLbl = UILabel()
        distanceLbl.text = "7 km from your location"
        distanceLbl.textAlignment = .center
        distanceLbl.font = UIFont.systemFont(ofSize: 13)
        distanceLbl.textColor = .gray
        return distanceLbl
    }()
    
    let titleView: CustomLabel = {
        let title = CustomLabel()
        title.text = "Leppavaara 10"
        title.font = UIFont(name: "Avenir-Medium", size: 22)
        title.textColor = .black
        title.textAlignment = .center
        title.backgroundColor = .lightGray
        return title
    }()
    
    let descriptionText: CustomLabel = {
        let txt = CustomLabel()
        txt.text = "This place is very nearby"
        txt.textColor = .lightGray
        txt.font = UIFont(name: "Avenir-BookOblique", size: 15)
        txt.textAlignment = .center
        return txt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackground()
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(titleView)
        addSubview(descriptionText)
        addSubview(distanceFromYou)
        
        titleView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 80)
        descriptionText.anchor(top: titleView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        distanceFromYou.anchor(top: descriptionText.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
    }
    
    fileprivate func setupBackground() {
        backgroundColor = .white
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}








