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
class SingletonClass: NSObject{
    
    static let sharedInstance = SingletonClass()
    var SystemDate = ""
    
    var RegisterData = RegisterSaveDataModel()
    var ProfileData = ProfileEditSaveModel()
    
    func clearSingletonClassForRegister() {
        RegisterData = RegisterSaveDataModel()
        UserDefault.removeObject(forKey: UserDefaultsKey.RegisterData.rawValue)
        UserDefault.setValue(-1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
    }
    
    var latitude : Double!
    var longitude : Double!
    
    var initResModel : InitDatum?
    var splashComplete = false
    
    //Login Data
    var UserProfileData : LoginData?
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
    var cancellationReasons : [Reasone]?
    var searchReqModel = SearchSaveReqModel()
    
    func ClearSigletonClassForLogin() {
        UserProfileData = nil
        Token = ""
    }
    
    func callApiForLogout() {
        Utilities.showHud()
        WebServiceSubClass.logOutDriver { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                appDel.Logout()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}

class RegisterSaveDataModel : Codable {
    
    var Reg_fullname = ""
    var Reg_country_code = ""
    var Reg_mobile_number = ""
    var Reg_email = ""
    var Reg_password = ""
    
    var Reg_tractor_fual_type = ""
    var Reg_tractor_brand = ""
    var Reg_tractor_plate_number = ""
    var Reg_tractor_images : [String] = []
    
    var Reg_truck_data : [RegTruckDetailModel] = []
    
    var Reg_truck_type = ""
    var Reg_truck_sub_category = ""
    var Reg_truck_weight = ""
    var Reg_weight_unit = ""
    var Reg_truck_capacity = ""
    var Reg_capacity_unit = ""
    var Reg_pallets : [TruckCapacityType] = []
    var Reg_truck_plat_number = ""
    var Reg_truck_images : [String] = []

    var Reg_id_proof : [String] = []
    var Reg_license : [String] = []
    var Reg_licenseBack : [String] = []
    var Reg_license_number = ""
    var Reg_license_expiry_date = ""
    
    var Reg_payment_type = "0"
    var Reg_payment_iban = ""
    var Reg_payment_account_number = ""
    var Reg_payment_bank_name = ""
    var Reg_payment_country = ""
    
    //Extra for new reg
    var Reg_trailer_plat_number = ""
    var Reg_brand = ""
    var Reg_truck_features : [String] = []
    var Reg_fuel_type = ""
    var Reg_vehicle_images : [String] = []
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
    var pickUpType = ""
}

struct RegTruckDetailModel : Codable {
    
    var id = ""
    var truck_type = ""
    var truck_sub_category = ""
    var weight = ""
    var weight_unit = ""
    var capacity = ""
    var capacity_unit = ""
    var pallets : [TruckCapacityType] = []
    var plate_number = ""
    var images = ""
    var imageWithUrl = ""
    var truck_features = ""
    var default_truck = "0"
    
    static func == (lhs:RegTruckDetailModel,rhs:RegTruckDetailModel ) -> Bool{
        
        if lhs.pallets.count != rhs.pallets.count{
            return false
        }
        for capacity in lhs.pallets{
            if rhs.pallets.first(where: {($0.capacity == capacity.capacity && $0.type == capacity.type)}) == nil{
                return false
            }
        }
        
        let lhsFeature = lhs.truck_features.components(separatedBy: ",")
        let rhsFeature = rhs.truck_features.components(separatedBy: ",")
        
        if lhsFeature.count != rhsFeature.count{
            return false
        }
        for fearure in lhsFeature{
            if !rhsFeature.contains(fearure){
                return false
            }
        }
        
        if lhs.id != rhs.id{
            return false
        }else if lhs.truck_type != rhs.truck_type{
            return false
        }else if lhs.truck_sub_category != rhs.truck_sub_category{
            return false
        }else if lhs.weight != rhs.weight{
            return false
        }else if lhs.weight_unit != rhs.weight_unit{
            return false
        }else if lhs.capacity != rhs.capacity{
            return false
        }else if lhs.capacity_unit != rhs.capacity_unit{
            return false
        }else if lhs.plate_number != rhs.plate_number{
            return false
        }else if lhs.images != rhs.images{
            return false
        }else if lhs.default_truck != rhs.default_truck{
            return false
        }else{
            return true
        }
    }
    
}
