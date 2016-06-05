//
//  MNNetworkHandler.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 04/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import Foundation

protocol MNNetworkHandlerDelegate: class {
    func networkHandlerDidLoadWeatherInformation(responseDictionary :Dictionary <String, AnyObject>)
    func networkHandlerDidNotLoadWeatherInformation(errorMessage :String?)
}

class MNNetworkHandler: NSObject {
    
    private let apiUrlBase = "http://api.openweathermap.org/data/2.5/weather?"
    private let apiID = "ccbba5274c37f69c5c015a39676ae61c"
    var delegate:MNNetworkHandlerDelegate? = nil
    
    func loadWeatherWithCoordinates(latitude :Double, longitude :Double) {
        if let url = NSURL(string: constructUrlString(latitude, longitude: longitude)) {
            loadWeatherDataFromURL(url)
        }
        else {
            self.handleErrorWithMessage("Unable to create url for API call")
        }
    }
    
    private func loadWeatherDataFromURL(url :NSURL) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            if let jsonData = NSData(contentsOfURL: url) {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [String:AnyObject]
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.networkHandlerDidLoadWeatherInformation(dictionary)
                    })
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.handleErrorWithMessage("Malformed API response")
                    })
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.handleErrorWithMessage("API failed to provide weather data")
                })
            }
        }
    }
    
    private func handleErrorWithMessage(message :String) {
        self.delegate?.networkHandlerDidNotLoadWeatherInformation(message)
    }
    
    private func constructUrlString(latitude :Double, longitude :Double) -> String {
        let coordsParameters = "lat=\(latitude)&lon=\(longitude)"
        let urlstring = "\(apiUrlBase)\(coordsParameters)&units=metric&APPID=\(apiID)"
        
        // Following lines of code for testing only. During development, you dont need to make too many API calls.
        // I just copied response into assets as a mocked response after first load. Then I am using that all the time
        // This code needs to be deleted in production or test environment.
        /////////////////////////////////////
        /////////////////////////////////////
        /////////////////////////////////////
//        if let urlstring2 = NSBundle.mainBundle().URLForResource("mockedResponse", withExtension: "json") {
//            urlstring = urlstring2.absoluteString
//        }
        /////////////////////////////////////
        /////////////////////////////////////
        /////////////////////////////////////

        return urlstring
    }
}
