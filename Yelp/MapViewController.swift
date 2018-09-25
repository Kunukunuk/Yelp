//
//  MapViewController.swift
//  Yelp
//
//  Created by Kun Huang on 9/22/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class customAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(pinTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.coordinate = location
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    @IBOutlet weak var goToMapView: MKMapView!
    var locationManager : CLLocationManager!
    var data: [Business]! = []
    var businessName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToMapView.delegate = self
        // Do any additional setup after loading the view.
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2DMake(centerLocation.coordinate.latitude, centerLocation.coordinate.longitude))
        createAnnontationsOnMap()
        
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        goToMapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.03, 0.03)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            goToMapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "An annotation!"
        goToMapView.addAnnotation(annotation)
    }
    
    // add an annotation with an address: String
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    let custom = customAnnotation(pinTitle: title, location: coordinate.coordinate)
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.goToMapView.addAnnotation(custom)
                }
            }
        }
    }
    
    func createAnnontationsOnMap() {
        if let businesses = data {
            for business in businesses {
                addAnnotationAtAddress(address: business.address!, title: business.name!)
            }
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        businessName = (view.annotation?.title)!!
        performSegue(withIdentifier: "GoToDetails", sender: self)
        
    }
    
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customannotation"
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
    
        annotationView!.image = UIImage(named: "Food")
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailsViewController
        
        if let businesses = data {
            for business in businesses {
                if business.name == businessName {
                    vc.singleBusiness = business
                }
            }
        }
        
    }

}
