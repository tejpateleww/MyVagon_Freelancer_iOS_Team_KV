//
//  EditTrucksReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 16/03/22.
//

import Foundation
class EditTruckReqModel: Encodable{
    
    var truck_details : String?
    
    enum CodingKeys: String, CodingKey {
        case truck_details = "truck_details"
    }
}
class TruckEditReqModel: Encodable{
    
    var id: Int?
    var truck_type: Int?
    var truck_sub_category: Int?
    var truck_features: String?
    var weight: String?
    var weight_unit: Int?
    var capacity: String?
    var capacity_unit: Int?
    var pallets: [Pallets]?
    var plate_number: String?
    var images: String?
    var default_truck: Int?

enum CodingKeys: String, CodingKey {
    case id = "id"
    case truck_type = "truck_type"
    case truck_sub_category = "truck_sub_category"
    case truck_features = "truck_features"
    case weight = "weight"
    case weight_unit = "weight_unit"
    case capacity = "capacity"
    case capacity_unit = "capacity_unit"
    case pallets = "pallets"
    case plate_number = "plate_number"
    case images = "images"
    case default_truck = "default_truck"
}
}
class Pallets: Encodable{
    
    var id : Int?
    var value : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case value = "value"
    }
}
