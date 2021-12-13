//
//  DriverPermissionChangeDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 18, 2021

import Foundation

struct DriverPermissionChangeDatum : Codable {

        let allowBid : Int?
        let changePassword : Int?
        let id : Int?
        let myLoads : Int?
        let myProfile : Int?
        let postAvailibility : Int?
        let searchLoads : Int?
        let setting : Int?
        let statistics : Int?
        let userId : Int?
        let viewPrice : Int?

        enum CodingKeys: String, CodingKey {
                case allowBid = "allow_bid"
                case changePassword = "change_password"
                case id = "id"
                case myLoads = "my_loads"
                case myProfile = "my_profile"
                case postAvailibility = "post_availibility"
                case searchLoads = "search_loads"
                case setting = "setting"
                case statistics = "statistics"
                case userId = "user_id"
                case viewPrice = "view_price"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                allowBid = try? values.decodeIfPresent(Int.self, forKey: .allowBid)
                changePassword = try? values.decodeIfPresent(Int.self, forKey: .changePassword)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                myLoads = try? values.decodeIfPresent(Int.self, forKey: .myLoads)
                myProfile = try? values.decodeIfPresent(Int.self, forKey: .myProfile)
                postAvailibility = try? values.decodeIfPresent(Int.self, forKey: .postAvailibility)
                searchLoads = try? values.decodeIfPresent(Int.self, forKey: .searchLoads)
                setting = try? values.decodeIfPresent(Int.self, forKey: .setting)
                statistics = try? values.decodeIfPresent(Int.self, forKey: .statistics)
                userId = try? values.decodeIfPresent(Int.self, forKey: .userId)
                viewPrice = try? values.decodeIfPresent(Int.self, forKey: .viewPrice)
        }

}
