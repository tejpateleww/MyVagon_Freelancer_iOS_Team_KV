//
//  DeleteUserReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 04/07/22.
//

import Foundation
class DeleteUserReqModel: Encodable{
    var driver_id: String?
    
    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
    }
}
