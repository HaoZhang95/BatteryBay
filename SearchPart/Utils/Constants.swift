//
//  Constants.swift
//  Places
//
//  Created by Karthi Ponnusamy on 1/4/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation
struct Constants {

    static let USER_HOSTNAME = "https://metropolia.herokuapp.com/user"
    
    static let PLACES_API_KEY = "AIzaSyCjVwNTR5mGg5Jjo8COBCh6qd0Siu1l8J0"
    
    static let PLACES_DETAIL_URL = "https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@"
    static let PLACES_PHOTO_URL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@"

    static let PLACES_SEARCH_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%@,%@&radius=%@&key=%@"
    
    static let DEFAULT_SEARCH_KEYWORD = "Battery+Recycle"
    static let DEFAULT_SEARCH_RADIUS = "3000"

}
