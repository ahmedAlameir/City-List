//
//  MapViewController.swift
//  City-List
//
//  Created by ahmed osama on 31/08/2022.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    var coord:Coord?
    var cityName:String?
    @IBOutlet weak var cityMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2DMake(Double(coord?.lat ?? "50")!, Double(coord?.lon ?? "50")!)
        annotation.coordinate = location
        annotation.title = cityName
        let mapCoordinate = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        cityMap.setRegion(mapCoordinate, animated: false)
        cityMap.addAnnotation(annotation)
        cityMap.setCenter(location, animated: true)
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
