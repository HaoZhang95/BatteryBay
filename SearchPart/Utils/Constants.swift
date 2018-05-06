
// MARK : This class defines some constants for web request.

import Foundation
struct Constants {

    // MARK : Our own public API
    static let USER_HOSTNAME = "https://metropolia.herokuapp.com/user"
    
    // MARK : Google map web services for searching the nearest recycle spots
    static let PLACES_API_KEY = "AIzaSyDB8IykCixpC87xxX_w0Yd1E1wpkCTPYjM"
    static let PLACES_DETAIL_URL = "https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@"
    static let PLACES_PHOTO_URL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@"
    static let PLACES_SEARCH_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%@,%@&radius=%@&key=%@"
    
    static let DEFAULT_SEARCH_KEYWORD = "Battery+Recycle"
    static let DEFAULT_SEARCH_RADIUS = "3000"

}
