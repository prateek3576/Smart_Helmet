//
//  HomeViewController.swift
//  Concushion
//
//  Created by Prateek Bhatt on 2/25/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func stateSwitch(_ sender: Any) {
        if stateSwitch.isOn {
            textLabel.text = "End Trip"
        } else {
            textLabel.text = "Start Trip"
        }
        
    }
    @IBOutlet weak var stateSwitch: UISwitch!
    
    @IBOutlet weak var textLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         /*stateSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)*/
    }
    
    
    
    /*@objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            textLabel.text = "The Switch is On"
        } else {
            textLabel.text = "The Switch is Off"
        }
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
