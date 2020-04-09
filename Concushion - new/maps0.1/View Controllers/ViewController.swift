//
//  ViewController.swift
//  maps0.1
//
//  Created by Prateek Bhatt on 1/13/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit
import MapKit
import CoreData

var address = ""
var lastAddress = Location()
// Core Data


class ViewController: UIViewController {
    var managedObjectContext:NSManagedObjectContext!
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
        setUpMapView()
    }
    
    
    func setUpMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        
        currentLocation()
    }
    
    //MARK: - Helper Method
    func currentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
    }
}

//MARK: - CLLocationManagerDelegate Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                //                    if let locationName = placeMark.name {
                //                        //print("Location Name: \(locationName)")
                //                        address = address + locationName + "\n"
                //                    }
                address = " "
                if let substreet = placeMark.subThoroughfare {
                    print("Street:\(substreet)")
                    address = address + substreet + " "
                }
                
                if let street = placeMark.thoroughfare {
                    print("Street:\(street)")
                    address = address + street + "\n"
                }
                
                // City
                if let subcity = placeMark.subLocality {
                    //print("City: \(subcity)")
                    address = address + subcity + "\n"
                }
                
                // City
                if let city = placeMark.locality {
                    // print("City: "+city)
                    address = address + city + "\n"
                }
                
                
                
                // Zip code
                if let zip = placeMark.postalCode {
                    //print("Zip"+zip)
                    address = address + zip + "\n"
                }
                // Country
                if let country = placeMark.country {
                    //print("Country"+country)
                    address = address + country + "\n"
                }
                
                print(address)
                let locationItem = Location(context: self.managedObjectContext)
                locationItem.address = address
                lastAddress = locationItem
                
                // Save address to CareData
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Could not save data. \(error.localizedDescription)")
                }
                
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}

