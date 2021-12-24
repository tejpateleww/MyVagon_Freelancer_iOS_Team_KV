//
//  BookingLoadDetailsResModel.swift
//  MyVagon
//
//  Created by Apple on 23/12/21.
//

import Foundation
class BookingLoadDetailsResModel : Codable {
    
    let message : String?

    let status : Bool?
    let data : MyLoadsNewBid?
    
    enum CodingKeys: String, CodingKey {
      
        case message = "message"
        case status = "status"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
      
     
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        data = try? values.decodeIfPresent(MyLoadsNewBid.self, forKey: .data)
    }
    
}
