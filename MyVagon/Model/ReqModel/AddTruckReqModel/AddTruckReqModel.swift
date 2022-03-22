//
//  AddTruckReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 21/03/22.
//

import Foundation
class AddTruckReqModel: Encodable{
    
    var truck_details : String?
    
    enum CodingKeys: String, CodingKey {
        case truck_details = "truck_details"
    }
}
