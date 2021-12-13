//
//  MyLoadsLocation.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 6, 2021

import Foundation

struct SearchLocation : Codable {

        let bookingId : Int?
        let companyName : String?
        let createdAt : String?
        let deadhead : String?
        let deliveredAt : String?
        let deliveryTimeFrom : String?
        let deliveryTimeTo : String?
        let distance : String?
        let dropLat : String?
        let dropLng : String?
        let dropLocation : String?
        let id : Int?
        let isPickup : Int?
        let journey : String?
        let note : String?
        let otp : String?
        let products : [SearchProduct]?
        let truckId : Int?
        let updatedAt : String?
        let verifyOtp : Int?

        enum CodingKeys: String, CodingKey {
                case bookingId = "booking_id"
                case companyName = "company_name"
                case createdAt = "created_at"
                case deadhead = "deadhead"
                case deliveredAt = "delivered_at"
                case deliveryTimeFrom = "delivery_time_from"
                case deliveryTimeTo = "delivery_time_to"
                case distance = "distance"
                case dropLat = "drop_lat"
                case dropLng = "drop_lng"
                case dropLocation = "drop_location"
                case id = "id"
                case isPickup = "is_pickup"
                case journey = "journey"
                case note = "note"
                case otp = "otp"
                case products = "products"
                case truckId = "truck_id"
                case updatedAt = "updated_at"
                case verifyOtp = "verify_otp"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bookingId = try? values.decodeIfPresent(Int.self, forKey: .bookingId)
                companyName = try? values.decodeIfPresent(String.self, forKey: .companyName)
                createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
                deadhead = try? values.decodeIfPresent(String.self, forKey: .deadhead)
                deliveredAt = try? values.decodeIfPresent(String.self, forKey: .deliveredAt)
                deliveryTimeFrom = try? values.decodeIfPresent(String.self, forKey: .deliveryTimeFrom)
                deliveryTimeTo = try? values.decodeIfPresent(String.self, forKey: .deliveryTimeTo)
                distance = try? values.decodeIfPresent(String.self, forKey: .distance)
                dropLat = try? values.decodeIfPresent(String.self, forKey: .dropLat)
                dropLng = try? values.decodeIfPresent(String.self, forKey: .dropLng)
                dropLocation = try? values.decodeIfPresent(String.self, forKey: .dropLocation)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                isPickup = try? values.decodeIfPresent(Int.self, forKey: .isPickup)
                journey = try? values.decodeIfPresent(String.self, forKey: .journey)
                note = try? values.decodeIfPresent(String.self, forKey: .note)
                otp = try? values.decodeIfPresent(String.self, forKey: .otp)
                products = try? values.decodeIfPresent([SearchProduct].self, forKey: .products)
                truckId = try? values.decodeIfPresent(Int.self, forKey: .truckId)
                updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
                verifyOtp = try? values.decodeIfPresent(Int.self, forKey: .verifyOtp)
        }

}
