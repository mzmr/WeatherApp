//
//  LocationMapViewController.swift
//  WeatherApp
//
//  Created by Maciej on 07/11/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedCity: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setMap();
    }
    
    
    func setMap() {
        let cityCoord = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(Double(selectedCity!.lat)!),
            longitude: CLLocationDegrees(Double(selectedCity!.lon)!)
        )
        mapView.setCenter(cityCoord, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: cityCoord, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cityCoord
        annotation.title = selectedCity?.name
        mapView.addAnnotation(annotation)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
