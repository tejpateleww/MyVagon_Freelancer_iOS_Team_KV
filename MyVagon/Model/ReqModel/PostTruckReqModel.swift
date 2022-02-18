//
//  PostTruckReqModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
class PostTruckReqModel : Encodable {
    var truck_type_id,driver_id,date,time,start_lat,start_lng,end_lat,end_lng,is_bid,bid_amount,start_location,end_location : String?

    enum CodingKeys: String, CodingKey {
        case truck_type_id = "truck_type_id"
        case driver_id = "driver_id"
        case date = "date"
        case time = "time"
        case start_lat = "start_lat"
        case start_lng = "start_lng"
        case end_lat = "end_lat"
        case end_lng = "end_lng"
        case is_bid = "is_bid"
        case bid_amount = "bid_amount"
        case start_location = "start_address"
        case end_location = "end_address"
       
    }
    
    
    
}
