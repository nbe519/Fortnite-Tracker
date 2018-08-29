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
        
        
        soloWins.text = "Solo Wins: \(jsonStats["placetop1_solo"])"
        duoWinsLabel.text = "Duo Wins: \(jsonStats["placetop1_duo"])"
        squadWinsLabel.text = "Squad Wins: \(jsonStats["placetop1_squad"])"
        totalWinsLabel.text = "Total Kills: \(json["totals"]["kills"])"
        
        navigationItem.title = "\(json["username"])"
        
        
        
        
        
    }


}

