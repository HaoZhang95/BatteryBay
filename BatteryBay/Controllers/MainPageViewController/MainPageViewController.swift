//
//  MainPageViewController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 30/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import UIKit

class MainPageViewController: UIViewController {
    
    let orLabel: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "-or-"
        lbl.font = UIFont(name: "Avenir-HeavyOblique", size: 20)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    let searchText: CustomLabel = {
        let text = CustomLabel()
        text.text = "Find Nearest Recycling Spot"
        text.textColor = .black
        text.font = UIFont(name: "Avenir-Heavy", size: 20)
        text.textAlignment = .center
        return text
    }()
    
    let cameraText: CustomLabel = {
        let text = CustomLabel()
        text.text = "Scan your batttery"
        text.textColor = .black
        text.font = UIFont(name: "Avenir-Heavy", size: 20)
        text.textAlignment = .center
        return text
    }()
    
    let searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "search (1)")
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    let cameraIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "camera")
        icon.contentMode = .scaleAspectFill
        icon.isUserInteractionEnabled = true
        icon.clipsToBounds = true
        return icon
    }()
    
    let titleView: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Main Page"
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(cameraIcon)
        view.addSubview(cameraText)
        view.addSubview(searchIcon)
        view.addSubview(searchText)
        view.addSubview(orLabel)
        
        orLabel.anchor(top: view.centerYAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 70)
        orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cameraIcon.anchor(top: nil, left: nil, bottom: view.centerYAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 70, height: 70)
        cameraIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraIconClicked)))
        
        cameraText.anchor(top: nil, left: nil, bottom: cameraIcon.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: view.frame.width, height: 60)
        cameraText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchIcon.anchor(top: orLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        searchIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSearchIconClicked)))
        
        searchText.anchor(top: searchIcon.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 60)
        searchText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleView
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Set up methods
    
    @objc func handleSearchIconClicked() {
        let vc = MapViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleCameraIconClicked() {

        let vc = UploadViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}




