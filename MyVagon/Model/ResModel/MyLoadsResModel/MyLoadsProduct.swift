//
//  MyLoadsProduct.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 6, 2021

import Foundation

struct MyLoadsProduct : Codable {

        let bookingId : Int?
        let createdAt : String?
        let id : Int?
        let isFragile : Int?
        let isSensetive : Int?
        let locationId : Int?
        let note : String?
        let productId : MyLoadsProductId?
        let productType : MyLoadsProductType?
        let qty : Int?
        let unit : MyLoadsUnit?
        let updatedAt : String?
        let weight : String?

        enum CodingKeys: String, CodingKey {
                case bookingId = "booking_id"
                case createdAt = "created_at"
                case id = "id"
                case isFragile = "is_fragile"
                case isSensetive = "is_sensetive"
                case locationId = "location_id"
                case note = "note"
                case productId = "product_id"
                case productType = "product_type"
                case qty = "qty"
                case unit = "unit"
                case updatedAt = "updated_at"
                case weight = "weight"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                bookingId = try values?.decodeIfPresent(Int.self, forKey: .bookingId)
                createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                isFragile = try values?.decodeIfPresent(Int.self, forKey: .isFragile)
                isSensetive = try values?.decodeIfPresent(Int.self, forKey: .isSensetive)
                locationId = try values?.decodeIfPresent(Int.self, forKey: .locationId)
                note = try values?.decodeIfPresent(String.self, forKey: .note)
                productId = try values?.decodeIfPresent(MyLoadsProductId.self, forKey: .productId)  
                productType = try values?.decodeIfPresent(MyLoadsProductType.self, forKey: .productType)
                qty = try values?.decodeIfPresent(Int.self, forKey: .qty)
                unit = try values?.decodeIfPresent(MyLoadsUnit.self, forKey: .unit)
                updatedAt = try values?.decodeIfPresent(String.self, forKey: .updatedAt)
                weight = try values?.decodeIfPresent(String.self, forKey: .weight)
        }

}
