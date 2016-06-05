//
//  MNWeatherModelTests.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 05/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import XCTest

class MNWeatherModelTests: XCTestCase {
    
    var weatherModel: MNWeatherModel?
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle.mainBundle().URLForResource("mockedResponse", withExtension: "json") {
            if let jsonData = NSData(contentsOfURL: url) {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as? [String:AnyObject]
                    weatherModel = MNWeatherModel(dictionary: dictionary!)
                } catch {
                }
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIfModelCreatedSuccessfully() {
        XCTAssertNotNil(weatherModel, "weather model cannot be nil")
    }
    
    func testWeatherDescription() {
        let value = weatherModel?.weatherDescription
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("mist", value, "Unexpected value")
        XCTAssertFalse("misty" == value, "Should be false")
    }
    
    func testMaxTemperature() {
        let value = weatherModel?.maxTemperature
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("18 ˚C", value, "Unexpected value")
        XCTAssertFalse("18" == value, "Should be false")
    }
    
    func testMinTemperature() {
        let value = weatherModel?.minTemperature
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("14 ˚C", value, "Unexpected value")
        XCTAssertFalse("14" == value, "Should be false")
    }
    
    func testTemperature() {
        let value = weatherModel?.temperature
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("17 ˚C", value, "Unexpected value")
        XCTAssertFalse("17" == value, "Should be false")
    }
    
    func testHumidity() {
        let value = weatherModel?.humidity
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("82%", value, "Unexpected value")
        XCTAssertFalse("82" == value, "Should be false")
    }
    
    func testCityName() {
        let value = weatherModel?.cityName
        XCTAssertNotNil(value, "value should not be nil")
        XCTAssertEqual("London", value, "Unexpected value")
        XCTAssertFalse("New York" == value, "Should be false")
    }
}
