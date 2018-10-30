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
    
    
    var startingWindDirTransform = CGAffineTransform()
    var currentCityForecast: LocationForecast! {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi / -4))
        self.startingWindDirTransform = self.arrowImageView.transform
    }
    
    func updateView() {
        if currentCityForecast.currentDayNumber == 0 {
            previousButton.isEnabled = false
        } else {
            previousButton.isEnabled = true
        }
        
        if currentCityForecast.currentDayNumber == currentCityForecast.dailyForecastList.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        cityLabel.text = currentCityForecast.cityName
        let dailyForecast = currentCityForecast.getDailyForecast()
        iconImageView.image = UIImage(named: dailyForecast.stateAbbr)
        conditionsLabel.text =  dailyForecast.conditions
        tempMinTextField.text = dailyForecast.tempMin
        tempMaxTextField.text = dailyForecast.tempMax
        windSpeedTextField.text = dailyForecast.windSpeed
        airPressureTextField.text = dailyForecast.airPressure
        dateLabel.text = dailyForecast.date
        arrowImageView.transform = startingWindDirTransform.rotated(by: CGFloat(Double(dailyForecast.windDir)! * Double.pi / 180))
        
        self.setNeedsFocusUpdate()
    }
    
    @IBAction func onPreviousButtonTouchUp(_ sender: UIButton) {
        currentCityForecast.previousForecast()
        updateView()
    }
    
    @IBAction func onNextButtonTouchUp(_ sender: UIButton) {
        currentCityForecast.nextForecast()
        updateView()
    }
    
}


extension ViewController: CitySelectionDelegate {
    func selectedCityForecast(_ forecast: LocationForecast) {
        currentCityForecast = forecast
    }
}
