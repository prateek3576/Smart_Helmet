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

    @IBAction func showContact(_ sender: Any) {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func callNumber(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "tel://4125197002")! as URL)
    }
    @IBOutlet weak var lblNumber: UILabel!
    // MARK: Delegate method CNContectPickerDelegate
       func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
           print(contact.phoneNumbers)
           let numbers = contact.phoneNumbers.first
           print((numbers?.value)?.stringValue ?? "")
           
           self.lblNumber.text = " Contact No. \((numbers?.value)?.stringValue ?? "")"
             
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
