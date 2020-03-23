//
//  ContactViewController.swift
//  maps0.1
//
//  Created by Caleb Foglio on 2/4/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

// Controller for the tableView of emergency contacts tab

import Foundation
import UIKit
import ContactsUI

struct contactData {
    let name: String
    let image: UIImage
    let number: String
}

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {
    
    @IBOutlet var tableView: UITableView!
    var contacts = [contactData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    func setUpTableView (){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    // Each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        struct staticVariable { static var tableIdentifier = "TableIdentifier" }
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(
            withIdentifier: staticVariable.tableIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "contactCell")
        }
        
        // Add attributes to new table cell
        cell?.textLabel?.text = contacts[indexPath.row].name
        cell?.imageView?.image = contacts[indexPath.row].image
        cell?.detailTextLabel?.text = contacts[indexPath.row].number
        
        // Make name bold
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell?.textLabel?.font.pointSize)!)
        
        print("Num:  ")
        //print(cell?.detailTextLabel?.text as Any)
        return cell!
    }
    
    // Size of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // Number of sections in each cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // + button pressed
    @IBAction func addButtonPushed(_ sender: Any) {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    // Cancelled adding new contact
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Actually choosing contact
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print(contact.phoneNumbers)
        addCell(contact)
        
    }
    
    // adds new cell
    func addCell(_ contact: CNContact) {
        
        if contact.imageDataAvailable {
            contacts.append(contactData(name: contact.givenName + " " + contact.familyName, image: UIImage(data: contact.thumbnailImageData!)!, number: (contact.phoneNumbers.first?.value.stringValue)!))
        }
        else{
            contacts.append(contactData(name: contact.givenName + " " + contact.familyName, image: UIImage(named: "icons8-happy-96.png")!, number: (contact.phoneNumbers.first?.value.stringValue)!))
        }
        
        tableView.reloadData() // Refresh table cells
    }
    
    // Calls number
    func callContact(_ number: String){
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)}
    }
    
    // When emergency contact is selcted from list in order to initiate call
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var number = contacts[indexPath.row].number
        
        // Filters out spaces, dashes, and parenthesis
        let chars: Set<Character> = [" ", "(", ")", "-"]
        number.removeAll(where: { chars.contains($0) })
        
        // Calling...
        callContact(number)
    }
    
    // Deleting from list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}
