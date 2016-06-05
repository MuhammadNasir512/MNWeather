//
//  MNWeatherModel.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 04/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import Foundation

class MNWeatherModel: NSObject, NSCoding {

    var weatherDescription:String?
    var maxTemperature:String?
    var minTemperature:String?
    var temperature:String?
    var humidity:String?
    var cityName:String?
    var backgroundImageName:String?
    
    init(dictionary: Dictionary<String, AnyObject>) {
        super.init()
        processWeatherInfoProperties(dictionary)
        processTemperatureInfoProperties(dictionary)
        processOtherProperties(dictionary)
    }
    
    // Mark: NSCoding overrides
    required init?(coder aDecoder: NSCoder) {
        super.init()
        decodeObjects(coder: aDecoder)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        encodeObjectsWithCoder(aCoder)
    }
}

extension MNWeatherModel {
    
    func decodeObjects (coder aDecoder: NSCoder) {
        weatherDescription = aDecoder.decodeObjectForKey(keyWeatherDescription) as? String
        maxTemperature = aDecoder.decodeObjectForKey(keyMaxTemperature) as? String
        minTemperature = aDecoder.decodeObjectForKey(keyMinTemperature) as? String
        temperature = aDecoder.decodeObjectForKey(keyTemperature) as? String
        humidity = aDecoder.decodeObjectForKey(keyHumidity) as? String
        cityName = aDecoder.decodeObjectForKey(keyCityName) as? String
        backgroundImageName = aDecoder.decodeObjectForKey(keyBackgroundImageName) as? String
    }
    
    func encodeObjectsWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(weatherDescription, forKey: keyWeatherDescription)
        aCoder.encodeObject(maxTemperature, forKey: keyMaxTemperature)
        aCoder.encodeObject(minTemperature, forKey: keyMinTemperature)
        aCoder.encodeObject(temperature, forKey: keyTemperature)
        aCoder.encodeObject(humidity, forKey: keyHumidity)
        aCoder.encodeObject(cityName, forKey: keyCityName)
        aCoder.encodeObject(backgroundImageName, forKey: keyBackgroundImageName)
    }
    
    func processWeatherInfoProperties (dictionary: Dictionary<String, AnyObject>) {
        if let weatherArray = dictionary["weather"] as? [AnyObject] {
            if let weather = weatherArray.first as? Dictionary<String, AnyObject> {
                if let weatherId = weather["id"]?.integerValue {
                    processBackgroundImageName(weatherId)
                }
                weatherDescription = weather["description"] as? String
            }
        }
    }
    
    func processTemperatureInfoProperties (dictionary: Dictionary<String, AnyObject>) {
        if let temperatureInfo = dictionary["main"] as? Dictionary<String, AnyObject> {
            let temperatureFormat = "%.0f ˚C"
            
            let temperatureValue = roundf((temperatureInfo["temp"] as? Float)!)
            temperature = String(format: temperatureFormat, temperatureValue)
            
            let minTemperatureValue = roundf((temperatureInfo["temp_min"] as? Float)!)
            minTemperature = String(format: temperatureFormat, minTemperatureValue)
            
            let maxTemperatureValue = roundf((temperatureInfo["temp_max"] as? Float)!)
            maxTemperature = String(format: temperatureFormat, maxTemperatureValue)

            let humidityValue = roundf((temperatureInfo["humidity"] as? Float)!)
            humidity = String(format: "%.0f%%", humidityValue)
        }
    }
    
    func processOtherProperties(dictionary: Dictionary<String, AnyObject>) {
        cityName = dictionary["name"] as? String
    }
    
    func processBackgroundImageName(weatherId: Int) {
        var backgroundImageName:String!
        switch weatherId {
        case 200...299:
            backgroundImageName = "2"
        case 300...399:
            backgroundImageName = "3"
        case 500...599:
            backgroundImageName = "5"
        case 600...699:
            backgroundImageName = "6"
        case 700...799:
            backgroundImageName = "7"
        case 700:
            backgroundImageName = "800"
        case 801...899:
            backgroundImageName = "8"
        case 900...950:
            backgroundImageName = "9"
        case 951...999:
            backgroundImageName = "950"
        default:
            backgroundImageName = "1"
        }
        self.backgroundImageName = "\(backgroundImageName).jpg"
    }
}

// Mark: Properties for key value encoding and decoding.
private let keyWeatherDescription = "weatherDescription"
private let keyMaxTemperature = "maxTemperature"
private let keyMinTemperature = "minTemperature"
private let keyTemperature = "temperature"
private let keyHumidity = "humidity"
private let keyCityName = "cityName"
private let keyBackgroundImageName = "backgroundImageName"

