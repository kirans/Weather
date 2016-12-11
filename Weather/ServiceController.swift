//
//  ServiceController.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation
import UIKit

let weatherAPIKey = "c26f95148c9fd553ee0cb06a05de46c1"

class ServiceController {
    
    static let sharedInstance = ServiceController()
    let sharedSession = URLSession.shared
    var serviceBaseURL:String = "http://api.openweathermap.org/data/2.5/weather"
    
//    lazy var serviceBaseURL:String? = {
//        if let url = UserDefaults.standard.value(forKey: "WeatherServiceURL") as? String {
//            return url
//        }
//        return nil
//    }()
    
    //TODO: Documentation
    func weather(byCity city:String, completion:@escaping (_ city:City?, _ error:Error?)->Void) throws {
        guard let url = URL(string: serviceBaseURL+"?q="+city+"&APPID=\(weatherAPIKey)") else {
            return
        }
        let task = sharedSession.dataTask(with: url) { (data, response, error) in
            if let weatherData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: weatherData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        let city = City(with: json)
                        completion(city, nil)
                    }
                    
                } catch {
                    //TODO: throw error
                    completion(nil, nil)
                    print("error in json parsing")
                }
            }
            
        }
        task.resume()
    }
    
    
    
    func handleError() {
        //TODO
    }
    
}
