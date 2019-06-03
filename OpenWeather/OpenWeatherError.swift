//
//  OpenWeatherError.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 01/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation

enum OpenWeatherError: Error {
    case requestFailed
    case responseUnsuccesful
    case invalidData
    case jsonConversionFailure
    case invalidUrl
    case jsonParsingFailure
}
