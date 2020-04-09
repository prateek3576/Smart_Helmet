//
//  contactData.swift
//  maps0.1
//
//  Created by Caleb Foglio on 2/5/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Contacts

class ContactData: NSManagedObject{
    
    @NSManaged var name: String
    @NSManaged var number: String
    @NSManaged var image: UIImage
    @NSManaged var contact: CNContact
    
    enum CodingKeys: String, CodingKey {
        case name
        case number
        case image
        case contact
    }
    
//    init(name: String, number: String, image: UIImage, contact: CNContact){
//        self.name = name
//        self.number = number
//        self.image = image
//        self.contact = contact
//    }

    
}
