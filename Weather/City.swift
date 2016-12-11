//
//  City.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

//TODO : Implement Object Mapper

import Foundation

class City {
    var id:Int = 0
    var name:String = ""
    var base:String = ""
    var cod : Int = 0
    var temperature:Temperature?
    var pressure:Float = 0
    var humidity:Float = 0
    var weathers:[Weather] = []
    var wind:Wind?
    var sys:System?
    
    var weatherDescription:String? {
        if let weather = weathers.first {
            return weather.description
        }
        return nil
    }
    
    //Maps the json data to City.
    init(with dict:NSDictionary) {
        if let id = dict["id"] as? Int {
            self.id = id
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let code = dict["cod"] as? Int {
            self.cod = code
        }
        
        if let system  = dict["sys"] as? NSDictionary {
            self.sys = System(with: system)
        }
        if let main = dict["main"] as? NSDictionary {
            if let temp = main["temp"] as? Double{
                 self.temperature = Temperature(country: self.sys?.country, openWeatherMapDegrees: temp)
            }
            if let pres = main["pressure"] as? Float {
                self.pressure = pres
            }
        }

        if let weathers = dict["weather"] as? NSArray,  weathers.count > 0 {
            for each in weathers {
                if let weatherData = each as? NSDictionary {
                    let weatherInfo = Weather(with: weatherData)
                    self.weathers.append(weatherInfo)
                }
            }
        }
        if let windData = dict["wind"] as? NSDictionary {
            self.wind = Wind(with: windData)
        }
    }
}



