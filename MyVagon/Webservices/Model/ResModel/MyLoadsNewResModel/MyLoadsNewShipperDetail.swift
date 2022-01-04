//
//  MyLoadsNewShipperDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation

struct MyLoadsNewShipperDetail : Codable {
    
    let id: Int?
    let name, profile, companyName: String?
    let shipperRating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, profile
        case companyName = "company_name"
        case shipperRating = "shipper_rating"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        profile = try? values.decodeIfPresent(String.self, forKey: .profile)
        companyName = try? values.decodeIfPresent(String.self, forKey: .companyName)
        shipperRating = try? values.decodeIfPresent(Double.self, forKey: .shipperRating)
    }
    
}
