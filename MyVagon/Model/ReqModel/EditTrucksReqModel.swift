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
