
import Foundation
import CoreLocation

/**
 name: Kilobergsgränden 5, id: ChIJu4pk4IL2jUYRaXh-KSQDJn4, coordinate: (60.220801 24.780226), open now: 2, phone: (null), address: Kilobergsgränden 5, 02610 Esbo, 芬兰, rating: 0.000000, price level: -1, website: (null), types: (
 "street_address"
 )
 */
struct locationObj {
    var openNow : Int = -1
    var lat : CLLocationDegrees = 180.00
    var lon : CLLocationDegrees = 180.00
    var name : String = ""
    var phone : String = ""
    var address : String = ""
    var rating : Int = -1
    var priceLevel : Int = -1
    var website : String = ""
    
}

let recycleSpotsLocations : [locationObj] = [
    locationObj(openNow: -1, lat: 60.22081, lon: 24.78026, name: "Kilobergsgränden 5", phone: "", address: "", rating: 2, priceLevel: 3, website: "www.baidu.com"),
    locationObj(openNow: 2, lat: 60.22082, lon: 24.78027, name: "Kilobergsgränden 6", phone: "469553366", address: "", rating: -1, priceLevel: 1, website: "www.google.com"),
    locationObj(openNow: 3, lat: 60.22083, lon: 24.78028, name: "Kilobergsgränden 7", phone: "", address: "", rating: 3, priceLevel: 2, website: ""),
    locationObj(openNow: 5, lat: 60.22084, lon: 24.78029, name: "Kilobergsgränden 8", phone: "", address: "", rating: 6, priceLevel: 7, website: "www.titter.com"),
    locationObj(openNow: -1, lat: 60.22085, lon: 24.78020, name: "Kilobergsgränden 9", phone: "", address: "", rating: -1, priceLevel: 1, website: ""),
]
