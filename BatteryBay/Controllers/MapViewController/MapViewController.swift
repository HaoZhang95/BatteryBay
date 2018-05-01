//
//  MapViewController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 01/05/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recyclingSpots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RecyclingSpotCell
        
        cell.spot = recyclingSpots[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recyclingSpotCollectionView.frame.width - 15, height: recyclingSpotCollectionView.frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        recyclingSpots[indexPath.item].mapItem().openInMaps(launchOptions: launchOptions)
    }
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        
        currentUserLocation = location
    }
}

class MapViewController: UIViewController {
    
    private let userLocationManager = CLLocationManager()
    let cellID = "cellID"
    let regionRadius: CLLocationDistance = 700
    var currentUserLocation: CLLocation? {
        didSet {
            
            guard let currentLocation = currentUserLocation else { return }
            for spot in recyclingSpots {
                let distance = currentLocation.distance(from: CLLocation(latitude: spot.coordinateOfSpot!.latitude, longitude: spot.coordinateOfSpot!.longitude)) / 1000
                spot.distanceFromYourLocation = Double((round(distance * 100) / 100))
            }
            
            self.recyclingSpots.sort { (firstSpot, secondSpot) -> Bool in
                firstSpot.distanceFromYourLocation! < secondSpot.distanceFromYourLocation!
            }
            
            recyclingSpotCollectionView.reloadData()
        }
    }
    var recyclingSpots = [RecyclingSpot]()
    
    let recyclingSpotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cl.isPagingEnabled = true
        cl.backgroundColor = .clear
        cl.showsHorizontalScrollIndicator = false
        return cl
    }()
    
    let recyclingSpotLbl: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Nearest recycling spots:"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsCompass = true
        let span = MKCoordinateSpanMake(0.07, 0.07)
        let initialLoc = CLLocationCoordinate2D(latitude: 60.171410, longitude: 24.941159)
        let region = MKCoordinateRegion(center: initialLoc, span: span)
        map.setRegion(region, animated: true)
        
        return map
    }()
    
    let titleView: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Recycling Spots"
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(recyclingSpotLbl)
        view.addSubview(recyclingSpotCollectionView)
        
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        recyclingSpotLbl.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        recyclingSpotCollectionView.anchor(top: recyclingSpotLbl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        recyclingSpotCollectionView.delegate = self
        recyclingSpotCollectionView.dataSource = self
        
        recyclingSpotCollectionView.register(RecyclingSpotCell.self, forCellWithReuseIdentifier: cellID)
        
        userLocationManager.delegate = self
        userLocationManager.requestWhenInUseAuthorization()
        userLocationManager.startUpdatingLocation()
        
        setupRecyclingSpotDatasource()
        
        setupNavBar()
    }
    
    private func setupRecyclingSpotDatasource() {
        let firstSpot = RecyclingSpot()
        firstSpot.address = "Leppävaarankatu 3-9"
        firstSpot.coordinateOfSpot = CLLocationCoordinate2D(latitude: 60.218564, longitude: 24.811982)
        firstSpot.descriptionOfSpot = "Some desctiption"
        
        let secondSpot = RecyclingSpot()
        secondSpot.address = "Rastaspuistontie 1"
        secondSpot.coordinateOfSpot = CLLocationCoordinate2D(latitude: 60.231065, longitude: 24.778366)
        secondSpot.descriptionOfSpot = "This place is close-by"
        
        
        let thirdSpot = RecyclingSpot()
        thirdSpot.address = "Espoontie 21, 02740 Espoo"
        thirdSpot.coordinateOfSpot = CLLocationCoordinate2D(latitude: 60.218420, longitude: 24.663210)
        thirdSpot.descriptionOfSpot = "Some desctiption"
        
        let fourthSpot = RecyclingSpot()
        fourthSpot.address = "Piispansilta 11, 02230 Espoo"
        fourthSpot.coordinateOfSpot = CLLocationCoordinate2D(latitude: 60.162571, longitude: 24.738408)
        fourthSpot.descriptionOfSpot = "Some desctiption"
        
        recyclingSpots.append(firstSpot)
        recyclingSpots.append(secondSpot)
        recyclingSpots.append(thirdSpot)
        recyclingSpots.append(fourthSpot)
        
        mapView.addAnnotations(recyclingSpots)
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleView

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "location"), style: .plain, target: self, action: #selector(handleCenterUserOnMap))
    }
    
    @objc private func handleCenterUserOnMap() {
        
        guard let currentUserLocation = currentUserLocation else { return }
        
        let center = CLLocationCoordinate2D(latitude: currentUserLocation.coordinate.latitude, longitude: currentUserLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = recyclingSpotCollectionView.contentOffset
        visibleRect.size = recyclingSpotCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = recyclingSpotCollectionView.indexPathForItem(at: visiblePoint)!
        
        let location = recyclingSpots[visibleIndexPath.item].coordinate
        let spotLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        centerMapOnLocation(location: spotLocation)
        
    }
    
    //center the selected annotation to the map
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}











