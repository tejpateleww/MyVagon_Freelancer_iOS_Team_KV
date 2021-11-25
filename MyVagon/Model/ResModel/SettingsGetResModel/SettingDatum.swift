//
//  SettingDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 24, 2021

import Foundation

struct SettingDatum : Codable {

        let bidAccepted : Int?
        let bidReceived : Int?
        let completeTripReminder : Int?
        let id : Int?
        let loadAssignByDispatcher : Int?
        let matchShippmentNearDelivery : Int?
        let matchShippmentNearYou : Int?
        let message : Int?
        let notification : Int?
        let pdoRemider : Int?
        let rateShipper : Int?
        let startTripReminder : Int?
        let userId : Int?

        enum CodingKeys: String, CodingKey {
                case bidAccepted = "bid_accepted"
                case bidReceived = "bid_received"
                case completeTripReminder = "complete_trip_reminder"
                case id = "id"
                case loadAssignByDispatcher = "load_assign_by_dispatcher"
                case matchShippmentNearDelivery = "match_shippment_near_delivery"
                case matchShippmentNearYou = "match_shippment_near_you"
                case message = "message"
                case notification = "notification"
                case pdoRemider = "pdo_remider"
                case rateShipper = "rate_shipper"
                case startTripReminder = "start_trip_reminder"
                case userId = "user_id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bidAccepted = try? values.decodeIfPresent(Int.self, forKey: .bidAccepted)
                bidReceived = try? values.decodeIfPresent(Int.self, forKey: .bidReceived)
                completeTripReminder = try? values.decodeIfPresent(Int.self, forKey: .completeTripReminder)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                loadAssignByDispatcher = try? values.decodeIfPresent(Int.self, forKey: .loadAssignByDispatcher)
                matchShippmentNearDelivery = try? values.decodeIfPresent(Int.self, forKey: .matchShippmentNearDelivery)
                matchShippmentNearYou = try? values.decodeIfPresent(Int.self, forKey: .matchShippmentNearYou)
                message = try? values.decodeIfPresent(Int.self, forKey: .message)
                notification = try? values.decodeIfPresent(Int.self, forKey: .notification)
                pdoRemider = try? values.decodeIfPresent(Int.self, forKey: .pdoRemider)
                rateShipper = try? values.decodeIfPresent(Int.self, forKey: .rateShipper)
                startTripReminder = try? values.decodeIfPresent(Int.self, forKey: .startTripReminder)
                userId = try? values.decodeIfPresent(Int.self, forKey: .userId)
        }

}
