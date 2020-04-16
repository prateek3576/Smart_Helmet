//
//  HomeViewController.swift
//  Concushion
//
//  Created by Prateek Bhatt on 2/25/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit
import CoreBluetooth
import Alamofire


class HomeViewController: UIViewController, CBCentralManagerDelegate {
    
    private var centralManager : CBCentralManager!
    
    var ip = "http://13.59.245.151:3031/"
    
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
            
            sendStartTripMsg()
        } else {
            textLabel.text = "Start Trip"
             
            sendEndTripMsg()
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
    
    func resetCrash() {
        let url = ip + "resetcrash"
        print("resetting crash")
         AF.request(url, method: .get).response { response in
                 print(response)
         }
    }
    
   
       func sendStartTripMsg(){
            let url = ip + "startTrip"
            print("sending Start Trip request")
            AF.request(url, method: .get).response { response in
                    print(response)
            }
        
            
               
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
//                let randomNumber = Int.random(in: 1...20)
//                print("Number: \(randomNumber)")
               
           
                AF.request(self.ip+"pollforcrash", method: .get).response { responseObject in
                    print(responseObject)
                     if let statusCode = responseObject.response?.statusCode {
                           if statusCode == 200 {
                               // crash
                                print("crash")
                                timer.invalidate()
                            self.performSegue(withIdentifier: "crashSegue", sender: nil)
                            
                            self.resetCrash()
                            
                           } else {
                                print("no crash")
                            }
                        }
                }
                
//                if randomNumber == 10 {
//                    timer.invalidate()
//                }
            }
    }
    
    
        func sendEndTripMsg(){
           let url = ip + "endTrip"
            print("Initating End Trip Request")
           AF.request(url, method: .get).response { response in
                   print(response)
           }
        }
    
        func sendCrashPoll(){
            let url = ip + "pollforcrash"
            print("polling for crash request")
            AF.request(url, method: .get).response { response in
                    print(response)
            }
        }
    

    
}
