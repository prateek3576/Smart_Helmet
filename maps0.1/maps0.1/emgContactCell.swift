//
//  contactCell.swift
//  maps0.1
//
//  Created by Caleb Foglio on 2/4/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI


class emgContactCell: UITableViewCell {
    
    
    
    
   /* let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let lab = UILabel()
        lab.text = "Prateek Bhatt"
        return lab
    }()*/
    
    
    
    
//    let imageView: UIImageView = {
//        let img = UIImage(named: "test.png")
//        let imgView = UIImageView(image: img)
//        return imgView
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
