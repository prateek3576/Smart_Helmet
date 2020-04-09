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
import CoreData

//struct contactData {
//    let name: String
//    let image: UIImage
//    let number: String
//}

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    var contacts = [Contact]()
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setUpTableView()
        loadData()
    }
    
    func loadData(){
        let contactFetchRequest:NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do{
            contacts = try managedObjectContext.fetch(contactFetchRequest)
            self.tableView.reloadData()
        } catch{
            print("Could not load data from Core Data \(error.localizedDescription)")
        }
    }
    
    func setUpTableView (){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
    }
    
    // Number of cells/section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Cell spacing
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        return view
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
        cell?.textLabel?.text = contacts[indexPath.section].name
        if (contacts[indexPath.section].image == nil){
            cell?.imageView?.image = UIImage(named: "icons8-happy-96.png")
        }
        else{
            cell?.imageView?.image = UIImage(data: contacts[indexPath.section].image!)
        }
        cell?.detailTextLabel?.text = "\(contacts[indexPath.section].number ?? "")"
        
        // Make name bold
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell?.textLabel?.font.pointSize)!)
        
        //print(cell?.detailTextLabel?.text as Any)
        cell?.layer.cornerRadius = 12
        cell?.layer.masksToBounds = true
        cell?.layer.frame = CGRect(x: (cell?.layer.frame.maxX)!, y: (cell?.layer.frame.maxY)!, width: ((cell?.layer.frame.width)! - CGFloat(5)), height: (cell?.layer.frame.height)!)
        if (self.traitCollection.userInterfaceStyle == .dark){
            cell?.layer.shadowColor = UIColor.white.cgColor
        }
        else{
            cell?.layer.shadowColor = UIColor.black.cgColor
        }
        cell?.layer.shadowOffset = CGSize(width: 0,height: 0)
        cell?.layer.shadowOpacity = 0.23
        cell?.layer.shadowRadius = 12
        
        
//        if (self.traitCollection.userInterfaceStyle == .dark){
//            cell?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
//        }
//        else{
//            cell?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
//        }
        return cell!
    }
    
    // Size of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // Number of sections in each cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.count
    }
    
    // + button pressed
    @IBAction func addButtonPushed(_ sender: Any) {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    // Edit button pressed
    @IBAction func editButtonPressed(_ sender: Any) {
        if (tableView.isEditing == true){
            tableView.isEditing = false
            editButton.title = "Edit"
        }
        else{
            tableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    
    
    // Cancelled adding new contact
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Actually choosing contact
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//       // print(contact.phoneNumbers)
//        addCell(contact) // Adds new contact to table
//    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        var num: CNLabeledValue<CNPhoneNumber>
        num = contactProperty.contact.phoneNumbers.first!
        for i in contactProperty.contact.phoneNumbers {
            if (i.identifier == contactProperty.identifier){
                num = i
                break
            }
        }
        addCell(contactProperty.contact, number: num.value.stringValue, label: contactProperty.label ?? "phone")
    }
    
    // adds new cell
    func addCell(_ contact: CNContact, number: String, label: String) {

        // Core data stuff

        let contactItem = Contact(context: managedObjectContext)
        
        if contact.imageDataAvailable {

            // Create new contact object in Core Data and add cell in table
            contactItem.name = contact.givenName + " " + contact.familyName
            contactItem.plainNumber = number
            //contactItem.contact = Data(data: contact)
            //contactItem.number =  (contact.phoneNumbers.first?.value.stringValue)!
            contactItem.number = "\(number) - \(label)"
            contactItem.image = contact.thumbnailImageData
            contacts.append(contactItem)
            // Acually saves it
            do{
                try self.managedObjectContext.save()
            } catch {
                print("Could not save data. \(error.localizedDescription)")
            }

            //contacts.append(ContactData(name: contact.givenName + " " + contact.familyName), image: UIImage(data: contact.thumbnailImageData!)!, number: (contact.phoneNumbers.first?.value.stringValue)!))
        }
        else{

            // Create new contact object in Core Data and add cell in table
            contactItem.name = contact.givenName + " " + contact.familyName
            contactItem.plainNumber = number
            //contactItem.contact = contact
            //contactItem.number =  (contact.phoneNumbers.first?.value.stringValue)!
            contactItem.number = "\(number) - \(label)"
            contactItem.image = nil
            contacts.append(contactItem)
            
            
            // Acually saves it
            do{
                try self.managedObjectContext.save()
            } catch {
                print("Could not save data. \(error.localizedDescription)")
            }

           // contacts.append(ContactData(name: contact.givenName + " " + contact.familyName, image: UIImage(named: "icons8-happy-96.png")!, number: (contact.phoneNumbers.first?.value.stringValue)!))
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
        var number = contacts[indexPath.section].plainNumber!

        // Filters out spaces, dashes, and parenthesis
        let chars: Set<Character> = [" ", "(", ")", "-"]
        number.removeAll(where: { chars.contains($0) })

        // Calling...
        callContact(number)
    }

    // Deleting from list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let cont = contacts[indexPath.section]
            managedObjectContext.delete(cont)
            contacts.remove(at: indexPath.section)
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
           
        }
    }
    
    // Change ordering of cells
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }

//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.contacts[sourceIndexPath.row]
//        let movedSection = self.contacts[sourceIndexPath.section]
//        contacts.remove(at: sourceIndexPath.row)
//        contacts.remove(at: sourceIndexPath.section)
//        contacts.insert(movedObject, at: destinationIndexPath.row)
//        contacts.insert(movedSection, at: destinationIndexPath.section)
    }
    
//
}
