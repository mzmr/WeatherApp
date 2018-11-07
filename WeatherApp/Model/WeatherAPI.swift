//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Maciej on 22/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import Foundation
import UIKit.UIImage

class WeatherAPI {
    
    func getLocationForecast(locationId: String, callback: @escaping (_: LocationForecast) -> Void) {
        let url = URL(string: "https://www.metaweather.com/api/location/\(locationId)/")
        if url == nil { return }
        let urlSession = URLSession.shared
        
        let dataTask = urlSession.dataTask(with: url!, completionHandler: {
            (data, urlResponse, error) in
            
            if error != nil {
                print("error [WeatherAPI->getLocationForecast()]: \(String(describing: error))")
                return
            }
            
            if data == nil {
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                let forecast = LocationForecast(data: jsonObject!)
                callback(_: forecast)
            } catch _ {
                return
            }
        })
        
        dataTask.resume()
    }
    
    func findCity(cityName: String, callback: @escaping (_: [City]) -> Void) {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(cityName)")
        findCity(url: url, callback: callback)
        
    }
    
    func findCity(latt: String, long: String, callback: @escaping (_: [City]) -> Void) {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latt),\(long)")
        findCity(url: url, callback: callback)
    }
    
    private func findCity(url: URL?, callback: @escaping (_: [City]) -> Void) {
        if url == nil { return }
        let urlSession = URLSession.shared
        
        let dataTask = urlSession.dataTask(with: url!, completionHandler: {
            (data, urlResponse, error) in
            
            if error != nil {
                print("error [WeatherAPI->findCity()]: \(String(describing: error))")
                return
            }
            
            if data == nil {
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                var cities: [City] = []
                
                for subObject in jsonObject! {
                    cities.append(City(jsonData: subObject))
                }
                
                callback(_: cities)
            } catch _ {
                return
            }
        })
        
        dataTask.resume()
    }
    
}
