//
//  ViewController.swift
//  WeatherApp
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var tempMinTextField: UITextField!
    @IBOutlet weak var tempMaxTextField: UITextField!
    @IBOutlet weak var windSpeedTextField: UITextField!
    @IBOutlet weak var airPressureTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var currentLocationForecast = LocationForecast()
    var startingWindDirTransform = CGAffineTransform()
    var currentCity: String? {
        didSet {
            readWeatherData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi / -4))
        self.startingWindDirTransform = self.arrowImageView.transform
    }
    
    func setLocation(cityId: String) {
        WeatherAPI().getLocationForecast(locationId: cityId, callback: saveDataAndUpdateView)
    }
    
    func readWeatherData() {
        if let city = currentCity {
            WeatherAPI().getLocationForecast(locationId: city, callback: saveDataAndUpdateView)
        }
    }
    
    func saveDataAndUpdateView(forecast: LocationForecast) {
        DispatchQueue.main.async {
            self.currentLocationForecast = forecast
            self.updateView(dailyForecast: forecast.getCurrentForecast())
        }
    }
    
    func updateView(dailyForecast: DailyForecast) {
        if currentLocationForecast.currentDayNumber == 0 {
            previousButton.isEnabled = false
        } else {
            previousButton.isEnabled = true
        }
        
        if currentLocationForecast.currentDayNumber == currentLocationForecast.dailyForecastList.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        cityLabel.text = currentLocationForecast.cityName
        iconImageView.image = UIImage(named: dailyForecast.stateAbbr)
        conditionsLabel.text =  dailyForecast.conditions
        tempMinTextField.text = dailyForecast.tempMin
        tempMaxTextField.text = dailyForecast.tempMax
        windSpeedTextField.text = dailyForecast.windSpeed
        airPressureTextField.text = dailyForecast.airPressure
        dateLabel.text = dailyForecast.date
        
        arrowImageView.transform = startingWindDirTransform.rotated(by: CGFloat(Double(dailyForecast.windDir)! * Double.pi / 180))
        
        let windDir = "\(currentDayData["wind_direction"]!)"
        self.arrowImageView.transform = self.startingWindDirTransform.rotated(by: CGFloat(Double(windDir)! * Double.pi / 180))
        
        self.setNeedsFocusUpdate()
    }
    
    @IBAction func onPreviousButtonTouchUp(_ sender: UIButton) {
        updateView(dailyForecast: currentLocationForecast.getPreviousForecast())
    }
    
    @IBAction func onNextButtonTouchUp(_ sender: UIButton) {
        updateView(dailyForecast: currentLocationForecast.getNextForecast())
    }
    
}


extension ViewController: CitySelectionDelegate {
    func citySelected(_ cityId: String) {
        currentCity = cityId
    }
}
