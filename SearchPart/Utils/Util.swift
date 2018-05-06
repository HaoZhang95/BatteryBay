
// MARK : This class defines static functions

import Foundation
import AVFoundation

class Util{
    
    // MARK : Convert distance in %.1f format
    static func formatDistanceText(distanceinKiloMeter: Double) -> String{
        return "\(String(format:"%.1f", distanceinKiloMeter)) km"
    }
    
    // MARK : Open torch
    static func turnTorch()  {
        guard let device  = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        if device.hasTorch && device.isTorchAvailable {
            try? device.lockForConfiguration()
            
            if device.torchMode == .off {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
        }
        
    }
}
