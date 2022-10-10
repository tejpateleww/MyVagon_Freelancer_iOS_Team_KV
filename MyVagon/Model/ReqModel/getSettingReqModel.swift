//
//  getSettingReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 23/05/22.
//

import Foundation
class GetSettingReqModel: Encodable{
    var driverId : String?
    enum CodingKeys: String, CodingKey {
        case driverId = "driver_id"
    }
}
