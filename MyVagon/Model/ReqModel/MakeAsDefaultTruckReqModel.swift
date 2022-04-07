//
//  MakeAsDefaultTruckReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 07/04/22.
//

import Foundation
class MakeAsDefaultTruckReqModel: Encodable {
    var truckDetailId: String?
    
    enum CodingKeys: String, CodingKey {
        case truckDetailId = "truck_detail_id"
    }
}
