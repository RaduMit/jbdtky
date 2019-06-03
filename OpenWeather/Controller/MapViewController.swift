//
//  MapViewController.swift
//  OpenWeather
//
//  Created by Radu Mitrea on 03/06/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
//    var myLocation = CLLocation()
    let locationManager = CLLocationManager()
    
    var locationLatitude = Double()
    var locationLongitude = Double()
    
    var countryName = String()
    var cityName = String()
    
    let regionInMeters: Double = 1000
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var countryNameLbl: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        checkLocationServices()
    }

    @IBAction func saveCurrentLocation(){
        performSegue(withIdentifier: "goToWeather", sender: self)
    }

    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            locationLatitude = location.latitude
            locationLongitude = location.longitude
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
        
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWeather"
        {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.currentChosenLocation = "\(cityName), \(countryName)"
                destinationVC.locationLatitude = locationLatitude
                destinationVC.locationLongitude = locationLongitude
            }
        }
    }

    func getCenterLocation(for mapView: MKMapView) -> CLLocation {

        let latitude = locationLatitude
        let longitude = locationLongitude
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func findLocationTitle() {

        let center = getCenterLocation(for: map)
        let geoCoder = CLGeocoder()

            geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
                guard let self = self else { return }

                if let _ = error {
                    return
                }

                guard let placemark = placemarks?.first else {
                    return
                }

                let localityName = placemark.administrativeArea ?? ""
                let countryName = placemark.country ?? ""

                DispatchQueue.main.async {
                    self.countryName = countryName
                    self.cityName = localityName
                    self.countryNameLbl.text = "Tap here to view\nthe weather for \(self.cityName)"
                }

            }
        

    }

}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
        findLocationTitle()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}




