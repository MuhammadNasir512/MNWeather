//
//  MNLocationManager.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 04/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import Foundation
import CoreLocation

class MNLocationManager: NSObject, CLLocationManagerDelegate {
    private var successHandler: ((Double, Double) -> ())?
    private var failHandler: ((String) -> ())?
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func currentLocation(successHandler: ((latitude :Double, longitude :Double) -> ())?, failHandler: ((errorMessage :String) -> ())?) {
        self.successHandler = successHandler
        self.failHandler = failHandler
        
        if locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func callbackWithLocationsCoords (latitude :Double, longitude :Double) {
        if let handler = successHandler {
            handler(latitude, longitude)
        }
    }
    
    private func handleErrorWithMessage(message: String) {
        if let handler = failHandler {
            handler(message)
        }
    }
    
    // Mark: CLLocationManagerDelegate methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways ||
            status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        else if status != CLAuthorizationStatus.NotDetermined {
            handleErrorWithMessage("Unable to get current location. Please verify your location settings. Currently you will see weather information for London city!")
            callbackWithLocationsCoords(51.5085300, longitude: -0.1257400)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let currentLocation:CLLocation = locations.first {
            callbackWithLocationsCoords(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
        else {
            handleErrorWithMessage("Unable to get current location. Currently you will see weather information for London city!")
            callbackWithLocationsCoords(51.5085300, longitude: -0.1257400)
        }
    }
}
