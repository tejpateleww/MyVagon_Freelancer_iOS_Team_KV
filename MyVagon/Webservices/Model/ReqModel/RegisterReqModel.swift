//
//  RegisterReqModel.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import Foundation
class RegisterReqModel : Encodable {
    var device_name,device_token,device_type,app_version : String?
    var fullname,country_code,mobile_number,email,password : String?
    
    var truck_type,truck_sub_category,truck_weight,weight_unit,truck_capacity,capacity_unit,plate_number_truck,plate_number_trailer : String?
    
    var brand,pallets,fuel_type,truck_features	: String?
    
    var vehicle_images,id_proof,license,license_number,license_expiry_date :String?

    enum CodingKeys: String, CodingKey {
        case device_name = "device_name"
        case device_token = "device_token"
        case device_type = "device_type"
        case app_version = "app_version"
        case fullname = "fullname"
        case country_code = "country_code"
        case mobile_number = "mobile_number"
        case email = "email"
        case password = "password"
        case truck_type = "truck_type"
        case truck_sub_category = "truck_sub_category"
        case truck_weight = "truck_weight"
        case weight_unit = "weight_unit"
        case truck_capacity = "truck_capacity"
        case capacity_unit = "capacity_unit"
        case plate_number_truck = "plate_number_truck"
        case plate_number_trailer = "plate_number_trailer"
        
        case brand = "brand"
        case pallets = "pallets"
        case truck_features = "truck_features"
      
        case fuel_type = "fuel_type"
        case vehicle_images = "vehicle_images"
        case id_proof = "id_proof"
        case license = "license"
        case license_number = "license_number"
        case license_expiry_date = "license_expiry_date"
    }
}
class MobileVerifyReqModel : Encodable {
    var mobile_number : String?

    enum CodingKeys: String, CodingKey {
        case mobile_number = "mobile_number"
        
    }
}
class EmailVerifyReqModel : Encodable {
    var email : String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        
    }
}
class ProfileEditReqModel : Encodable {
  
    var fullname,country_code,mobile_number,profile_image : String?
    
    var truck_type,truck_sub_category,truck_weight,weight_unit,truck_capacity,capacity_unit,plate_number_truck,plate_number_trailer : String?
    
    var brand,pallets,fuel_type,truck_features    : String?
    
    var vehicle_images,id_proof,license,license_number,license_expiry_date :String?

    enum CodingKeys: String, CodingKey {
       
        case fullname = "fullname"
        case country_code = "country_code"
        case mobile_number = "mobile_number"
        case profile_image = "profile_image"
        case truck_type = "truck_type"
        case truck_sub_category = "truck_sub_category"
        case truck_weight = "truck_weight"
        case weight_unit = "weight_unit"
        case truck_capacity = "truck_capacity"
        case capacity_unit = "capacity_unit"
        case plate_number_truck = "plate_number_truck"
        case plate_number_trailer = "plate_number_trailer"
        case brand = "brand"
        case pallets = "pallets"
        case truck_features = "truck_features"
        case fuel_type = "fuel_type"
        case vehicle_images = "vehicle_images"
        case id_proof = "id_proof"
        case license = "license"
        case license_number = "license_number"
        case license_expiry_date = "license_expiry_date"
    }
}
