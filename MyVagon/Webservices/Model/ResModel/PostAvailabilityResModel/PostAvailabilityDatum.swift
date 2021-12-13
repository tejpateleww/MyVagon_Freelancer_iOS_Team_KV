//
//  PostAvailabilityDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 30, 2021

import Foundation

struct PostAvailabilityDatum : Codable {

        let date : String?
        let loadsData : [PostAvailabilityLoadsDatum]?

        enum CodingKeys: String, CodingKey {
                case date = "date"
                case loadsData = "loads_data"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                date = try? values.decodeIfPresent(String.self, forKey: .date)
                loadsData = try? values.decodeIfPresent([PostAvailabilityLoadsDatum].self, forKey: .loadsData)
        }

}
