//
//  TemparatureConvert.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/11/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation

struct Temperature {
    let degrees: String
    
    init(country: String?, openWeatherMapDegrees: Double) {
        if let nation = country, nation == "US" {
            degrees = String(Int(TemperatureConverter.kelvinToFahrenheit(degrees: openWeatherMapDegrees)))
        } else {
            degrees = String(Int(TemperatureConverter.kelvinToCelsius(degrees: openWeatherMapDegrees)))
        }
    }
}

//Converts Degrees To Kelvin and viceversa
struct TemperatureConverter {
    static func kelvinToCelsius(degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    static func kelvinToFahrenheit(degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }
}
