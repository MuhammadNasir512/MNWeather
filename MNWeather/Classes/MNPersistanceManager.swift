//
//  MNPersistanceManager.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 05/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import UIKit

class MNPersistanceManager: NSObject {

    static let sharedManager = MNPersistanceManager()
    private let minutesToAvoidAPICalls = 30.0
    
    func shouldLoadDataFromAPI() -> Bool {
        if let persistanceDate = MNAnyPersistanceManager.sharedManager.dateOfPersistance() {
            let validDateForAPICall = NSDate().dateByAddingTimeInterval(-minutesToAvoidAPICalls*60)
            if (persistanceDate.compare(validDateForAPICall) == NSComparisonResult.OrderedDescending) {
                return false
            }
            return true
        }
        return true
    }
    
    func saveWeatherModelToPersistance(weatherModel: MNWeatherModel) {
        let weatherModelData = NSKeyedArchiver.archivedDataWithRootObject(weatherModel)
        MNAnyPersistanceManager.sharedManager.saveWeatherData(weatherModelData)
        MNAnyPersistanceManager.sharedManager.saveDateOfPersistance(NSDate())
    }

    func loadWeatherModelFromPersistance() -> MNWeatherModel? {
        if let weatherModelData = MNAnyPersistanceManager.sharedManager.weatherModelData() as? NSData {
            if let weatherModel:MNWeatherModel = NSKeyedUnarchiver.unarchiveObjectWithData(weatherModelData) as? MNWeatherModel {
                return weatherModel
            }
            return nil
        }
        return nil
    }
}

// Mark: Following private class is supporting NSUserDefaults. Lets say you want CoreData, SQLite or something else. then you need to change following class. If that class is going to get bloated then you may need to create a separate swift class.
private class MNAnyPersistanceManager: NSObject {
    static let sharedManager = MNAnyPersistanceManager()
    
    private let keyForWeatherModel = "KeyForWeatherModel"
    private let keyForDateOfPersistance = "KeyForDateOfPersistance"
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func weatherModelData() -> AnyObject? {
        return userDefaults.objectForKey(keyForWeatherModel)
    }
    
    func dateOfPersistance() -> NSDate? {
        return userDefaults.objectForKey(keyForDateOfPersistance) as? NSDate
    }
    
    func saveWeatherData(weatherData: AnyObject) {
        userDefaults.setObject(weatherData, forKey: keyForWeatherModel)
    }
    
    func saveDateOfPersistance(date: NSDate) {
        userDefaults.setObject(date, forKey: keyForDateOfPersistance)
    }
}