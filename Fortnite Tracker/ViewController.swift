//
//  ViewController.swift
//  Fortnite Tracker
//
//  Created by Noah Eaton on 8/27/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var soloWins: UILabel!
    @IBOutlet weak var duoWinsLabel: UILabel!
    @IBOutlet weak var squadWinsLabel: UILabel!
    @IBOutlet weak var totalWinsLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var duoButton: UIButton!
    @IBOutlet weak var squadButton: UIButton!
    
    
    
    var userSoloWins = ""
    var duoWins = ""
    var squadWins = ""
    
    var kdSolo = ""
    var kdDuo = ""
    var kdSquad = ""
    
    var killSolo = ""
    var killDuo = ""
    var killSquad = ""
    
    var username = ""
    
    let platform = ["Choose a platform", "pc", "xb1", "ps4"]
    let platformDisplayed = ["Choose a platform:", "PC", "Xbox", "PS4"]
    
    var platformChosen = ""
    
    @IBOutlet weak var platformPicker: UIPickerView!
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return platform.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return platformDisplayed[row]
    }
    
    //Tell the picker what to do with currency
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(platform[row])
        platformChosen = platform[row]
        
        if platformChosen == "Choose a platform" {
            addButton.isEnabled = false
        }
            
        else {
            addButton.isEnabled = true
        }

    }
    

    let apiKey = ""
    
    var userID : JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        platformPicker.delegate  = self
        platformPicker.dataSource = self
        
        
        addButton.isEnabled = false
        platformPicker.selectRow(0, inComponent: 0, animated:true)
        
        
        
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
       
            //create an alert to create a new reminder
            let alert = UIAlertController(title: "Users Stats", message: "", preferredStyle: .alert)
            
            //give it an action
            let action = UIAlertAction(title: "View Stats", style: .default) { (action) in
                
                let ticker = textField.text!
                let header : [String : String] = ["X-Fortnite-API-Version" : "v1.1","Authorization" : self.apiKey]
                self.getUsersID(parameters: ["username" : ticker], headers: header)
                
    //            self.finalURL = self.baseURL + ticker + "/book"
    //            self.getStockData(url: self.finalURL)
                
                
                
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
            
            //give the alert the textField
            alert.addTextField { (textfield) in
                textfield.placeholder = "Enter epic-name"
                textField = textfield
                
            }
            alert.addAction(action)
            alert.addAction(cancel)
            
            present(alert, animated: true,  completion: nil)
            
            
        
    }
    
    func getUsersID(parameters : [String : String], headers : HTTPHeaders) {
    
        
        
        
        Alamofire.request("https://fortnite-public-api.theapinetwork.com/prod09/users/id", method: .post, parameters : parameters, headers: headers).responseJSON
            { response in
                
                if response.result.isSuccess {
                    print("Success! Got the data")
                    let returnedData : JSON = JSON(response.result.value!)
                    print(returnedData)
                    
                    self.userID = returnedData["uid"]
                    
                    let dataParameters = ["user_id" : "\(self.userID)", "platform" : self.platformChosen, "window" : "alltime"]
                    
                    self.getUsersData(url: "https://fortnite-public-api.theapinetwork.com/prod09/users/public/br_stats", parameters: dataParameters, headers: headers)
                    
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")

                }
        }
        
    }
    
    
    func getUsersData(url : String, parameters : [String : String], headers : HTTPHeaders) {
        
        Alamofire.request(url, method: .post, parameters : parameters, headers: headers).responseJSON
            { response in
                
                if response.result.isSuccess {
                    print("Success! Got the data")
                    let returnedData : JSON = JSON(response.result.value!)
                    print(returnedData)
                    
                    self.updateUI(json: returnedData)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    
                }
        }
        
    }
    
    
    func updateUI(json : JSON) {
        
        
        
        
        let jsonStats = json["stats"]
        
        userSoloWins = "Solo Wins: \(jsonStats["placetop1_solo"])"
        
        if userSoloWins == "Solo Wins: null" {
            navigationItem.title = "User not found"
            
        }
        
        else {
            duoWins = "Duo Wins: \(jsonStats["placetop1_duo"])"
            
            squadWins = "Squad Wins: \(jsonStats["placetop1_squad"])"
            
            kdSolo = "Solo KD: \(jsonStats["kd_solo"])"
            
            kdDuo = "Duo KD: \(jsonStats["kd_duo"])"
            
            kdSquad = "Squad KD: \(jsonStats["kd_squad"])"
            
            killSolo = "Solo Kills: \(jsonStats["kills_solo"])"
            
            killDuo = "Duo Kills: \(jsonStats["kills_duo"])"
            
            killSquad = "Squad Kills: \(jsonStats["kills_squad"])"
            
            username = "\(json["username"])"
            
            navigationItem.title = "User found!8"
            
            soloButton.isEnabled = true
            duoButton.isEnabled = true
            squadButton.isEnabled = true
        }
        
        
        
        
        
        
    }

    @IBAction func StatButton(_ sender: Any) {
        
        performSegue(withIdentifier: "statSegue", sender: self)
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        func updateStatController(winStat : String, kdStat : String, killStat : String) {
            let vc = segue.destination as? StatsViewController
            vc?.winText = winStat
            vc?.kdText = kdStat
            vc?.killStat = killStat
            vc?.navigationItem.title = username
            
            
        }
        
        if segue.identifier == "statSegue" {
            
            updateStatController(winStat: userSoloWins, kdStat: kdSolo, killStat: killSolo)
            
            
        } else if segue.identifier == "duoSegue" {
            
            updateStatController(winStat: duoWins, kdStat: kdDuo, killStat: killDuo)
            
        } else if segue.identifier == "squadSegue" {
            
            updateStatController(winStat: squadWins, kdStat: kdSquad, killStat: killSquad)
            
        }
        
        
    }


    
    
    
    
}

