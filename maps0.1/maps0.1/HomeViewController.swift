//
//  HomeViewController.swift
//  Concushion
//
//  Created by Prateek Bhatt on 2/25/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController, CBCentralManagerDelegate {
    
    private var centralManager : CBCentralManager!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is On")
            // centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not active")
        }
        
    }
    
    @IBAction func stateSwitch(_ sender: Any) {
        if stateSwitch.isOn {
            textLabel.text = "End Trip"
            addressLabel.text = address
        } else {
            textLabel.text = "Start Trip"
        }
        
    }
    @IBOutlet weak var stateSwitch: UISwitch!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("\nName   : \(peripheral.name ?? "(No name)")")
        print("RSSI   : \(RSSI)")
        for ad in advertisementData {
            print("AD Data: \(ad)")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
