//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit
class SingletonClass: NSObject
{
 
    var RegisterData = RegisterSaveDataModel()
    
   
    func clearSingletonClassForRegister() {
        
        RegisterData = RegisterSaveDataModel()
        UserDefault.removeObject(forKey: UserDefaultsKey.RegisterData.rawValue)
        UserDefault.setValue(-1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
        
    }
    
    
    
    
    static let sharedInstance = SingletonClass()
    
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
 
    
}
class RegisterSaveDataModel : Codable {
    
    var Reg_fullname = ""
    var Reg_country_code = ""
    var Reg_mobile_number = ""
    var Reg_email = ""
    var Reg_password = ""
    var Reg_truck_type = ""
    var Reg_truck_sub_category = ""
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
