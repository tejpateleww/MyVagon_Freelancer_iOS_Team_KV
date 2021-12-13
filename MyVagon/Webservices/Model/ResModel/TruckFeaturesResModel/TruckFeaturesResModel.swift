//
//  TruckFeaturesResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2021

import Foundation

struct TruckFeaturesResModel : Codable {

        let data : [TruckFeaturesDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try? values.decodeIfPresent([TruckFeaturesDatum].self, forKey: .data)
                message = try? values.decodeIfPresent(String.self, forKey: .message)
                status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
