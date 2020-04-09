//
//  ViewController.swift
//  maps0.1
//
//  Created by Prateek Bhatt on 1/13/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activateBluetoothLabel: UILabel!
    @IBOutlet weak var keyStateSwitch: UISwitch!
    
    
    fileprivate let locationManager: CLLocationManager = {
       let manager = CLLocationManager()
       manager.requestWhenInUseAuthorization()
       return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpMapView()
        
        self.uiSetup()
        self.bleSetup()
    }
    
    // BLE stuff
    let bleService = BLEService()
    
    private func uiSetup() {
         let layer = self.activateBluetoothLabel.layer
         layer.cornerRadius = 5.0
     }
    
    private func bleSetup() {
        self.bleService.delegate = self
    }
    
    private func providersSetup() {
        self.bleService.electronicKeyStateProvider = { [unowned self] in
            return self.keyStateSwitch.isOn
        }
    }
    // END BLE stuff
    
    
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
    
    
    
    // MARK: Actions

    @IBAction func keyStateDidChange(_ sender: UISwitch) {
        if sender.isOn {
            self.bleService.activate()
        } else {
            self.bleService.deactivate()
        }
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
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
     }
}

// MARK: - BLEServiceDelegate

extension ViewController: BLEServiceDelegate {
    func bleService(_ service: BLEService, bluetoothStateDidChange isActive: Bool) {
        self.keyStateSwitch.isEnabled = isActive
        self.activateBluetoothLabel.isHidden = isActive
    }
}

