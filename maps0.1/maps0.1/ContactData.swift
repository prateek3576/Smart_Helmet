//
//  contactData.swift
//  maps0.1
//
//  Created by Caleb Foglio on 2/5/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import Foundation

struct ContactData {
    let name: String
    //let image: String
}

extension ContactData {
    static func createContacts() -> [ContactData]{
        return [ContactData(name: "Prateek Bhatt")]
    }
}
