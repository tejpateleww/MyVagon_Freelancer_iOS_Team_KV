//
//  StartTripResModel.swift
//  MyVagon
//
//  Created by Harshit K on 22/03/22.
//

import Foundation


struct StartTripResModel: Codable {

    let status: Bool
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(Bool.self, forKey: .status)
        message = try values.decode(String.self, forKey: .message)
    }

}
