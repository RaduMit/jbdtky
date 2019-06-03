//
//  ViewController.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 01/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var currentCloudsLabel: UILabel!
    
    var chosenCityID = Int()
    var currentChosenLocation = String()
    
    let client = OpenWeatherAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentLocationLabel.text = currentChosenLocation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCurrentWeather()

    }

    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text = viewModel.temperature
        currentWindLabel.text = viewModel.wind
        currentCloudsLabel.text = viewModel.clouds
        currentWeatherIcon.image = viewModel.icon.image
    }

     func getCurrentWeather() {
        
        
        let cityID = CityID(cityID: chosenCityID)
        
        client.getCurrentWeather(at: cityID) { [unowned self] currentWeather, error in
        if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
            }
        }
    }

}

