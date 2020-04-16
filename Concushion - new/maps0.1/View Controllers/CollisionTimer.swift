//
//  CollisionTimer.swift
//  Concushion
//
//  Created by Caleb Foglio on 2/28/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import CoreData
import Alamofire

class CollisionTimer: UIViewController, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result){
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed to send")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func sendMsg(number: String, address: String){
//        let messageVC = MFMessageComposeViewController()
//
//        messageVC.body = "Caleb has been in a bicycle accident. His last know address was: "
//        messageVC.recipients = [number]
//        messageVC.messageComposeDelegate = self
        
        // Twilio
        //let msg = "Caleb has been in a bicycle accident. His last know address was: \(address)"

        let headers: HTTPHeaders = [
           "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters = [
           "To": number,
           "Body": "Caleb has been in a bicycle accident. His last know address was: \n\n" + address
        ]
        
        let url = "https://9cf74ab9.ngrok.io/sms"

        AF.request(url, method: .post, parameters: parameters, headers: headers).response { response in
               print(response)
           
        }
        
        let piParameters: [String: Any] = [
            "name" : "Caleb",
            "location" : address,
            "date" : "4/13/20",
            "contact": number
        ]

        AF.request("http://13.59.245.151:3031/crash", method: .post, parameters: piParameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
            }
        
//        self.present(messageVC, animated: true) {
            self.makeCall(number: number)
//        }
    }
    
    func makeCall(number: String){
        print("Call made to: \(number)")
        if let url = URL(string: "tel://\(number)") {
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)}
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Core Data
    var managedObjectContext:NSManagedObjectContext!
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    var cancelLabel: UILabel!
    var count = 10.0
    var timer = Timer()
    var cancelled = false
    @IBOutlet var progView: UIProgressView!
    var progCount: Float = 1.00
    
    override func viewDidLoad(){
        //createTimer()
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        cancelButton.setTitle("", for: UIControl.State.normal)
    }
    
    @objc func updateTimer() {
        // Cancel button is pressed
        if (cancelled){
            timerLabel.text = "Emergency Notification Cancelled"
            timer.invalidate()
        }
        // Still counting down
        else if (count > 0){
            count-=0.1
            if progCount > 0 {progCount -= 0.01}
            let c:String = String(format:"%.1f", count)
            print("\nTime: \(c)")
            timerLabel.text = "Time Remaining: \(c)"
            progView.setProgress(progCount, animated: true)
        }
        // Timer reached zero, sending emergency mnessage
        else{
            timerLabel.text = "Notifying Emergency Contact..."
            timer.invalidate()
            
            var contacts = [Contact]()
            var location = [Location]()
            var number: String
            var address: String
            
            let contactFetchRequest:NSFetchRequest<Contact> = Contact.fetchRequest()
            let locationFetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
            
            do{
                contacts = try managedObjectContext.fetch(contactFetchRequest)
                number = contacts[0].plainNumber!
                
                location = try managedObjectContext.fetch(locationFetchRequest)
                address = location[0].address!
                print("Loaded: \(address)")
                
                // Filters out spaces, dashes, and parenthesis
                let chars: Set<Character> = [" ", "(", ")", "-", "O"]
                number.removeAll(where: { chars.contains($0) })
                
                // Prompt emergency message and call
                sendMsg(number: number, address: address)
                //makeCall(number: number)
                
            } catch{
                print("Could not load data from Core Data \(error.localizedDescription)")
            }
        }
        
    }
    
    func createTimer() {
      // Creates new timer instance
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        count = 10.0
        progCount = 1.0
        progView.setProgress(progCount, animated: false)
        cancelButton.setTitle("PRESS TO CANCEL", for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        cancelButton.backgroundColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.8)
        cancelButton.layer.cornerRadius = 25
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        createTimer()
        print("\nTime: 10.0")
        cancelled = false

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelled = true
        cancelButton.setTitle("", for: UIControl.State.normal)
        cancelButton.backgroundColor = UIColor.clear
    }
    
}
