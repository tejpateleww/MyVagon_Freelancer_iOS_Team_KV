//
//  PostTruckDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 4, 2021

import Foundation

struct PostTruckDatum : Codable {

        let bidAmount : String?
        let count : Int?
        let createdAt : String?
        let date : String?
        let driverId : String?
        let endLat : String?
        let endLng : String?
        let id : Int?
        let isBid : String?
        let matches : String?
        let startLat : String?
        let startLng : String?
        let time : String?
        let truckTypeId : String?
        let updatedAt : String?

        enum CodingKeys: String, CodingKey {
                case bidAmount = "bid_amount"
                case count = "count"
                case createdAt = "created_at"
                case date = "date"
                case driverId = "driver_id"
                case endLat = "end_lat"
                case endLng = "end_lng"
                case id = "id"
                case isBid = "is_bid"
                case matches = "matches"
                case startLat = "start_lat"
                case startLng = "start_lng"
                case time = "time"
                case truckTypeId = "truck_type_id"
                case updatedAt = "updated_at"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bidAmount = try? values.decodeIfPresent(String.self, forKey: .bidAmount)
                count = try? values.decodeIfPresent(Int.self, forKey: .count)
                createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
                date = try? values.decodeIfPresent(String.self, forKey: .date)
                driverId = try? values.decodeIfPresent(String.self, forKey: .driverId)
                endLat = try? values.decodeIfPresent(String.self, forKey: .endLat)
                endLng = try? values.decodeIfPresent(String.self, forKey: .endLng)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                isBid = try? values.decodeIfPresent(String.self, forKey: .isBid)
                matches = try? values.decodeIfPresent(String.self, forKey: .matches)
                startLat = try? values.decodeIfPresent(String.self, forKey: .startLat)
                startLng = try? values.decodeIfPresent(String.self, forKey: .startLng)
                time = try? values.decodeIfPresent(String.self, forKey: .time)
                truckTypeId = try? values.decodeIfPresent(String.self, forKey: .truckTypeId)
                updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        }

}
