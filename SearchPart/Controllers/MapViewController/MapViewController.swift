
//- MARK: Map controller, Main operations are here

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SWRevealViewController

class MapViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var panelView: UIView!
    var mapView: GMSMapView?
    var placesClient: GMSPlacesClient!
    var currentPlace: Place?
    var tappedMarker = GMSMarker()
    var tappedPlace: Place?
    var searchResults: [Place] = []
    var selectedPic: UIImage?
    var infoWindow = mapMarkerInfoWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    let offsetToMarker: CGFloat = -100;
    let defaultAddress = ["lat" : 60.220629, "lon" : 24.803277]
    let locationMgr = CLLocationManager()
    
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        showAlertToChoosePic()
    }
    
    func showAlertToChoosePic() {
        let alertVC = UIAlertController(title: "", message: "Please select one Action", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            alertVC.dismiss(animated: true, completion: nil)
            
        }
        let openCamaraAction = UIAlertAction(title: "Take new photo", style: .default) { (openCameraAction) in
            // Open the camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose photos from library", style: .default) { (choosePhotoAction) in
            // Open the library to choose photo
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(openCamaraAction)
        alertVC.addAction(choosePhotoAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.selectedPic = selectedImage
        performSegue(withIdentifier: "showPicView", sender: self.selectedPic)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //- MARK: show default address whenever user open this page
        let camera = GMSCameraPosition.camera(withLatitude: defaultAddress["lat"]!, longitude: defaultAddress["lon"]!, zoom: 8)
        
        placesClient = GMSPlacesClient.shared()
        mapView = GMSMapView.map(withFrame:  UIScreen.main.bounds, camera: camera)
        mapView?.center = self.view.center
        mapView?.delegate = self
        locationMgr.delegate = self
        
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"HomePage_MyStroke")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showPlacesList))
       
        self.navigationItem.title = "Battery Bay"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.addSubview(mapView!)
        view.bringSubview(toFront: panelView)

        loadLocation(keyword: nil)
        
        let showAvaliableSpotsReceiver = NSNotification.Name(rawValue:"showAvaliableSpots")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAvaliableSpotsBaseOnItem(noty: )), name: showAvaliableSpotsReceiver, object: nil)
        
        //- MARK: initialize side bar
        if let revealVC = revealViewController() {
            revealVC.rearViewRevealWidth = 280
            navigationItem.leftBarButtonItem?.target = revealVC
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
    
    //- MARK: Refresh map based on keywords that is related to item's category
    @objc func refreshAvaliableSpotsBaseOnItem(noty: Notification) -> Void {

        if let keyword = noty.object{
            mapView?.clear()
            loadLocation(keyword: keyword as! String)
        }
    }
    
    func getAvaliableRecycleSpots(keyword: String?) -> Void {
        var keyword = keyword
        if keyword == nil {
            keyword = Constants.DEFAULT_SEARCH_KEYWORD
        }

        let url = getSearchUrl(searchText: keyword!)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
      
            if let error = error {
                print("Failure! \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
              
                if let data = data, let jsonDictionary = self.parse(json: data) {
                    self.searchResults = self.parse(dictionary: jsonDictionary)
      
                    DispatchQueue.main.async {
                        self.searchResults.sort(by: { Double($0.distance!) < Double($1.distance!) })
                    }
                    return
                }
            } else {
                print("Fail! \(response!)")
            }
        })
        dataTask.resume()
    }
    
    func getSearchUrl(searchText: String) -> URL{
        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
  
        let latitude = String(format: "%f", (currentPlace?.coordinate.latitude)!)
        let longitude = String(format: "%f", (currentPlace?.coordinate.longitude)!)
        
        let urlString = String(format:
            Constants.PLACES_SEARCH_URL, escapedSearchText, latitude, longitude, Constants.DEFAULT_SEARCH_RADIUS, Constants.PLACES_API_KEY)
   
        let url = URL(string: urlString)
        print("url ==> \(url!)")
        return url!
    }
    
    func parse(json data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    //- MARK: parse json which returned from google map web services
    func parse(dictionary: [String: Any]) -> [Place]{
        guard let status = dictionary["status"] as? String, status == "OK"  else {
            print("Invalid status")
            return []
        }
        
        guard let array = dictionary["results"] as? [Any], array.count > 0  else {
            print("Expected 'results' array or Array is empty")
            return []
        }
        
        var searchResults: [Place] = []
        for resultDict in array {
            
            var place:Place
            if let resultDict = resultDict as? [String : Any] {
                
                if let name = resultDict["name"] as? String, let place_id = resultDict["place_id"] as? String, let geometryDict = resultDict["geometry"] as? [String : Any] {
                    if let locationDict = geometryDict["location"] as? [String : Any] {
                        if let lat = locationDict["lat"] as? Double, let lng = locationDict["lng"] as? Double {
                            
                            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            
                            place = Place(name: name, place_id: place_id, locationCoordinate: coordinate, isRecycleSpot: true)
                            
                            if let rating = resultDict["rating"] as? Double {
                                place.rating = rating
                            }
                            
                            if let vicinity = resultDict["formatted_address"] as? String {
                                place.vicinity = vicinity
                            }
                            
                            if let hoursDict = resultDict["opening_hours"] as? [String : Any] {
                                if let openNow = hoursDict["open_now"] as? Bool {
                                    place.open_now = openNow
                                }
                            }
                            
                            let currentLocation: CLLocation =  CLLocation(latitude: (currentPlace?.coordinate.latitude)!, longitude: ((currentPlace?.coordinate.longitude)!))
                            let storeLocation: CLLocation =  CLLocation(latitude: lat, longitude: lng)
                            place.distance = calculateDistanceToStore(nowCoordinate: currentLocation, storeCoordinate: storeLocation)
                            
                            createMarker(placeWhere: place)
                            searchResults.append(place)
                        }
                    }
                }
            }
        }
        return searchResults
    }
    
    //- MARK: Calculate Distance from user's cuurent location to a certain spots
    func calculateDistanceToStore(nowCoordinate: CLLocation, storeCoordinate: CLLocation) -> Double? {
        let distanceInMeter = nowCoordinate.distance(from: storeCoordinate)
        let distanceinKiloMeter = distanceInMeter/1000
        return distanceinKiloMeter
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func locationBtnTap(_ sender: UIButton) {
        loadLocation(keyword: nil)
    }
    
    func loadLocation(keyword: String?) -> Void {
        
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.mapView?.clear()
            if let placeLikelihoodList = placeLikelihoodList {
                if placeLikelihoodList.likelihoods.count > 0 {
                    let gmsPlace = (placeLikelihoodList.likelihoods.last?.place)!
                    
                    self.currentPlace = Place(name: "You are Here", place_id: gmsPlace.placeID, locationCoordinate: gmsPlace.coordinate, isRecycleSpot: false)
                }
                
                self.setMapCamera(toWhere: (self.currentPlace?.coordinate)!)
                self.createMarker(placeWhere: self.currentPlace!)
                self.getAvaliableRecycleSpots(keyword: keyword)
            } else {
                self.currentPlace = Place(name: "Default Address", place_id: "NoId", locationCoordinate: CLLocationCoordinate2DMake(self.defaultAddress["lat"]!, self.defaultAddress["lon"]!), isRecycleSpot: false)
                self.setMapCamera(toWhere: (self.currentPlace?.coordinate)!)
                self.createMarker(placeWhere: self.currentPlace!)
                self.getAvaliableRecycleSpots(keyword: keyword)
            }
        })
    }
    
    func createMarker(placeWhere: Place) {
        
        DispatchQueue.main.async {
            let marker = GMSMarker()
            if (placeWhere.isRecycleSpot) {
                marker.icon = UIImage(named: "map-marker-blue-128")
            }
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: -0.5)
            marker.opacity = 0.8
            marker.userData = placeWhere
            marker.position = placeWhere.coordinate
            marker.map = self.mapView
        }
        
    }

    @objc func showPlacesList() {
        if searchResults.count > 0 {
            performSegue(withIdentifier: "showPlacesList", sender: self)
        }
    }
    
    private func setMapCamera(toWhere: CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: toWhere, zoom: 15))
        CATransaction.commit()
    }
    
    @objc func goRecycleSpot(_ sender: Any?) {
        performSegue(withIdentifier: "showRecycleSpotDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecycleSpotDetails" {
            let controller = segue.destination as! PlaceDetailViewController
            //let place = searchResults[0]
            controller.place = tappedPlace!

        } else if segue.identifier == "showPlacesList" {
            let controller = segue.destination as! PlacesViewController
            controller.searchResults = self.searchResults
            print("发送出去的showPlacesList \(searchResults.count)")
        } else if segue.identifier == "showPicView" {
            let controller = segue.destination as! PicViewController
            controller.selectedUIImage = self.selectedPic
            print("发送出去的selectedPic \(self.selectedPic == nil)")
        }
        
    }
    
}

extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // create custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        tappedMarker = marker
        tappedPlace = (marker.userData as! Place)
        let center = (marker.userData as! Place).coordinate

        if (marker.userData as! Place).isRecycleSpot {
            infoWindow.removeFromSuperview()
            infoWindow = mapMarkerInfoWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            infoWindow.Name.text = (marker.userData as! Place).name
            if let nearby = (marker.userData as! Place).vicinity {
                infoWindow.AddressLabel.text = "\(nearby)"
            } else {
                infoWindow.AddressLabel.text = "Unkonw Address"
            }
            infoWindow.center = mapView.projection.point(for: center)
            
            infoWindow.center.y += offsetToMarker
            infoWindow.onlyButton.addTarget(self, action: #selector(goRecycleSpot(_:)), for: .touchUpInside)
            
            self.view.addSubview(infoWindow)
        }

        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if (tappedMarker.userData != nil){
            let center = (tappedMarker.userData as! Place).coordinate
            infoWindow.center = mapView.projection.point(for: center)
            infoWindow.center.y += offsetToMarker
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
}
