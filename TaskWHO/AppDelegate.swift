//
//  AppDelegate.swift
//  TaskWHO
//
//  Created by Gayathri on 25/11/20.
//  Copyright © 2020 Gayathri. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate{
    var window: UIWindow?

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.requestAlwaysAuthorization()
   
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
        }
        // Override point for customization after application launch.
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            print(currentLocPlacemark.country ?? "No country found")
            print("countrycode",currentLocPlacemark.isoCountryCode!)
            Utils.setPreferenceValue(setValue: currentLocPlacemark.isoCountryCode!, ForKey: Constant.COUNTRYCODE)
            
            
        }
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

