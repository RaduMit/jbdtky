//
//  CurrentWeatherViewModel.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 01/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    let temperature: String
    let wind: String
    let clouds: String
    let icon: UIImageView
    
    init(model: CurrentWeather) {
        let roundedTemperature = Int(model.temperature)
        self.temperature = "\(roundedTemperature)º"
        
        let windValue = Int(model.wind)
        self.wind = "\(windValue) KPH"
        
        let cloudsValue = Int(model.clouds)
        self.clouds = "\(cloudsValue) %"

        let weatherIcon = UIImageView(image: model.icon)
        self.icon = weatherIcon
    }
}
