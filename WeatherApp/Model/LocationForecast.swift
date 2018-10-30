//
//  LocationForecast.swift
//  WeatherApp
//
//  Created by Maciej on 22/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import Foundation

class LocationForecast {

    var dailyForecastList = [DailyForecast]()
    var currentDayNumber = Int()
    var cityName = String()
    var cityId = String()
    
    init() {
        
    }
    
    init(data: [String: Any]) {
        let daysRawData = data["consolidated_weather"]! as? [[String: Any]]
        
        for dayData in daysRawData! {
            dailyForecastList.append(DailyForecast(data: dayData))
        }
        
        currentDayNumber = 0
        cityName = "\(data["title"]!)"
        cityId = "\(data["woeid"]!)"
    }
    
    func getDailyForecast() -> DailyForecast {
        return dailyForecastList[currentDayNumber]
    }
    
    func previousForecast() {
        if currentDayNumber > 0 {
            currentDayNumber -= 1
        }
    }
    
    func nextForecast() {
        if currentDayNumber < dailyForecastList.count - 1 {
            currentDayNumber += 1
        }
    }
}
