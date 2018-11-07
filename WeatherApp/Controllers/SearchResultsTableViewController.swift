//
//  SearchResultsTableViewController.swift
//  WeatherApp
//
//  Created by Maciej on 31/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import UIKit
import CoreLocation

class SearchResultsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var chooseCurrentCityButton: UIButton!
    
    var cities = [City]()
    var selectedCity: City?
    
    var locationManager: CLLocationManager!
    var currentLocation: Location!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func findCities(_ sender: UIButton) {
        self.cities.removeAll()
        let city = cityTextField.text!
        WeatherAPI().findCity(cityName: city, callback: saveDataAndUpdateView)
    }
    
    func saveDataAndUpdateView(cities: [City]) {
        DispatchQueue.main.async {
            for i in 0..<cities.count {
                print("city callback - \(cities[i].name)")
                self.cities.append(cities[i])
            }
            
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        cell.tag = Int(cities[indexPath.row].id)!
        
        return cell
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)!
        self.selectedCity = City(name: (cell.textLabel?.text!)!, id: String(cell.tag))
        performSegue(withIdentifier: "unwindSegueToMasterView", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MasterViewController
        destination.cities.append(self.selectedCity!)
        destination.tableView.reloadData()
        destination.readWeather(cityId: self.selectedCity!.id, cityName: self.selectedCity!.name)
    }
    
    // Localization stuff ----------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                print("user locality: \(placemark.locality!)")
                print("user administrative area: \(placemark.administrativeArea!)")
                print("user country: \(placemark.country!)")
                
                self.currentCityLabel.text = "You're in: \(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                self.currentLocation = Location(
                    name: placemark.locality!,
                    lat: "\(userLocation.coordinate.latitude)",
                    lon: "\(userLocation.coordinate.longitude)"
                )
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
    @IBAction func chooseCurrentLocation(_ sender: UIButton) {
        self.cities.removeAll()
        WeatherAPI().findCity(latt: currentLocation.lat, long: currentLocation.lon, callback: handleCurrentLocationChoice)
    }
    
    func handleCurrentLocationChoice(cities: [City]) {
        DispatchQueue.main.async {
            if cities[0].name == self.currentLocation.name {
                self.selectedCity = City(name: cities[0].name, id: cities[0].id)
                self.performSegue(withIdentifier: "unwindSegueToMasterView", sender: self)
            } else {
                for i in 0..<cities.count {
                    print("city callback - \(cities[i].name)")
                    self.cities.append(cities[i])
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
}
