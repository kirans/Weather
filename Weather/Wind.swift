//
//  Wind.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation

class Wind {
    var speed:Float = 0
    var deg:Float = 0
    
    init(with dict:NSDictionary) {
        if let speed = dict["speed"] as? Float {
            self.speed = speed
        }
        if let deg = dict["deg"] as? Float {
            self.deg = deg
        }
    }
}
