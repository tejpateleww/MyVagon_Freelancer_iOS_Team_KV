//
//  RegisterReqModel.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import Foundation
class RegisterReqModel : Encodable {
    var fullname,country_code,mobile_number,email,password : String?
    
    var truck_type,truck_sub_category,truck_weight,weight_unit,truck_capacity,capacity_unit : String?
    
    var brand,pallets,load_capacity,fuel_type,registration_no	: String?
    
    var vehicle_images,id_proof,license :[String]?

    enum CodingKeys: String, CodingKey {
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
        case brand = "brand"
        case pallets = "pallets"
        case load_capacity = "load_capacity"
        case fuel_type = "fuel_type"
        case registration_no = "registration_no"
        case vehicle_images = "vehicle_images"
        case id_proof = "id_proof"
        case license = "license"
    }
}
