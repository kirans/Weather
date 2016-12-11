//
//  Weather.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation

class Weather {
    var id:Int = 0
    var main:String = ""
    var description:String = ""
    var iconId : String = ""
    
    
    
    init(with dict:NSDictionary) {
        if let id = dict["id"] as? Int {
            self.id = id
        }
        if let main = dict["main"] as? String {
            self.main = main
        }
        if let description = dict["description"] as? String {
            self.description = description
        }
        if let iconId  = dict["iconId"] as? String {
            self.iconId = iconId
        }
    }

}
