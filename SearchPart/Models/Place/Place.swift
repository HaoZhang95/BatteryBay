
// MARK : Place model

import MapKit

class Place: NSObject, MKAnnotation{
    var name: String
    var place_id: String
    var rating: Double?
    var vicinity: String?
    var open_now:Bool?
    var coordinate: CLLocationCoordinate2D
    var phone_number: String?
    var timings: [String]?
    var photos: [String]?
    var reviews: [Review]?
    var distance: Double?
    var isRecycleSpot: Bool
    
    init(name: String, place_id: String, locationCoordinate:CLLocationCoordinate2D, isRecycleSpot: Bool) {
        
        self.name = name
        self.place_id = place_id
        self.coordinate = locationCoordinate
        self.isRecycleSpot = isRecycleSpot
    }
    
    var subtitle: String? {
        return vicinity
    }
    
    var title: String? {
        if name.isEmpty {
            return "(No Title)"
        } else {
            return name
        }
    }
}
