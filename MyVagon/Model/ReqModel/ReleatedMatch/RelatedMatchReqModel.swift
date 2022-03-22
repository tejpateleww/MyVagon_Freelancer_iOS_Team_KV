//
//  RelatedMatchReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/03/22.
//

import Foundation
class RelatedMatchReqModel: Encodable{
    
    var driver_id : String?
    var booking_id : String?
    
    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
    }
}
