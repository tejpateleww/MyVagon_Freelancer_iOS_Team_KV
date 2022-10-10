//
//  UpdateLocationClass.swift
//  MyVagon
//
//  Created by Apple on 20/12/21.
//

import Foundation
import CoreLocation
import UIKit

class UpdateLocationClass : NSObject, CLLocationManagerDelegate {
    
    class var sharedLocationInstance: UpdateLocationClass {
        struct Static {
            static var instance = UpdateLocationClass()
        }
        return Static.instance
    }
    
    var locationManager = CLLocationManager()
    var CurrentLocation: CLLocation?
    
    var UpdatedLocation:((CLLocation) -> ())?
    //    var UpdatedLocationLogin:((CLLocation) -> ())?
    //    var UpdatedLocationHome:((CLLocation) -> ())?
    //
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
        
                let status = CLLocationManager.authorizationStatus()
                if status == .notDetermined {
                    self.locationManager.requestAlwaysAuthorization()
                }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.CurrentLocation  = locations.first!
        
        
        if let UpdateLocation = self.UpdatedLocation {
            UpdateLocation(locations.first!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func UpdateLocationStart(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                //                if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstTime) {
                Utilities.CheckLocation(currentVC: UIApplication.topViewController() ?? UIViewController())
                //                }
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
                
            default:
                break
            }
        } else {
            Utilities.CheckLocation(currentVC: UIApplication.topViewController()!)
            print("Location services are not enabled")
            
        }
        
    }
    //checkPermisson
    func isAlwaysPermissionGranted() -> Bool{
        let aStatus = CLLocationManager.authorizationStatus()
        if aStatus == .authorizedAlways {
            return true
        }
        return false
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted,.denied,.notDetermined:
            self.locationManager.stopUpdatingLocation()
            if let topVC = UIApplication.topViewController() {
                Utilities.CheckLocation(currentVC: topVC)
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
            print("Location status is OK.")
        @unknown default:
            print("")
        }
    }
    
}


////
////  LocationService.swift
//
//
//import Foundation
//import CoreLocation
//import UIKit
//
//protocol LocationServiceDelegate {
//    func tracingLocation(currentLocation: CLLocation)
//    func tracingLocationDidFailWithError(error: Error)
//}
//
//class LocationService: NSObject, CLLocationManagerDelegate {
//    
//    class var sharedInstance: LocationService {
//        struct Static {
//            static var instance = LocationService()
//        }
//        return Static.instance
//    }
//
//    var locationManager: CLLocationManager?
//    var currentLocation: CLLocation?
//    var delegate: LocationServiceDelegate?
//
//    override init() {
//        super.init()
//
//        self.locationManager = CLLocationManager()
//        guard let locationManager = self.locationManager else {
//            return
//        }
//
//        let status = CLLocationManager.authorizationStatus()
//        if status == .notDetermined {
//            self.locationManager?.requestWhenInUseAuthorization()
//        }
//
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//    }
//    
//    func startUpdatingLocation() {
//        print("Starting Location Updates")
//        
//        let status = CLLocationManager.authorizationStatus()
//        if status == .notDetermined {
//            self.locationManager?.requestWhenInUseAuthorization()
//            
//        }else if status == .denied || status == .restricted{
//            
//            Utilities.CheckLocation(currentVC: UIApplication.topViewController()!)
//        }
//        self.locationManager?.startUpdatingLocation()
//    }
//    
//    func stopUpdatingLocation() {
//        print("Stop Location Updates")
//        self.locationManager?.stopUpdatingLocation()
//    }
//    
//   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let location = locations.last else {
//            return
//        }
//        
//        self.currentLocation = location
//    SingletonClass.sharedInstance.userCurrentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//    
//        updateLocation(currentLocation: location)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        updateLocationDidFailWithError(error: error)
//    }
//    
//    private func updateLocation(currentLocation: CLLocation){
//
//        guard let delegate = self.delegate else {
//            return
//        }
//        SingletonClass.sharedInstance.userCurrentLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//        delegate.tracingLocation(currentLocation: currentLocation)
//    }
//    
//    private func updateLocationDidFailWithError(error: Error) {
//        
//        guard let delegate = self.delegate else {
//            return
//        }
//        delegate.tracingLocationDidFailWithError(error: error)
//    }
//}
