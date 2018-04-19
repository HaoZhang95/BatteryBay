import UIKit

// Usage Example : Urls.baseUrl + "/uploads/"
enum Urls {
    static var baseUrl = "https://metropolia.herokuapp.com"
}

// Usage : Convert seconds to a timeStamp
extension Int {
    func secondsToFormattedString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let second = (self % 3600) % 60
        let hoursString: String = {
            let hs = String(hours)
            return hs
        }()
        
        let minutesString: String = {
            var ms = ""
            if  (minutes <= 9 && minutes >= 0) {
                ms = "0\(minutes)"
            } else{
                ms = String(minutes)
            }
            return ms
        }()
        
        let secondsString: String = {
            var ss = ""
            if  (second <= 9 && second >= 0) {
                ss = "0\(second)"
            } else{
                ss = String(second)
            }
            return ss
        }()
        
        var label = ""
        if hours == 0 {
            label =  minutesString + ":" + secondsString
        } else{
            label = hoursString + ":" + minutesString + ":" + secondsString
        }
        return label
    }
}

// MARK: - extension for uiimageview to show the downloaded image

// Usage Example :  cell.titleLabel.text = XXX.title
//                  cell.descLabel.text = XXX.desc
//                  if let url = XXX.thumbnailUrl {
//                      cell.imgView.downloadImage(from: url)  
//                  }
//                  return cell

extension UIImageView {
    
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                let errorCode = (error! as NSError).code
                if errorCode == -1009{
                    print("No internet connection.")
                }else {
                    print(error!.localizedDescription)
                }
                return
            }
            DispatchQueue.main.async {
                if let okData = data {
                    self.image = UIImage(data: okData)
                }
            }
        }
        task.resume()
    }
}

enum requestType: String {
    case GET
    case POST
    case DELETE
    case PUT
}

enum toastPosition {
    case Top
    case Medium
    case Bottom
}


