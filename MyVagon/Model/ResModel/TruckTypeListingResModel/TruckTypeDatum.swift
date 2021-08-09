//
//  TruckTypeDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 4, 2021

import Foundation

struct TruckTypeDatum : Codable {

    let category : [TruckTypeCategory]?
        let detetedAt : String?
        let icon : String?
        let id : Int?
        let name : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case category = "category"
                case detetedAt = "deteted_at"
                case icon = "icon"
                case id = "id"
                case name = "name"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
            category = try values?.decodeIfPresent([TruckTypeCategory].self, forKey: .category)
                detetedAt = try values?.decodeIfPresent(String.self, forKey: .detetedAt)
                icon = try values?.decodeIfPresent(String.self, forKey: .icon)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                name = try values?.decodeIfPresent(String.self, forKey: .name)
                status = try values?.decodeIfPresent(Int.self, forKey: .status)
        }

}
import Foundation

struct TruckTypeCategory : Codable {

        let detetedAt : String?
        let id : Int?
        let name : String?
        let status : Int?
        let truckTypeId : Int?

        enum CodingKeys: String, CodingKey {
                case detetedAt = "deteted_at"
                case id = "id"
                case name = "name"
                case status = "status"
                case truckTypeId = "truck_type_id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                detetedAt = try values?.decodeIfPresent(String.self, forKey: .detetedAt)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                name = try values?.decodeIfPresent(String.self, forKey: .name)
                status = try values?.decodeIfPresent(Int.self, forKey: .status)
                truckTypeId = try values?.decodeIfPresent(Int.self, forKey: .truckTypeId)
        }
}
