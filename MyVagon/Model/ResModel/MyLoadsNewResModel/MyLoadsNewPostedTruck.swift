//
//  MyLoadsNewPostedTruck.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation

struct MyLoadsNewPostedTruck : Codable {
    
    let bidAmount : String?
    let bookingId : String?
    let bookingInfo : MyLoadsNewBid?
    let createdAt : String?
    let date : String?
    let driverId : String?
    let endLat : String?
    let endLng : String?
    let displayStatusMessage : String?
    let fromAddress : String?
    let id : Int?
    let isBid : Int?
    let loadStatus : String?
    let startLat : String?
    let startLng : String?
    let time : String?
    let toAddress : String?
    let truckTypeId : Int?
    let updatedAt : String?
    let bookingRequestCount : Int?
    let matchesCount: Int?
    let count : Int?
    let shipperId : Int?
    let time_difference : Int?
    let offerPrice : String?
    
    enum CodingKeys: String, CodingKey {
        case bidAmount = "bid_amount"
        case bookingId = "booking_id"
        case bookingInfo = "booking_info"
        case createdAt = "created_at"
        case date = "date"
        case driverId = "driver_id"
        case endLat = "end_lat"
        case endLng = "end_lng"
        case fromAddress = "from_address"
        case id = "id"
        case isBid = "is_bid"
        case loadStatus = "load_status"
        case startLat = "start_lat"
        case startLng = "start_lng"
        case time = "time"
        case toAddress = "to_address"
        case truckTypeId = "truck_type_id"
        case updatedAt = "updated_at"
        case matchesCount = "matches_found"
        case bookingRequestCount = "booking_request_count"
        case count = "count"
        case shipperId = "shipper_id"
        case time_difference = "time_difference"
        case offerPrice = "offer_price"
        case displayStatusMessage = "display_status_message"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bidAmount = try? values.decodeIfPresent(String.self, forKey: .bidAmount)
        bookingId = try? values.decodeIfPresent(String.self, forKey: .bookingId)
        bookingInfo = try? values.decodeIfPresent(MyLoadsNewBid.self, forKey: .bookingInfo)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        date = try? values.decodeIfPresent(String.self, forKey: .date)
        driverId = try? values.decodeIfPresent(String.self, forKey: .driverId)
        endLat = try? values.decodeIfPresent(String.self, forKey: .endLat)
        endLng = try? values.decodeIfPresent(String.self, forKey: .endLng)
        fromAddress = try? values.decodeIfPresent(String.self, forKey: .fromAddress)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        isBid = try? values.decodeIfPresent(Int.self, forKey: .isBid)
        loadStatus = try? values.decodeIfPresent(String.self, forKey: .loadStatus)
        startLat = try? values.decodeIfPresent(String.self, forKey: .startLat)
        startLng = try? values.decodeIfPresent(String.self, forKey: .startLng)
        time = try? values.decodeIfPresent(String.self, forKey: .time)
        toAddress = try? values.decodeIfPresent(String.self, forKey: .toAddress)
        truckTypeId = try? values.decodeIfPresent(Int.self, forKey: .truckTypeId)
        displayStatusMessage = try? values.decodeIfPresent(String.self, forKey: .displayStatusMessage)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        matchesCount = try? values.decodeIfPresent(Int.self, forKey: .matchesCount)
        bookingRequestCount = try? values.decodeIfPresent(Int.self, forKey: .bookingRequestCount)
        count = try? values.decodeIfPresent(Int.self, forKey: .count)
        shipperId = try? values.decodeIfPresent(Int.self, forKey: .shipperId)
        time_difference = try? values.decodeIfPresent(Int.self, forKey: .time_difference)
        offerPrice = try? values.decodeIfPresent(String.self, forKey: .offerPrice)
    }
    
}
