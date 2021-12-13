//
//  MyLoadsNewShipperDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation

struct MyLoadsNewShipperDetail : Codable {

        let id : Int?
        let name : String?
        let profile : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
                case profile = "profile"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                name = try? values.decodeIfPresent(String.self, forKey: .name)
                profile = try? values.decodeIfPresent(String.self, forKey: .profile)
        }

}
