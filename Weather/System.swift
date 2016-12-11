//
//  System.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation

class System {
    var message : Float = 0
    var country : String = ""
    var sunrise:Int = 0
    var sunset :Int = 0
    
    init(with dict:NSDictionary) {
        if let message = dict["message"] as? Float {
            self.message = message
        }
        if let country = dict["country"] as? String {
            self.country = country
        }
        if let sunrise = dict["sunrise"] as? Int {
            self.sunrise = sunrise
        }
        if let sunset  = dict["sunset"] as? Int {
            self.sunset = sunset
        }
    }
}
