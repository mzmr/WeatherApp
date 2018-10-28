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
    
    init() {
        
    }
    
    init(data: [String: Any]) {
        let daysRawData = data["consolidated_weather"]! as? [[String: Any]]
        
        for dayData in daysRawData! {
            dailyForecastList.append(DailyForecast(data: dayData))
        }
        
        currentDayNumber = 0
        cityName = "\(data["title"]!)"
    }
    
    func getCurrentForecast() -> DailyForecast {
        return dailyForecastList[currentDayNumber]
    }
    
    func getPreviousForecast() -> DailyForecast {
        if currentDayNumber > 0 {
            currentDayNumber -= 1
            return dailyForecastList[currentDayNumber]
        } else {
            return dailyForecastList[currentDayNumber]
        }
    }
    
    func getNextForecast() -> DailyForecast {
        if currentDayNumber < dailyForecastList.count - 1 {
            currentDayNumber += 1
            return dailyForecastList[currentDayNumber]
        } else {
            return dailyForecastList[currentDayNumber]
        }
    }
}
