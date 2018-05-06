
// MARK : People's review on a certain place

import Foundation

class Review: NSObject{
    var username: String
    var review_text: String
    var review_time: String
    var user_profile_image: String
    var rating: Float
    
    init(username: String, review_text: String, review_time:String, user_profile_image: String, rating: Float) {
        
        self.username = username
        self.review_text = review_text
        self.review_time = review_time
        self.user_profile_image = user_profile_image
        self.rating = rating
    }
}
