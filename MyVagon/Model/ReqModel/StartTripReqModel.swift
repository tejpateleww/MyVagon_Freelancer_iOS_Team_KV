//
//  StartTripReqModel.swift
//  MyVagon
//
//  Created by Harshit K on 22/03/22.
//

import Foundation

class StartTripReqModel : Encodable {
    var driver_id: String?
    var booking_id: String?
    var shipper_id: String?
    var location_id: String?
    

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case shipper_id = "shipper_id"
        case location_id = "location_id"
    }
}
