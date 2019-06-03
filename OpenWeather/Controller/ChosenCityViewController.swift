//
//  ChosenCityViewController.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 01/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation
import UIKit


class ChosenCityViewController: UIViewController {
    
    
    @IBOutlet weak var japanImageView: UIImageView!
    @IBOutlet weak var englandImageView: UIImageView!
    @IBOutlet weak var romaniaImageView: UIImageView!
    
    @IBOutlet weak var chooseDegreeTypeSegment: UISegmentedControl!
    
    var chosenCityID = Int()
    var currentChosenLocation = String()
    var chosenFarenheitDegree = Bool()
    var chosenCelsiusDegree = Bool()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        chosenSegmentOfDegrees()
        
        romaniaImageView.layer.masksToBounds = true
        romaniaImageView.layer.cornerRadius = 15
        
        englandImageView.layer.masksToBounds = true
        englandImageView.layer.cornerRadius = 15
        
        japanImageView.layer.masksToBounds = true
        japanImageView.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWeather"
        {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.chosenCityID = chosenCityID
                destinationVC.currentChosenLocation = currentChosenLocation
            }
        }
    }
    
    
    func chosenSegmentOfDegrees() {
        if let bonusValue = defaults.value(forKey: "chosenDegreeMode"){
            let selectedIndex = bonusValue as! Int
            chooseDegreeTypeSegment.selectedSegmentIndex = selectedIndex
        }
    }

    
    @IBAction func selectDegreeBtnTapped(_ sender: UISegmentedControl) {
        let getIndex = chooseDegreeTypeSegment.selectedSegmentIndex
        print(getIndex)
        defaults.set(sender.selectedSegmentIndex, forKey: "chosenDegreeMode")
        
        switch (getIndex) {
        case 0:
            self.defaults.set(true, forKey: "chosenCelsiusMode")
            print("\(self.defaults.bool(forKey: "chosenCelsiusMode"))")
        case 1:
            self.defaults.set(false, forKey: "chosenCelsiusMode")
            print("\(self.defaults.bool(forKey: "chosenCelsiusMode"))")
        default:
            print("n")
        }
    }
    
    @IBAction func IasiBtnPressed(_ sender: UIButton) {
        chosenCityID = 675810
        currentChosenLocation = "Iasi, Romania"
        performSegue(withIdentifier: "goToWeather", sender: self)
    }
    
    @IBAction func londonBtnPressed(_ sender: UIButton) {
        chosenCityID = 2643743
        currentChosenLocation = "London, England"
        performSegue(withIdentifier: "goToWeather", sender: self)
    }
    
    @IBAction func tokyoBtnPressed(_ sender: UIButton) {
        chosenCityID = 1850147
        currentChosenLocation = "Tokyo, Japan"
        performSegue(withIdentifier: "goToWeather", sender: self)
    }
    
}
