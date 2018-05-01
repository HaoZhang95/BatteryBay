//
//  RecyclingSpot.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 01/05/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Contacts

class RecyclingSpot: NSObject, MKAnnotation {
    var address: String?
    var coordinateOfSpot: CLLocationCoordinate2D?
    var descriptionOfSpot: String?
    var distanceFromYourLocation: Double?
    
    var title: String? {
        return address ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        return coordinateOfSpot ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    var subtitle: String? {
        return description
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
