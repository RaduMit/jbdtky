//
//  CityID.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 01/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation

struct CityID {
    let cityID: Int
}

extension CityID: CustomStringConvertible {
    var description: String {
        return "id=\(cityID)"
    }
}
