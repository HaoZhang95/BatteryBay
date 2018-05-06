
// MARK : Show Toast

import Foundation
import FTIndicator

struct ToastHelper {
    
    static func showSuccessToast (title: String, subTitle: String) {
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "complete"), title: title, message: subTitle)
    }
    
    static func showFailedToast (title: String, subTitle: String) {
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "timeout"), title: title, message: subTitle)
    }
    
}
