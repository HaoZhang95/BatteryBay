
//- MARK: Show avaliable places info in a table view

import UIKit
import CoreLocation

class PlacesViewController: UIViewController {
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
    }
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    var searchResults: [Place] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self

        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        tableView.rowHeight = 100
        
        print("searchResults --->")
        print(searchResults.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        getLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        updatingLocation = true
    }
    
    func showLocationServicesDeniedAlert() {
        let alertTitle = "Location Services Disabled"
        let alertMessage = "Please enable location services for this app in Settings."
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message:
            "There was an error reading from the iTunes Store. Please try again.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecycleSpotDetailsFromList" {
            let controller = segue.destination as! PlaceDetailViewController
            let indexPath: IndexPath = sender as! IndexPath
            let place = searchResults[indexPath.item]
            controller.place = place
            
            print("********\(indexPath)")
            print("********\(place)")
        }
    }
    
  
    
    
    
}

extension PlacesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
        showLocationServicesDeniedAlert()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        location = newLocation
        stopLocationManager()
    }
}


extension PlacesViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchResults.count == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            cell.nameLabel.text = "(Nothing found)"
            cell.addressLabel.text = "No avaliable recycle spots around you"
            cell.distanceLabel.text = "-1 Km"
            cell.openNowLabel.text = ""
            cell.starRatingView.isHidden = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult:Place = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            cell.addressLabel.text = searchResult.vicinity
            if let rating = searchResult.rating {
                cell.starRatingView.rating = rating
            } else {
                cell.starRatingView.isHidden = true
            }
            
            if let distanceInKm = searchResult.distance {
                cell.distanceLabel.text = Util.formatDistanceText(distanceinKiloMeter: distanceInKm)
            }
            
            
            if let openNow = searchResult.open_now {
                if openNow {
                    cell.openNowLabel.text = "OPEN"
                    cell.openNowLabel.textColor = UIColor(hue: 0.2778, saturation: 0.93, brightness: 0.62, alpha: 1.0)
                } else {
                    cell.openNowLabel.text = "CLOSED"
                    cell.openNowLabel.textColor = UIColor.red
                }
            }

            
            return cell
        }
    }
}

extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if searchResults.count > 0 {
            performSegue(withIdentifier: "showRecycleSpotDetailsFromList", sender: indexPath)
        }
    }
}

