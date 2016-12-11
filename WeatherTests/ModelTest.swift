//
//  CityTest.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/11/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import XCTest
import Foundation

class ModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateCity() {
        let dict : [String:Any] = ["id" : 100, "name":"Ashburn", "humidity":10.0, "Pressure" : "20"];
        let city = City(with: dict as NSDictionary)
        
        XCTAssertEqual(city.id, 100)
        XCTAssertEqual(city.name, "Ashburn")
    }
    
    func testCreateWeather() {
        let dict : [String:Any] = ["id" : 100, "main":"Light cloud"];
        let city = Weather(with: dict as NSDictionary)
        
        XCTAssertEqual(city.id, 100)
        XCTAssertEqual(city.main, "Light cloud")
    }
    
    func testCreateTemperature() {
        let temperature = Temperature(country: "US", openWeatherMapDegrees: 33)
        XCTAssertEqual(temperature.degrees, String(Int(round(33 * 9 / 5 - 459.67))))
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
