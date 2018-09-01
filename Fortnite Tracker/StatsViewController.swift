//
//  StatsViewController.swift
//  Fortnite Tracker
//
//  Created by Noah Eaton on 9/1/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    var winText : String?
    
    var kdText  : String?
    
    var killStat : String?
    
    @IBOutlet weak var WinLabel: UILabel!
    
    @IBOutlet weak var kdLabel: UILabel!
    
    @IBOutlet weak var killLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WinLabel.text = winText
        kdLabel.text = kdText
        killLabel.text = killStat
    }
    

}
