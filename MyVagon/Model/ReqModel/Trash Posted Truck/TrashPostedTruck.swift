//
//  TrashPostedTruck.swift
//  MyVagon
//
//  Created by Dhanajay  on 06/04/22.
//

import Foundation
class TrashPostedTruck : Encodable{
    var postedTruckId : String?
   
    enum CodingKeys: String, CodingKey {
        case postedTruckId = "posted_truck_id"
    }
}
