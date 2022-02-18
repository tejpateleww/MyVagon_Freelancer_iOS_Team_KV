//
//  InitResModel.swift
//  MyVagon
//
//  Created by Apple on 21/12/21.
//

import Foundation
class InitResModel : Codable {
    
    let message : String?

    let status : Bool?
    let data : InitDatum?
    
    enum CodingKeys: String, CodingKey {
      
        case message = "message"
        case status = "status"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
      
     
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        data = try? values.decodeIfPresent(InitDatum.self, forKey: .data)
    }
    
}
class InitDatum : Codable {
    
  
    let bookingData : MyLoadsNewBid?
    let updateLocationInterval : Int?

    enum CodingKeys: String, CodingKey {
        case bookingData = "booking"
        case updateLocationInterval = "update_location_interval"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
 
        bookingData = try? values.decodeIfPresent(MyLoadsNewBid.self, forKey: .bookingData)
        updateLocationInterval = try? values.decodeIfPresent(Int.self, forKey: .updateLocationInterval)
    }
    
}
