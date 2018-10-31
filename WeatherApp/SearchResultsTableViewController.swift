//
//  SearchResultsTableViewController.swift
//  WeatherApp
//
//  Created by Maciej on 31/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    
    var cities = [City]()
    var selectedCity: City?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    

}
