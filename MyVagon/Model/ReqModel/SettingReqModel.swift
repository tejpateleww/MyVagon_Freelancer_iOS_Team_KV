//
//  SettingReqModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
class SettingsReqModel : Encodable {
    var notification,message,bid_received,bid_accepted,load_assign_by_dispatcher,start_trip_reminder,complete_trip_reminder,pdo_remider,match_shippment_near_you,match_shippment_near_delivery,rate_shipper : String?

    enum CodingKeys: String, CodingKey {
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



