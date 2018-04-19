// MARK: - Toast creation, performs likes what we have in Android
// Usage Example :
/*
    ToastHelper.getInstance().createToast(
        self.view, position: .Top,
        toastColor: UIColor.orange,
        textColor: UIColor.white
    ).show (timeInterval: 1, message: "Please check your input format")
*/
import Foundation
import UIKit

class ToastHelper {

    private static var instance: ToastHelper?
    private init(){}
    
    static func getInstance() -> ToastHelper {
        if instance == nil {
            instance = ToastHelper()
        }
        return instance!
    }
    
    func createToast(_ view: UIView, position: toastPosition = .Top, toastColor: UIColor = UIColor.orange, textColor:UIColor = UIColor.white) -> Toast{
        return Toast(view, position: position,toastColor: toastColor, textColor: textColor)
    }
    
}
class Toast {
    
    private var toastView = UIView()
    private var label = UILabel()
    
    init(_ view: UIView, position: toastPosition, toastColor: UIColor, textColor:UIColor) {
        
        // MARK: - Toast and outlook size design
        
        toastView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.9  , height: 50)
        switch position {
        case .Top:
            toastView.center = CGPoint(x: view.bounds.width / 2, y: 60 )
        case .Medium:
            toastView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 )
        default:
            toastView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 100)
        }
        toastView.alpha = 0
        toastView.backgroundColor = toastColor
        toastView.layer.cornerRadius = 10
        
        label.frame = CGRect(x: 0, y: 0, width: toastView.frame.width, height: 50)
        label.textAlignment = .center
        label.textColor = textColor
        label.center = toastView.center
        label.numberOfLines = 0
        label.center = CGPoint(x: toastView.bounds.width / 2, y: toastView.bounds.height / 2)
        
        toastView.addSubview(label)
        view.addSubview(toastView)
    
    }
    
    // MARK: - Main idea is to change the alpha to show/hide
    
    func show(timeInterval: Double = 1.0, message: String) -> () {
        
        label.text = message
        UIView.animate(withDuration: 0.5, animations: {
            self.toastView.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: timeInterval * 3, animations: {
                self.toastView.alpha = 0
            }) { (true) in
                DispatchQueue.main.async(execute: {
                    self.toastView.alpha = 0
                    self.label.removeFromSuperview()
                    self.toastView.removeFromSuperview()
                })
            }
        }
    }
}
