//
//  ViewController.swift
//  WeatherApp
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var tempMinTextField: UITextField!
    @IBOutlet weak var tempMaxTextField: UITextField!
    @IBOutlet weak var windSpeedTextField: UITextField!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    @IBOutlet weak var airPressureTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentDayNumber = Int()
    var currentCityData = [String: Any]()
    var currentDayData = [String: Any]()
    var startingWindDirTransform = CGAffineTransform()
    
    var weatherImages = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readWeatherData()
        self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi / -4))
        self.startingWindDirTransform = self.arrowImageView.transform
    }
    
    func readWeatherData() {
        let myUrl = URL(string: "https://www.metaweather.com/api/location/523920/") // warszawa
        let urlSession = URLSession.shared
        
        
        if let url = myUrl {
            let dataTask = urlSession.dataTask(with: url, completionHandler: {
                (data, urlResponse, error) in
                
                if error != nil {
                    
                } else {
                    if let goodData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: goodData, options: []) as? [String: Any]
                            
                            DispatchQueue.main.async {
                                self.currentCityData = jsonObject!
                                self.currentDayNumber = 0
                                self.updateView()
                            }
                        } catch let err {
                            print("error: \(err)")
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
    }
    
    func updateView() {
        let daysRawData = currentCityData["consolidated_weather"]! as? [[String: Any]]
        currentDayData = daysRawData![currentDayNumber]
        updateWeatherImage(abbr: currentDayData["weather_state_abbr"]! as! String)
        
        if currentDayNumber == 0 {
            previousButton.isEnabled = false
        } else {
            previousButton.isEnabled = true
        }
        
        if currentDayNumber == daysRawData!.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        conditionsLabel.text =  "\(currentDayData["weather_state_name"]!)"
        
        setNumberValue(name: "min_temp", textField: tempMinTextField)
        setNumberValue(name: "max_temp", textField: tempMaxTextField)
        setNumberValue(name: "wind_speed", textField: windSpeedTextField)
        setNumberValue(name: "air_pressure", textField: airPressureTextField)
        
        dateLabel.text = "\(currentDayData["applicable_date"]!)"
        
        let windDir = "\(currentDayData["wind_direction"]!)"
        self.arrowImageView.transform = self.startingWindDirTransform.rotated(by: CGFloat(Double(windDir)! * Double.pi / 180))
        
        self.setNeedsFocusUpdate()
    }
    
    func setNumberValue(name: String, textField: UITextField!) {
        var theValue = "\(currentDayData[name]!)"
        if let dotRange = theValue.range(of: ".") {
            theValue.removeSubrange(dotRange.lowerBound ..< theValue.endIndex)
        }
        textField.text = theValue
    }
    
    func updateWeatherImage(abbr: String) {
        if let image = weatherImages[abbr] {
            iconImageView.image = image
        } else {
            let url = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(abbr).png")
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self.iconImageView.image = image
                    self.weatherImages[abbr] = image
                }
            }
        }
    }
    
    @IBAction func onPreviousButtonTouchUp(_ sender: UIButton) {
        currentDayNumber -= 1
        updateView()
    }
    
    @IBAction func onNextButtonTouchUp(_ sender: UIButton) {
        currentDayNumber += 1
        updateView()
    }
    

}

