//
//  OpenWeatherAPIClient.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 01/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation
import UIKit

class OpenWeatherAPIClient {
    fileprivate let apiKey = "401f6cde96af6c2099b47626eb1da86b"
    
    var temperature: Double!
    var wind: Double!
    var clouds: Int!
    var icon: String!
    var imageView: UIImage!
    
    let defaults = UserDefaults.standard
    
    lazy var baseUrl: URL = {
        return URL(string: "http://api.openweathermap.org/data/2.5/")!
    }()
    
    let downloader = JSONDownloader()
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, OpenWeatherError?) -> Void
    
    func getCurrentWeather(at cityID: CityID, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
    
         guard let url = URL(string: "weather?\(cityID.description)&APPID=\(apiKey)", relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        let request = URLRequest(url: url)
    
        let task = downloader.jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                if let mainIcon = json["weather"] as? [[String: AnyObject]] {
                    if let currentIcon = mainIcon[0]["icon"] as? String {
                        self.icon = currentIcon
                        self.getImage()
                        
                    }
                }
                
                if let mainTemp = json["main"] as? [String: AnyObject] {
                    if let currentTemp = mainTemp["temp"] as? Double {
                        let kelvinToFarenheitPreDivision = (currentTemp * (9/5) - 459.67)
                        
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        
                        let farenheitToCelsius = (kelvinToFarenheit - 32) * 5/9
                        
                        if self.defaults.bool(forKey: "chosenCelsiusMode") == true {
                            self.temperature = farenheitToCelsius
                        } else {
                            self.temperature = kelvinToFarenheit
                        }
                    }
                }
                
                if let mainWind = json["wind"] as? [String: AnyObject] {
                    if let currentWind = mainWind["speed"] as? Double {
                        self.wind = currentWind
                    }
                }
                
                if let mainClouds = json["clouds"] as? [String: AnyObject] {
                    if let currentClouds = mainClouds["all"] as? Int {
                        self.clouds = currentClouds
                    }
                }
                
                guard let currentWeather = CurrentWeather(temperature: self.temperature, wind: self.wind, clouds: self.clouds, icon: self.imageView ) as? CurrentWeather else {
                
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                print("current: \(currentWeather)")
                
                completion(currentWeather, nil)
            }
        }
        
        task.resume()
        
    }

    func getImage() {
        guard let iconString = icon else { return }
        
        let pictureURL = URL(string: "http://openweathermap.org/img/w/\(iconString).png")!
        
        let semaphore = DispatchSemaphore(value: 0)

        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            // The download has finished.
            
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        self.imageView = image
                       semaphore.signal()
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
}
