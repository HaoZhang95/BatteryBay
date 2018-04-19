
// Mark: - The following class is only suitable for the api that i am using
// Usage Example :
/*
     let params = NSMutableDictionary()
     params.setValue(self.username, forKey: "username")
     params.setValue(self.password, forKey: "password")
     params.setValue(self.email, forKey: "email")
 
     NetworkHelper.getInstance().performHttpRequest(
        type: requestType.POST, urlString: Urls.baseUrl + "/users",
        token: nil,
        json: params,
        completionHandler: { (loadedData) -> (Void) in
            DO SOMETHING HERE WITH loadedData
        }
 
 */
import Foundation
import UIKit

/*
 * This class handles GET/DELETE/PUT/POST http request, This structure may be changed later.
 */
class NetworkHelper {
    
    var urlSession: URLSession
    private static var instance: NetworkHelper?
    
    private init(){
        urlSession = URLSession.shared
    }
    
    static func getInstance() -> NetworkHelper {
        if instance == nil {
            instance = NetworkHelper()
        }
        return instance!
    }
    
    // Mark: - The following request design is only suitable for the api that i am using
    // 1- if url convertion fails, just skip
    // 2- if request type is GET, No need to config request
    // 3- if request is not GET, config Headers and httpBody--Array<Dictionary<String, Any>>
    func performHttpRequest(type:requestType,
                            urlString:String, token: String?,
                            json: NSMutableDictionary?,
                            completionHandler:@escaping (_ jsonResult: Data) ->(Void),
                            errorHandler:@escaping (_ error: Error) ->(Void)) -> () {
        
        if let url = URL(string:urlString){
            
            // set up request
            var request = URLRequest(url: url)
            if type != requestType.GET {
                request.httpMethod = type.rawValue
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                if let okJson = json {
                    guard let httpBody = try? JSONSerialization.data(withJSONObject: okJson, options: []) else { return }
                    request.httpBody = httpBody
                }
                
                if token != nil && type != requestType.DELETE {
                    request.setValue(token, forHTTPHeaderField: "x-access-token")
                    
                    
                } else if token != nil {
                    request.setValue(token, forHTTPHeaderField: "x-access-token")
                }
            }
            
            // begin request
            let task = urlSession.dataTask(with: request, completionHandler: {
                (data,response,error) in
                
                if let err = error {
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009 {
                        print("No internet connection.")
                    }else{
                        print("Error happens01.")
                    }
                    errorHandler(err)
                    return
                }
                
                if let loadedData = data {
                    completionHandler(loadedData)
                }
            })
            task.resume()
        }
    }
    
}

