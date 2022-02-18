//
//  MyLoadsNewTruck.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation

struct MyLoadsNewTruck : Codable {

        let bookingId : Int?
        let createdAt : String?
        let driverId : Int?
        let id : Int?
        let isCooling : Int?
        let isHydraulic : Int?
        let locations : [MyLoadsNewLocation]?
        let note : String?
        let payout : String?
        let truckId : Int?
        let truckType : MyLoadsNewTruckType?
        let truckTypeCategory : [MyLoadsNewTruckTypeCategory]?
        let updatedAt : String?

        enum CodingKeys: String, CodingKey {
                case bookingId = "booking_id"
                case createdAt = "created_at"
                case driverId = "driver_id"
                case id = "id"
                case isCooling = "is_cooling"
                case isHydraulic = "is_hydraulic"
                case locations = "locations"
                case note = "note"
                case payout = "payout"
                case truckId = "truck_id"
                case truckType = "truck_type"
                case truckTypeCategory = "truck_type_category"
                case updatedAt = "updated_at"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bookingId = try? values.decodeIfPresent(Int.self, forKey: .bookingId)
                createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
                driverId = try? values.decodeIfPresent(Int.self, forKey: .driverId)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                isCooling = try? values.decodeIfPresent(Int.self, forKey: .isCooling)
                isHydraulic = try? values.decodeIfPresent(Int.self, forKey: .isHydraulic)
                locations = try? values.decodeIfPresent([MyLoadsNewLocation].self, forKey: .locations)
                note = try? values.decodeIfPresent(String.self, forKey: .note)
                payout = try? values.decodeIfPresent(String.self, forKey: .payout)
                truckId = try? values.decodeIfPresent(Int.self, forKey: .truckId)
                truckType = try? values.decodeIfPresent(MyLoadsNewTruckType.self, forKey: .truckType)
                truckTypeCategory = try? values.decodeIfPresent([MyLoadsNewTruckTypeCategory].self, forKey: .truckTypeCategory)
                updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        }

}
