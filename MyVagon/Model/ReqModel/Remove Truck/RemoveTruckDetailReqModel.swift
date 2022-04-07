//
//  RemoveTruckDetailReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 31/03/22.
//

import Foundation
class RemoveTruckDetailReqModel: Encodable{
    var truckDetailId : String?
   
    
    enum CodingKeys: String, CodingKey {
        case truckDetailId = "truck_detail_id"
       
    }
}
