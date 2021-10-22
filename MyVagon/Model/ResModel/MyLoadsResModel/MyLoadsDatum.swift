//
//  MyLoadsDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 6, 2021

import Foundation

struct MyLoadsDatum : Codable {

        let loadsData : [MyLoadsLoadsDatum]?
        let date : String?

        enum CodingKeys: String, CodingKey {
                case loadsData = "loads_data"
                case date = "date"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
            loadsData = try values?.decodeIfPresent([MyLoadsLoadsDatum].self, forKey: .loadsData)
                date = try values?.decodeIfPresent(String.self, forKey: .date)
        }

}
