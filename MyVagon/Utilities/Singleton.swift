//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class SingletonClass: NSObject
{
    static let sharedInstance = SingletonClass()
    var SystemDate = ""
    
    var RegisterData = RegisterSaveDataModel()
    var ProfileData = ProfileEditSaveModel()
    
    func clearSingletonClassForRegister() {
        
        RegisterData = RegisterSaveDataModel()
        UserDefault.removeObject(forKey: UserDefaultsKey.RegisterData.rawValue)
        UserDefault.setValue(-1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
        
    }
    
    var initResModel : InitDatum?
    
    //Login Data
    var UserProfileData : LoginDatum?
    var Token = ""
    
    //Default device data
    var DeviceName = UIDevice.modelName
    var DeviceToken : String? = "1111"
    var DeviceType : String? = "ios"
    var AppVersion : String?
    
    //Language
    var SelectedLanguage : String = ""
    
    
    //Truck Data
    var PackageList : [PackageDatum]?
    var TruckTypeList : [TruckTypeDatum]?
    var TruckBrandList : [TruckBrandsDatum]?
    var TruckFeatureList : [TruckFeaturesDatum]?
    var TruckunitList : [TruckUnitDatum]?
    
    
    func ClearSigletonClassForLogin() {
        UserProfileData = nil
        Token = ""
    }
    var searchReqModel = SearchSaveReqModel()
    
    var TimerForUpdateLocation = Timer()
    
    var CurrentTripStart: Bool = false {
        didSet {
            if CurrentTripStart {
                
                UpdateLocationClass.sharedLocationInstance.UpdateLocationStart()
                UpdateLocationClass.sharedLocationInstance.UpdatedLocation = { (LocationUpdated) in
                    SingletonClass.sharedInstance.userCurrentLocation = LocationUpdated
                    let Location1 = CLLocationCoordinate2D(latitude: 23.070953, longitude: 72.5157073)
                    let Location2 = CLLocationCoordinate2D(latitude: 23.071396, longitude: 72.513970)
                    
           //         let distanceBetweenPickupAndDriver = SingletonClass.sharedInstance.CurrentTripSecondLocation.distance(from: LocationUpdated.coordinate)
                    
                    
                    let distanceBetweenPickupAndDriver = Location1.distance(from: Location2)
               //     print("Distance Between distanceBetweenPickupAndDriver :: \(distanceBetweenPickupAndDriver / 1000) Km")
                    if distanceBetweenPickupAndDriver < 300 {
                        print("ATDebug :: location is near")
                        if let topvc = UIApplication.topViewController() {
                            if topvc.isKind(of: SchedualLoadDetailsViewController.self) {
                                let vc = topvc as! SchedualLoadDetailsViewController
                                
                                if (self.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                                    vc.btnStartTrip.setTitle(TripStatus.Arrivedatpickuplocation.Name, for: .normal)
                                } else {
                                    vc.btnStartTrip.setTitle(TripStatus.ArrivedatDroplocation.Name, for: .normal)
                                }
                              
                               
                                vc.btnStartTrip.superview?.isHidden = false
                            }
                        }
                        SingletonClass.sharedInstance.isNearByPickupLocation = true
                    } else {
                        SingletonClass.sharedInstance.isNearByPickupLocation = false
                        if let topvc = UIApplication.topViewController() {
                            if topvc.isKind(of: SchedualLoadDetailsViewController.self) {
                                let vc = topvc as! SchedualLoadDetailsViewController
                                if (self.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                                    vc.btnStartTrip.setTitle(TripStatus.Arrivedatpickuplocation.Name, for: .normal)
                                } else {
                                    vc.btnStartTrip.setTitle(TripStatus.ArrivedatDroplocation.Name, for: .normal)
                                }
                                vc.btnStartTrip.superview?.isHidden = true
                            }
                        }
                    }
                  
                }
                
                StartTimerForUpdateLocation()
            } else {
                UpdateLocationClass.sharedLocationInstance.GeneralLocationManager.stopUpdatingLocation()
                StopTimerForUpdateLocation()
            }
        }
    }
    
    var isNearByPickupLocation : Bool = false
 //   var CurrentTripSecondLocation = CLLocationCoordinate2D()
    var CurrentTripSecondLocation : MyLoadsNewLocation?
    var userCurrentLocation = CLLocation()
    var CurrentTripShipperID : String = ""
    func StartTimerForUpdateLocation() {
        TimerForUpdateLocation.invalidate()
        
        
        if SocketIOManager.shared.socket.status == .connected {
            emitForCurrentLocation()
            TimerForUpdateLocation = Timer.scheduledTimer(withTimeInterval: TimeInterval(SingletonClass.sharedInstance.initResModel?.updateLocationInterval ?? 5), repeats: true) { (timer) in
                
                self.emitForCurrentLocation()
            }
        }
    }
    func emitForCurrentLocation() {
        
        let params = [  "pickup_lat" : "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLat?.toDouble() ?? 0.0)",
                        "pickup_lng" : "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLng?.toDouble() ?? 0.0)",
                        "lat" : "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude )",
                        "lng" : "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude )",
                        "driver_id" : "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)",
                        "shipper_id" : SingletonClass.sharedInstance.CurrentTripShipperID ]
        
        
        SocketIOManager.shared.socketEmit(for: socketApiKeys.updateLocation.rawValue , with: params)
        
    }
    func StopTimerForUpdateLocation() {
        
        TimerForUpdateLocation.invalidate()
    }
    
}
class RegisterSaveDataModel : Codable {
    
    var Reg_fullname = ""
    var Reg_country_code = ""
    var Reg_mobile_number = ""
    var Reg_email = ""
    var Reg_password = ""
    var Reg_truck_type = ""
    var Reg_truck_sub_category = ""
    var Reg_truck_plat_number = ""
    var Reg_trailer_plat_number = ""
    var Reg_truck_weight = ""
    var Reg_weight_unit = ""
    var Reg_truck_capacity = ""
    var Reg_capacity_unit = ""
    var Reg_brand = ""
    var Reg_pallets : [TruckCapacityType] = []
    var Reg_truck_features : [String] = []
    var Reg_fuel_type = ""
    var Reg_vehicle_images : [String] = []
    var Reg_id_proof : [String] = []
    var Reg_license : [String] = []
    var Reg_license_number = ""
    var Reg_license_expiry_date = ""
    
    
}
class ProfileEditSaveModel : Codable {
    var Reg_profilePic : [String] = []
    var Reg_fullname = ""
    var Reg_country_code = ""
    var Reg_mobile_number = ""
    var Reg_truck_type = ""
    var Reg_truck_sub_category = ""
    var Reg_truck_plat_number = ""
    var Reg_trailer_plat_number = ""
    var Reg_truck_weight = ""
    var Reg_weight_unit = ""
    var Reg_truck_capacity = ""
    var Reg_capacity_unit = ""
    var Reg_brand = ""
    var Reg_pallets : [TruckCapacityType] = []
    var Reg_truck_features : [String] = []
    var Reg_load_capacity = ""
    var Reg_fuel_type = ""
    var Reg_registration_no = ""
    var Reg_vehicle_images : [String] = []
    var Reg_id_proof : [String] = []
    var Reg_license : [String] = []
    var Reg_license_number = ""
    var Reg_license_expiry_date = ""
    
    
}
class SearchSaveReqModel : Codable {
    
    var pickup_date : String = ""
    var min_price : String = ""
    var max_price : String = ""
    var pickup_lat : String = ""
    var pickup_lng : String = ""
    var dropoff_lat : String = ""
    var dropoff_lng : String = ""
    var min_weight : String = ""
    var max_weight : String = ""
    var min_weight_unit : String = ""
    var max_weight_unit : String = ""
    
    var pickup_address_string : String = ""
    var dropoff_address_string : String = ""
    
}
