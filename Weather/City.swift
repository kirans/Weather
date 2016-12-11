//
//  City.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation

class City {
    var id:Int = 0
    var name:String = ""
    var base:String = ""
    var cod : Int = 0
    var weather:Weather?
    var wind:Wind?
    var sys:System?
    
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
        if let weathers = dict["weather"] as? NSArray,  weathers.count > 0 {
            if let weatherData = weathers[0] as? NSDictionary {
                self.weather = Weather(with: weatherData)
            }
        }
        if let windData = dict["wind"] as? NSDictionary {
            self.wind = Wind(with: windData)
        }
    }
}



