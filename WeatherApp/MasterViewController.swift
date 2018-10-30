//
//  MasterViewControllerTableViewController.swift
//  WeatherApp
//
//  Created by Maciej on 27/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate: class {
    func selectedCityForecast(_ forecast: LocationForecast)
}

class MasterViewController: UITableViewController {
    
    var cities = [
        City(name: "Warsaw", id: "523920"),
        City(name: "Lisbon", id: "742676"),
        City(name: "Caracas", id: "395269")
    ]
    
    var cityCells = [Int: String]() //cell tag: city id
    
    var forecasts = [String: LocationForecast]()
    
    weak var delegate: CitySelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        readWeather()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func readWeather() {
        for city in cities {
            print("getting forecast for \(city.name)")
            WeatherAPI().getLocationForecast(locationId: city.id, callback: saveDataAndUpdateView)
        }
    }
    
    func saveDataAndUpdateView(forecast: LocationForecast) {
        DispatchQueue.main.async {
            print("list callback - \(forecast.cityName)")
            self.forecasts[forecast.cityId] = forecast
            self.updateView(locationForecast: forecast)
        }
    }
    
    func updateView(locationForecast: LocationForecast) {
        let cellsOpt = self.tableView?.visibleCells
        
        if let cells = cellsOpt {
            for cell in cells {
                let cityId = cityCells[cell.tag]
                
                print("CityId: \(cityId!), cellTag: \(cell.tag)")
                
                if cityId == locationForecast.cityId {
                    let forecast = locationForecast.getDailyForecast()
                    cell.imageView?.image = UIImage(named: forecast.stateAbbr)
                    cell.detailTextLabel?.text = "\(forecast.temp)°C"
                    
                    if cityId == cities[0].id {
                        delegate?.selectedCityForecast(locationForecast)
                    }
                    
                    break
                }
            }
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        cell.tag = indexPath.row
        cityCells[cell.tag] = cities[indexPath.row].id
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.selectedCityForecast(forecasts[selectedCity.id]!)
        
        if let detailViewController = delegate as? ViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
