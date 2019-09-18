//
//  ViewController.swift
//  BelajarGeoReferencing&IndoorLocalization
//
//  Created by Muhammad Rajab Priharsanto on 16/09/19.
//  Copyright © 2019 Muhammad Rajab Priharsanto. All rights reserved.
//  Source : https://medium.com/@fede_nieto/geofences-how-to-implement-virtual-boundaries-in-the-real-world-f3fc4a659d40

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var tampilanPeta: MKMapView!
    
    //bikin objek untuk location manager
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var statusLokasiLabel: UILabel!
    
    let ENTERED_REGION_MESSAGE = "Selamat Datang di Akademi"
    let ENTERED_REGION_NOTIFICATION_ID = "EnteredRegionNotification"
    let EXITED_REGION_MESSAGE = "Sampai Jumpa Kembali"
    let EXITED_REGION_NOTIFICATION_ID = "ExitedRegionNotification"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        tampilanPeta.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        
        self.tampilanPeta.delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in }
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            tampilanPeta.setRegion(region, animated: true)
        }
    }
    
    func setUpGeofenceForPlayaGrandeBeach()
    {
        //radius 100 itu sampe ke the breeze dan unilever
        let geofenceRegionCenter = CLLocationCoordinate2DMake(-6.3023, 106.6522);
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 100, identifier: "CurrentLocation");
        geofenceRegion.notifyOnExit = true;
        geofenceRegion.notifyOnEntry = true;
        self.locationManager.startMonitoring(for: geofenceRegion)
        
        //Buat tampilan di petanya
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let mapRegion = MKCoordinateRegion(center: geofenceRegionCenter, span: span)
        self.tampilanPeta.setRegion(mapRegion, animated: true)
        
        let regionCircle = MKCircle(center: geofenceRegionCenter, radius: 400)
        self.tampilanPeta.addOverlay(regionCircle)
        self.tampilanPeta.showsUserLocation = true;
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    {
        print("Started Monitoring Region: \(region.identifier)")
        statusLokasiLabel.text = "Monitoring Region"
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        print(ENTERED_REGION_MESSAGE)
        statusLokasiLabel.text = ENTERED_REGION_MESSAGE
        //Good place to schedule a local notification
        
        self.createLocalNotification(message: ENTERED_REGION_MESSAGE, identifier: ENTERED_REGION_NOTIFICATION_ID)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        print(EXITED_REGION_MESSAGE)
        statusLokasiLabel.text = EXITED_REGION_MESSAGE
        //Good place to schedule a local notification
        
        self.createLocalNotification(message: EXITED_REGION_MESSAGE, identifier: EXITED_REGION_NOTIFICATION_ID)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //self.statusLokasiLabel.text = "Update Location"
    }
    
    //Kalo mau pake geofencing, harus banget pilih always in use (opsi kedua)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.authorizedAlways)
        {
            //App Authorized, stablish geofence
            self.setUpGeofenceForPlayaGrandeBeach()
        }
        else if (status == CLAuthorizationStatus.authorizedWhenInUse)
        {
            //App Authorized, stablish geofence
            self.setUpGeofenceForPlayaGrandeBeach()
        }
    }
    
    func createLocalNotification(message: String, identifier: String)
    {
        //Create a local notification
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default
        
        // Deliver the notification
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: nil)
        
        // Schedule the notification
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in }
    }
    
    //MARK - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor(red: 7.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1)
        overlayRenderer.fillColor = UIColor(red: 0.0/255.0, green: 203.0/255.0, blue: 208.0/255.0, alpha: 0.7)
        return overlayRenderer
    }
}

