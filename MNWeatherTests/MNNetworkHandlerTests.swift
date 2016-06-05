//
//  MNNetworkHandlerTests.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 05/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import XCTest

class MNNetworkHandlerTests: XCTestCase, MNNetworkHandlerDelegate {
    var expectation:XCTestExpectation?
    private let networkHandler = MNNetworkHandler()

    override func setUp() {
        super.setUp()
        networkHandler.delegate = self
    }
    
    override func tearDown() {
        networkHandler.delegate = nil
        super.tearDown()
    }
    
    func testIfNetworkHandlerProvidesRequiredResponse () {
        expectation = self.expectationWithDescription("asynchronous request")
        networkHandler.loadWeatherWithCoordinates(51.51, longitude: -0.13)
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func networkHandlerDidLoadWeatherInformation(responseDictionary: Dictionary<String, AnyObject>) {

        XCTAssertNotNil(responseDictionary, "responseDictionary should not be nil")
        XCTAssertNotNil(responseDictionary["name"], "City should not be nil")

        let weatherArray = responseDictionary["weather"] as? [AnyObject]
        XCTAssertNotNil(weatherArray, "weatherArray should not be nil")
        
        let weather = weatherArray!.first as? [String:AnyObject]
        XCTAssertNotNil(weather, "weather should not be nil")
        XCTAssertNotNil(weather!["description"])
        
        let temperatureObject = responseDictionary["main"] as? [String:AnyObject]
        XCTAssertNotNil(temperatureObject)
        XCTAssertNotNil(temperatureObject!["temp"])
        XCTAssertNotNil(temperatureObject!["temp_min"])
        XCTAssertNotNil(temperatureObject!["temp_max"])
        XCTAssertNotNil(temperatureObject!["humidity"])
        
        print(responseDictionary)
        expectation?.fulfill()
    }

    func networkHandlerDidNotLoadWeatherInformation(errorMessage: String?) {
        XCTAssertNotNil(errorMessage, "Error message should not be nil")
        expectation?.fulfill()
    }
}
