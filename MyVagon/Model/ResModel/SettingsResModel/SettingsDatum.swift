//
//  SettingsDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 19, 2021

import Foundation

struct SettingsDatum : Codable {

        let bidAccepted : String?
        let bidReceived : String?
        let completeTripReminder : String?
        let loadAssignByDispatcher : String?
        let matchShippmentNearDelivery : String?
        let matchShippmentNearYou : String?
        let message : String?
        let notification : String?
        let pdoRemider : String?
        let rateShipper : String?
        let startTripReminder : String?

        enum CodingKeys: String, CodingKey {
                case bidAccepted = "bid_accepted"
                case bidReceived = "bid_received"
                case completeTripReminder = "complete_trip_reminder"
                case loadAssignByDispatcher = "load_assign_by_dispatcher"
                case matchShippmentNearDelivery = "match_shippment_near_delivery"
                case matchShippmentNearYou = "match_shippment_near_you"
                case message = "message"
                case notification = "notification"
                case pdoRemider = "pdo_remider"
                case rateShipper = "rate_shipper"
                case startTripReminder = "start_trip_reminder"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bidAccepted = try? values.decodeIfPresent(String.self, forKey: .bidAccepted)
                bidReceived = try? values.decodeIfPresent(String.self, forKey: .bidReceived)
                completeTripReminder = try? values.decodeIfPresent(String.self, forKey: .completeTripReminder)
                loadAssignByDispatcher = try? values.decodeIfPresent(String.self, forKey: .loadAssignByDispatcher)
                matchShippmentNearDelivery = try? values.decodeIfPresent(String.self, forKey: .matchShippmentNearDelivery)
                matchShippmentNearYou = try? values.decodeIfPresent(String.self, forKey: .matchShippmentNearYou)
                message = try? values.decodeIfPresent(String.self, forKey: .message)
                notification = try? values.decodeIfPresent(String.self, forKey: .notification)
                pdoRemider = try? values.decodeIfPresent(String.self, forKey: .pdoRemider)
                rateShipper = try? values.decodeIfPresent(String.self, forKey: .rateShipper)
                startTripReminder = try? values.decodeIfPresent(String.self, forKey: .startTripReminder)
        }

}
