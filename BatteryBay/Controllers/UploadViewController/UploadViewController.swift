//
//  UploadViewController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 30/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire

extension UploadViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        uploadImageView.image = selectedImage
        
        sendButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
}

class UploadViewController: UIViewController {
    
    lazy var sendButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: #imageLiteral(resourceName: "send-button"), style: .plain, target: self, action: #selector(handleUploadImage))
        btn.isEnabled = false
        return btn
    }()
    
    let categoriesTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Categories"
        tf.backgroundColor = UIColor.lightGray
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let uploadImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "frame-landscape")
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let titleView: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Upload"
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(uploadImageView)
        view.addSubview(categoriesTextField)
        
        uploadImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 180)
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewClicked)))
        
        categoriesTextField.anchor(top: uploadImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 60)
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = sendButton
    }
    
    @objc private func handleUploadImage() {
        // Handle upload image
        
        print(123)
        
        guard let category = categoriesTextField.text else { return }
        
        let image = uploadImageView.image
        
        let imageData = UIImagePNGRepresentation(image!)
        
        let url = "https://metropolia.herokuapp.com/image"
        let accessToken = UserSessionController.shared.user?.token
        
        let id = UserSessionController.shared.user?.id
        
        let header = ["x-access-token" : accessToken]
        
        var parameters = ["userId" : id, "category" : category]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //multipartFormData.append(imageData!, withName: "pic")
            multipartFormData.append(imageData!, withName: "pic", fileName: "image.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))!, withName: key)
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: ["x-access-token": accessToken!]) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    print(response)
                    print()
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func handleImageViewClicked() {
        // Upload image
        let alertVC = UIAlertController(title: "", message: "Please select one action", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let openCamaraAction = UIAlertAction(title: "Take new photo", style: .default) { (openCameraAction) in
            // Open the camera
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose photos from library", style: .default) { (choosePhotoAction) in
            // Open the library to choose photo
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(openCamaraAction)
        alertVC.addAction(choosePhotoAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}







