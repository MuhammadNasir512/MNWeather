//
//  MNWeatherViewControllerTests.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 05/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import XCTest

class MNWeatherViewControllerTests: XCTestCase {
    
    var viewController: MNWeatherViewController?

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        viewController = storyboard.instantiateViewControllerWithIdentifier("MNWeatherViewController") as? MNWeatherViewController
        viewController?.performSelectorOnMainThread(#selector(UIViewController.loadView), withObject: nil, waitUntilDone: true)
        
        if let url = NSBundle.mainBundle().URLForResource("mockedResponse", withExtension: "json") {
            if let jsonData = NSData(contentsOfURL: url) {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as? [String:AnyObject]
                    let weatherModel = MNWeatherModel(dictionary: dictionary!)
                    viewController?.updateUIWithData(weatherModel)
                } catch {
                }
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfViewControllerCreatedSuccessfully() {
        XCTAssertNotNil(viewController, "weather viewController cannot be nil")
    }
    
    func testWeatherDescriptionLabel() {
        let value = viewController?.weatherDescriptionLabel?.text
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("mist", value, "Unexpected value")
        XCTAssertFalse("misty" == value, "Should be false")
    }
    
    func testMaxTemperatureLabel() {
        let value = viewController?.maxTemperatureLabel?.text
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("18 ˚C", value, "Unexpected value")
        XCTAssertFalse("18" == value, "Should be false")
    }
    
    func testMinTemperatureLabel() {
        let value = viewController?.minTemperatureLabel?.text
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("14 ˚C", value, "Unexpected value")
        XCTAssertFalse("14" == value, "Should be false")
    }
    
    func testTemperatureLabel() {
        let value = viewController?.temperatureLabel?.text
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("17 ˚C", value, "Unexpected value")
        XCTAssertFalse("17" == value, "Should be false")
    }
    
    func testHumidityLabel() {
        let value = viewController?.humidityLabel?.text
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("82%", value, "Unexpected value")
        XCTAssertFalse("82" == value, "Should be false")
    }
    
    func testCityNameLabel() {
        let value = viewController?.cityNameLabel?.text
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("London", value, "Unexpected value")
        XCTAssertFalse("New York" == value, "Should be false")
    }

}
