//
//  ShipmentListReqModel.swift
//  MyVagon
//
//  Created by Apple on 16/09/21.
//

import Foundation
class ShipmentListReqModel : Encodable {
    var driver_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
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
