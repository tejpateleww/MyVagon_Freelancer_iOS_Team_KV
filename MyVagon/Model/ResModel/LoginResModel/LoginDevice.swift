//
//  LoginDevice.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 18, 2021

import Foundation

struct LoginDevice : Codable {

        let appType : String?
        let createdAt : String?
        let id : Int?
        let lat : String?
        let lng : String?
        let name : String?
        let token : String?
        let type : String?
        let updatedAt : String?
        let userId : Int?

        enum CodingKeys: String, CodingKey {
                case appType = "app_type"
                case createdAt = "created_at"
                case id = "id"
                case lat = "lat"
                case lng = "lng"
                case name = "name"
                case token = "token"
                case type = "type"
                case updatedAt = "updated_at"
                case userId = "user_id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                appType = try values?.decodeIfPresent(String.self, forKey: .appType)
                createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                lat = try values?.decodeIfPresent(String.self, forKey: .lat)
                lng = try values?.decodeIfPresent(String.self, forKey: .lng)
                name = try values?.decodeIfPresent(String.self, forKey: .name)
                token = try values?.decodeIfPresent(String.self, forKey: .token)
                type = try values?.decodeIfPresent(String.self, forKey: .type)
                updatedAt = try values?.decodeIfPresent(String.self, forKey: .updatedAt)
                userId = try values?.decodeIfPresent(Int.self, forKey: .userId)
        }

}
