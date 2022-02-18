//
//  SettingReqModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
class SettingsReqModel : Encodable {
    var notification,message,bid_received,bid_accepted,load_assign_by_dispatcher,start_trip_reminder,complete_trip_reminder,pdo_remider,match_shippment_near_you,match_shippment_near_delivery,rate_shipper,user_id : String?

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case notification = "notification"
        case message = "message"
        case bid_received = "bid_received"
        case bid_accepted = "bid_accepted"
        case load_assign_by_dispatcher = "load_assign_by_dispatcher"
        case start_trip_reminder = "start_trip_reminder"
        case complete_trip_reminder = "complete_trip_reminder"
        case pdo_remider = "pdo_remider"
        case match_shippment_near_you = "match_shippment_near_you"
        case match_shippment_near_delivery = "match_shippment_near_delivery"
        case rate_shipper = "rate_shipper"
       
    }
    
    
    
}


class GetSettingsListReqModel : Encodable {
    var user_id : String?

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
    }
}

class StatisticListReqModel : Encodable {
    var driverId : String?

    enum CodingKeys: String, CodingKey {
        case driverId = "driver_id"
    }
}



class GetDriverListReqModel : Encodable {
    var user_id : String?

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
    }
}


class ChangePermissionReqModel : Encodable {
    var user_id : String?
    var search_loads : String?
    var my_loads : String?
    var my_profile : String?
    var settings : String?
    var statistics : String?
    var change_password : String?
    var allow_bid : String?
    var view_price : String?
    var post_availibility : String?
  

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case search_loads = "search_loads"
        case my_loads = "my_loads"
        case my_profile = "my_profile"
        case settings = "settings"
        case statistics = "statistics"
        case change_password = "change_password"
        case allow_bid = "allow_bid"
        case view_price = "view_price"
        case post_availibility = "post_availibility"
        
        
        
        
    }
}
