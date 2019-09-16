//
//  ViewController.swift
//  BelajarGeoReferencing&IndoorLocalization
//
//  Created by Muhammad Rajab Priharsanto on 16/09/19.
//  Copyright © 2019 Muhammad Rajab Priharsanto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{

    @IBOutlet weak var tampilanPeta: MKMapView!
    
    //bikin objek untuk location manager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkLocationServices()
        // Do any additional setup after loading the view.
    }

    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setupLocationManager()
            //locationManager.requestAlwaysAuthorization()
            checkLocationAuthorization()
            let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(-6.3023, 106.6522), radius: 10, identifier: "Boise")
            
            locationManager.startMonitoring(for: geoFenceRegion)
        }
        else
        {
            //show alert ngasitau kalo dia ga ngaktifin location
        }
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus()
        {
        case.authorizedWhenInUse:
            // do map stuff
            print("Masuk Pak Eko")
            tampilanPeta.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case.denied:
            // show alert and suggest them to turn on location services
            break
        case.notDetermined:
            // ask for permission to use the location
            locationManager.requestWhenInUseAuthorization()
            break
        case.restricted:
            // tell them what's up, restricted ini kalo ditolak dari parental control untuk ganti status.
            break
        case.authorizedAlways:
            // sebaiknya ga trlalu digunakan karena sekarang user sangat menjaga privasinya.
            break
        default:
            break
        }
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            tampilanPeta.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last
            else
        {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        tampilanPeta.setRegion(region, animated: true)
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        annotation.title = "Green Office Park"
//        annotation.subtitle = "BSD, Indonesia"
//        tampilanPeta.addAnnotation(annotation)
        
        for currentLocation in locations
        {
            //print("\(index): \(currentLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        print("Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        print("Exited: \(region.identifier)")
    }
}

