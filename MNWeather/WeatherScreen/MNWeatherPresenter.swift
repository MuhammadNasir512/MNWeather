//
//  MNWeatherPresenter.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 04/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import Foundation

class MNWeatherPresenter: NSObject, MNNetworkHandlerDelegate {
    weak var viewController:MNWeatherViewController?
    private let locationManager = MNLocationManager()
    private let networkHandler = MNNetworkHandler()
    
    override init() {
        super.init()
        networkHandler.delegate = self
    }
    
    func startLoadingWeatherInformation() {
        locationManager.currentLocation(
        { (latitude, longitude) in
            self.weatherStationsWithCoords(latitude, longitude: longitude)
            })
        { (errorMessage) in
            self.handleError(errorMessage)
        }
    }
    
    // Mark: Private methods
    private func weatherStationsWithCoords(latitude: Double, longitude: Double) {
        // if last API call was made longer than X minutes then following condition successes data will be loaded from API.
        if MNPersistanceManager.sharedManager.shouldLoadDataFromAPI() {
            networkHandler.loadWeatherWithCoordinates(latitude, longitude: longitude)
        }
        else {
            // if data was already loaded within X mintues before this call then you dont need to make another API call. Just used persisted data
            if let model = MNPersistanceManager.sharedManager.loadWeatherModelFromPersistance() {
                viewController?.updateUIWithData(model)
            }
            else {
                // if for any reason you failed to get persisted data then it will make API call and Persisit data if retrieved successfully from API
                networkHandler.loadWeatherWithCoordinates(latitude, longitude: longitude)
            }
        }
    }
    
    private func handleError (message: String?) {
        viewController?.handleErrorWithMessage(message)
    }
    
    // Mark: MNNetworkHandlerDelegate methods
    func networkHandlerDidLoadWeatherInformation(responseDictionary: Dictionary<String, AnyObject>) {
        if let model:MNWeatherModel = MNWeatherModel(dictionary: responseDictionary) {
            // persisting data to avoid making further API calls within X minutes of current API call.
            MNPersistanceManager.sharedManager.saveWeatherModelToPersistance(model)
            viewController?.updateUIWithData(model)
        }
    }
    
    func networkHandlerDidNotLoadWeatherInformation(errorMessage: String?) {
        handleError(errorMessage)
    }
}
