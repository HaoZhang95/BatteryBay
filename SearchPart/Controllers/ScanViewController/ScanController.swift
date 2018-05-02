//
//  ScanController.swift
//  OFO
//  扫码界面
//  Created by iMac on 2017/6/5.
//  Copyright © 2017年 JoJo. All rights reserved.
//

import UIKit
import AVFoundation
import swiftScan
import FTIndicator

enum ScanError : Error {
    case NotNumber
}

class ScanController: LBXScanViewController {

    var isFlashOn = false
    var passArray: [String] = []
    var code = ""
    
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var panelView: UIView!
    
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        scanObj?.changeTorch()
        
        if isFlashOn{
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        }else{
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        }
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first {
            let msg = result.strScanned
            
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showToastMessage(msg)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1)  {
                if let msg = msg {
                    self.checkPass(code: msg)
                }
            }
        }
    }
    
    func checkPass(code: String) {
    
        guard let codeNum = Int(code) else {
            print("Scan result is not number")
            self.performSegue(withIdentifier: "showErrorView", sender: self)
            return
        }
        print("扫面的条形码为: \(codeNum)")
        self.code = "\(codeNum)"
        self.performSegue(withIdentifier: "showResultFromScan", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scan Bar Code"
        
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")
        scanStyle = style
        
        let reloadScanReceiver = NSNotification.Name(rawValue:"reloadScan")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadScan), name: reloadScanReceiver, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc public func reloadScan() {
        startScan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: panelView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    //转场动画
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultFromScan" {
            print("准备跳转获取解锁码界面")
            let destVC = segue.destination as! BatteryDetailsController
            destVC.batteryModel = self.code
        }
    }

}
