//
//  AppDelegate.swift
//  BelajarGeoReferencing&IndoorLocalization
//
//  Created by Muhammad Rajab Priharsanto on 16/09/19.
//  Copyright © 2019 Muhammad Rajab Priharsanto. All rights reserved.
//  Source : https://blog.usejournal.com/geofencing-in-ios-swift-for-noobs-29a1c6d15dcc

import UIKit
import UserNotifications
//import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{

    var window: UIWindow?
    
//    var locationManager: CLLocationManager?
    
    // add the center property
    var notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        //Part 10. App Terminated (optional)
        // if the app was launched because of geofencing
        // create new instances and set self as their delegates
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil
        {
//            self.locationManager = CLLocationManager()
//            self.locationManager!.delegate = self
            
            self.notificationCenter = UNUserNotificationCenter.current()
            self.notificationCenter.delegate = self
            
        }
        else
        {
            // your app's "normal" behaviour goes here
        
//            self.locationManager = CLLocationManager()
//            self.locationManager!.delegate = self
        
        
            // get the singleton object
            self.notificationCenter = UNUserNotificationCenter.current()
        
            // register as it's delegate
            notificationCenter.delegate = self
        
            // define what do you need permission to use
            let options: UNAuthorizationOptions = [.alert, .sound]
        
            // request permission
            notificationCenter.requestAuthorization(options: options)
            { (granted, error) in
                if !granted
                {
                    print("Permission not granted")
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // when app is open and in foreground
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
        
        // ...
    }

}

//extension AppDelegate: CLLocationManagerDelegate
//{
//    // called when user Exits a monitored region
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
//    {
//        if region is CLCircularRegion
//        {
//            // Do what you want if this information
//            self.handleEvent(forRegion: region)
//        }
//    }
//
//    // called when user Enters a monitored region
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
//    {
//        if region is CLCircularRegion
//        {
//            // Do what you want if this information
//            self.handleEvent(forRegion: region)
//        }
//    }
//
//    func handleEvent(forRegion region: CLRegion!)
//    {
//
//        // customize your notification content
//        let content = UNMutableNotificationContent()
//        content.title = "Awesome title"
//        content.body = "Well-crafted body message"
//        content.sound = UNNotificationSound.default
//
//        // when the notification will be triggered
//        let timeInSeconds: TimeInterval = (60 * 15) // 60s * 15 = 15min
//        // the actual trigger object
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
//                                                        repeats: false)
//
//        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
//        let identifier = region.identifier
//
//        // the notification request object
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: content,
//                                            trigger: trigger)
//
//        // trying to add the notification request to notification center
//        notificationCenter.add(request, withCompletionHandler: { (error) in
//            if error != nil
//            {
//                print("Error adding notification with identifier: \(identifier)")
//            }
//        })
//    }
//}
