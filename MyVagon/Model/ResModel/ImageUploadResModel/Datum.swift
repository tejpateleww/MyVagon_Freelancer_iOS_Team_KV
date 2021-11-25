//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 3, 2021

import Foundation

struct Datum : Codable {

        let images : [String]?

        enum CodingKeys: String, CodingKey {
                case images = "images"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                images = try? values.decodeIfPresent([String].self, forKey: .images)
        }

}
