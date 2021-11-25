//
//  ShipmentListReqModel.swift
//  MyVagon
//
//  Created by Apple on 16/09/21.
//

import Foundation
class ShipmentListReqModel : Encodable {
    var driver_id : String?
    var page : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case page = "page_num"
    }
}

class BidReqModel : Encodable {
    var driver_id,booking_id,amount : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case amount = "amount"
    }
}
class MyLoadsReqModel : Encodable {
    var driver_id,date,status : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case date = "date"
        case status = "status"
    }
}
class SearchLoadReqModel : Encodable {
    
    var date,truck_type_id,pickup_lat,pickup_lng,delivery_lat,delivery_lng,price_min,price_max,weight_min,weight_max,weight_min_unit,weight_max_unit : String?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case truck_type_id = "truck_type_id"
        case pickup_lat = "pickup_lat"
        case pickup_lng = "pickup_lng"
        case delivery_lat = "delivery_lat"
        case delivery_lng = "delivery_lng"
        case price_min = "price_min"
        case price_max = "price_max"
        case weight_min = "weight_min"
        case weight_max = "weight_max"
        case weight_min_unit = "weight_min_unit"
        case weight_max_unit = "weight_max_unit"
    }
}
