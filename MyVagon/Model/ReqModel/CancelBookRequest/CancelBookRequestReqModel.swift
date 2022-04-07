//
//  CancelBookRequestReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 28/03/22.
//

import Foundation
class CancelBookRequestReqModel: Encodable{
    var driver_id : String?
    var booking_id : String?
    var shipper_id : String?
    var booking_request_id: String?
    var reason : String?
    
    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case shipper_id = "shipper_id"
        case booking_request_id = "booking_request_id"
        case reason = "reason"
    }
}
