//
//  Permission.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 30, 2021

import Foundation

struct LoginPermission : Codable {

        let allowBid : Int?
        let changePassword : Int?
        let createdAt : String?
        let id : Int?
        let myLoads : Int?
        let myProfile : Int?
        let postAvailibility : Int?
        let searchLoads : Int?
        let settings : Int?
        let statistics : Int?
        let userId : Int?
        let viewPrice : Int?

        enum CodingKeys: String, CodingKey {
                case allowBid = "allow_bid"
                case changePassword = "change_password"
                case createdAt = "created_at"
                case id = "id"
                case myLoads = "my_loads"
                case myProfile = "my_profile"
                case postAvailibility = "post_availibility"
                case searchLoads = "search_loads"
                case settings = "settings"
                case statistics = "statistics"
                case userId = "user_id"
                case viewPrice = "view_price"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                allowBid = try values?.decodeIfPresent(Int.self, forKey: .allowBid)
                changePassword = try values?.decodeIfPresent(Int.self, forKey: .changePassword)
                createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                myLoads = try values?.decodeIfPresent(Int.self, forKey: .myLoads)
                myProfile = try values?.decodeIfPresent(Int.self, forKey: .myProfile)
                postAvailibility = try values?.decodeIfPresent(Int.self, forKey: .postAvailibility)
                searchLoads = try values?.decodeIfPresent(Int.self, forKey: .searchLoads)
                settings = try values?.decodeIfPresent(Int.self, forKey: .settings)
                statistics = try values?.decodeIfPresent(Int.self, forKey: .statistics)
                userId = try values?.decodeIfPresent(Int.self, forKey: .userId)
                viewPrice = try values?.decodeIfPresent(Int.self, forKey: .viewPrice)
        }

}
