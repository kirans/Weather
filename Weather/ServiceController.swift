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

enum APIError : Error {
    
    case WeatherAPI(String)
    
    func value() -> String {
        switch self {
        case let .WeatherAPI(value):
            return value
        }
    }
}

class ServiceController {
    
    static let sharedInstance = ServiceController()
    let sharedSession = URLSession.shared
    var serviceBaseURL:String = "http://api.openweathermap.org/data/2.5/weather"
    
    //Downloads weather for a city
    func weather(byCity city:String, completion:@escaping (_ city:City?, _ error:Error?)->Void) throws {
        guard let url = URL(string: serviceBaseURL+"?q="+city+"&APPID=\(weatherAPIKey)") else {
            return
        }
        let task = sharedSession.dataTask(with: url) { (data, response, err) in
            guard err == nil else {
                completion(nil, err)
                return
            }
            
            if let weatherData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: weatherData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        if let apiError = self.handleError(dict: json)  {
                            completion(nil, apiError)
                            return
                        }
                        completion(City(with: json), nil)
                    }
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            }
            
        }
        task.resume()
    }
    
    //Downloads weather api icons
    func downloadWeatherIcon(with code:String , completion:@escaping(_ image:UIImage?, _ error:Error?) -> Void)  {
        let urlSrtring = "http://openweathermap.org/img/w/\(code)"+".png"
        guard let url = URL(string:urlSrtring) else {
            completion(nil, nil)
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 1.0)
        let task = sharedSession.downloadTask(with: urlRequest) { (location, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let fileLocation = location, let fileData = try? Data(contentsOf: fileLocation) {
                if let image = UIImage(data: fileData) {
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    //Handles Weather API Error
    func handleError(dict:NSDictionary) -> Error? {
        var error:Error? = nil
        
        guard let code = dict["cod"] as? String else {
            return error
        }
        if code != "200" {
            var errorMessage = "Something went wrong please try later"
            if let message = dict["message"] as? String {
                errorMessage = message
            }
            error = APIError.WeatherAPI(errorMessage)
        }
        return error
    }
    
}
