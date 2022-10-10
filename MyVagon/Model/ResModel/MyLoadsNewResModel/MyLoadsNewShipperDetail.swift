//
//  MyLoadsNewShipperDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation

struct MyLoadsNewShipperDetail : Codable {
    
    let id: Int?
    let name, profile, companyName: String?
    let shipperRating: String?
    let noOfShipperRated : Int?
    let noOfDriverRated : Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, profile
        case companyName = "company_name"
        case shipperRating = "shipper_rating"
        case noOfShipperRated = "no_of_shipper_rated"
        case noOfDriverRated = "no_of_driver_rated"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        profile = try? values.decodeIfPresent(String.self, forKey: .profile)
        companyName = try? values.decodeIfPresent(String.self, forKey: .companyName)
        shipperRating = try? values.decodeIfPresent(String.self, forKey: .shipperRating)
        noOfDriverRated = try? values.decodeIfPresent(Int.self, forKey: .noOfDriverRated)
        noOfShipperRated = try? values.decodeIfPresent(Int.self, forKey: .noOfShipperRated)
    }
    
}
