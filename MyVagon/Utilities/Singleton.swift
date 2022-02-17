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
    var DeviceToken : String = UIDevice.current.identifierForVendor?.uuidString ?? ""
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
    
    var isArriveAtPickUpLocation : Bool = false
    var isArriveAtDropOffLocation : Bool = false
    
    var CurrentTripStart: Bool = false {
        didSet {
            if CurrentTripStart {
                
                UpdateLocationClass.sharedLocationInstance.UpdateLocationStart()
                UpdateLocationClass.sharedLocationInstance.UpdatedLocation = { (LocationUpdated) in
                    SingletonClass.sharedInstance.userCurrentLocation = LocationUpdated
                    
                    
                    let locationDrop = CLLocationCoordinate2DMake(SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLat?.toDouble() ?? 0.0, SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLng?.toDouble() ?? 0.0)
 
                    let distanceBetweenPickupAndDriver = locationDrop.distance(from: LocationUpdated.coordinate)
                        //near by distance
                    if distanceBetweenPickupAndDriver < 300 {
                        print("ATDebug :: location is near")
                        if let topvc = UIApplication.topViewController() {
                            if topvc.isKind(of: SchedualLoadDetailsViewController.self) {
                                let vc = topvc as! SchedualLoadDetailsViewController
                                if vc.LoadDetails?.trucks?.locations?.contains(where: {($0.id ?? 0) == (self.CurrentTripSecondLocation?.id ?? 0)}) == true {
                                    var pickupArray = self.CurrentTripSecondLocation?.products?.compactMap({$0.isPickup})
                                    pickupArray = pickupArray?.uniqued()
                                    if pickupArray?.count != 0   {
                                        if pickupArray?.count == 1 {
                                            if (self.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                                                //Tej's new changes
                                                if(!self.isArriveAtPickUpLocation){
                                                    NotificationCenter.default.post(name: .arriveAtPickUpLocation, object: nil)
                                                    vc.btnStartTrip?.setTitle(TripStatus.PickUpComplete.Name, for: .normal)
                                                }
                                                self.isArriveAtPickUpLocation = true
                                                //Tej's new changes Comp
                                                
                                            } else {
                                                if(!self.isArriveAtDropOffLocation){
                                                    NotificationCenter.default.post(name: .arriveAtPickUpLocation, object: nil)
                                                    vc.btnStartTrip?.setTitle(TripStatus.DropOffComplete.Name, for: .normal)
                                                }
                                                self.isArriveAtDropOffLocation = true
                                                
                                            }
                                        }  else {
                                            //Tej's new changes
                                            if(!self.isArriveAtPickUpLocation){
                                                NotificationCenter.default.post(name: .arriveAtPickUpLocation, object: nil)
                                            }
                                            self.isArriveAtPickUpLocation = true
                                            //Tej's new changes Comp
                                            vc.btnStartTrip?.setTitle(TripStatus.PickUpComplete.Name, for: .normal)
                                        }
                                    }
                                    if vc.TruckMarker != nil {
                                        vc.UpdatePath()
                                    }
                                    vc.btnStartTrip?.superview?.isHidden = false
                                }
                               
                               
                            }
                        }
                        SingletonClass.sharedInstance.isNearByPickupLocation = true
                    } else {
                        SingletonClass.sharedInstance.isNearByPickupLocation = false
                        if let topvc = UIApplication.topViewController() {
                            if topvc.isKind(of: SchedualLoadDetailsViewController.self) {
                                let vc = topvc as! SchedualLoadDetailsViewController
                                
                                if vc.LoadDetails?.trucks?.locations?.contains(where: {($0.id ?? 0) == (self.CurrentTripSecondLocation?.id ?? 0)}) == true {
                              
                                    vc.btnStartTrip?.superview?.isHidden = true
                                    if vc.TruckMarker != nil {
                                        vc.UpdatePath()
                                    }
                                }
                                
                        
                            }
                        }
                    }
                  
                }
                
                StartTimerForUpdateLocation()
            } else {
                UpdateLocationClass.sharedLocationInstance.locationManager.stopUpdatingLocation()
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
        self.emitForCurrentLocation()
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
    
    var date : String = ""
    var price_min : String = ""
    var price_max : String = ""
    var pickup_lat : String = ""
    var pickup_lng : String = ""
    var delivery_lat : String = ""
    var delivery_lng : String = ""
    var weight_min : String = ""
    var weight_max : String = ""
    var min_weight_unit : String = ""
    var max_weight_unit : String = ""
    var pickup_address_string : String = ""
    var dropoff_address_string : String = ""
    
}
