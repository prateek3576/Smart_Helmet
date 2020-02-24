//
//  FrontViewController.swift
//  maps0.1
//
//  Created by Prateek Bhatt on 1/13/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit
import ContactsUI

class FrontViewController: UIViewController,CNContactPickerDelegate {

    var chosenNum = String()
    
    @IBAction func pickContact(_ sender: Any) {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func callNumber(_ sender: Any) {
        if let url = URL(string: "tel://\(chosenNum)") {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)}
    }
    @IBOutlet weak var lblNumber: UILabel!
    // MARK: Delegate method CNContectPickerDelegate
       func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
           print(contact.phoneNumbers)
           let numbers = contact.phoneNumbers.first
           print((numbers?.value)?.stringValue ?? "")
           
           self.lblNumber.text = " Contact No. \((numbers?.value)?.stringValue ?? "")"
            chosenNum = (numbers?.value.stringValue)!
            print(chosenNum)
             
       }

       func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
           self.dismiss(animated: true, completion: nil)
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
