//
//  DriverListWeightUnit.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 18, 2021

import Foundation

struct DriverListWeightUnit : Codable {

        let id : Int?
        let name : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                name = try? values.decodeIfPresent(String.self, forKey: .name)
        }

}
