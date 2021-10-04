//
//  HomeBidsDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 22, 2021

import Foundation

struct HomeBidsDatum : Codable {
    
    let amount : String?
    let bookingType : String?
    let cancellationCharge : String?
    let cancellationTerm : String?
    let createdAt : String?
    let deletedAt : String?
    let distance : String?
    let dropDistance : Float?
    let id : Int?
    let isBid : Int?
    let isPublic : Int?
    let journey : String?
    let journeyType : String?
    let pickupAddress : String?
    let pickupDate : String?
    let pickupDistance : Float?
    let pickupLat : String?
    let pickupLng : String?
    let pickupNote : String?
    let pickupTimeFrom : String?
    let pickupTimeTo : String?
    let shipperDetails : HomeShipperDetail?
    let status : String?
    let trucks : HomeTruck?
    let txnId : String?
    let updatedAt : String?
    let totalWeight : String?
    let driverBid : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case bookingType = "booking_type"
        case cancellationCharge = "cancellation_charge"
        case cancellationTerm = "cancellation_term"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case distance = "distance"
        case dropDistance = "drop_distance"
        case id = "id"
        case isBid = "is_bid"
        case isPublic = "is_public"
        case journey = "journey"
        case journeyType = "journey_type"
        case pickupAddress = "pickup_address"
        case pickupDate = "pickup_date"
        case pickupDistance = "pickup_distance"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case pickupNote = "pickup_note"
        case pickupTimeFrom = "pickup_time_from"
        case pickupTimeTo = "pickup_time_to"
        case shipperDetails = "shipper_details"
        case status = "status"
        case trucks = "trucks"
        case txnId = "txn_id"
        case updatedAt = "updated_at"
        case totalWeight = "total_weight"
        case driverBid = "driver_bid"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        amount = try values?.decodeIfPresent(String.self, forKey: .amount)
        bookingType = try values?.decodeIfPresent(String.self, forKey: .bookingType)
        cancellationCharge = try values?.decodeIfPresent(String.self, forKey: .cancellationCharge)
        cancellationTerm = try values?.decodeIfPresent(String.self, forKey: .cancellationTerm)
        createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
        deletedAt = try values?.decodeIfPresent(String.self, forKey: .deletedAt)
        distance = try values?.decodeIfPresent(String.self, forKey: .distance)
        dropDistance = try values?.decodeIfPresent(Float.self, forKey: .dropDistance)
        id = try values?.decodeIfPresent(Int.self, forKey: .id)
        isBid = try values?.decodeIfPresent(Int.self, forKey: .isBid)
        isPublic = try values?.decodeIfPresent(Int.self, forKey: .isPublic)
        journey = try values?.decodeIfPresent(String.self, forKey: .journey)
        journeyType = try values?.decodeIfPresent(String.self, forKey: .journeyType)
        pickupAddress = try values?.decodeIfPresent(String.self, forKey: .pickupAddress)
        pickupDate = try values?.decodeIfPresent(String.self, forKey: .pickupDate)
        pickupDistance = try values?.decodeIfPresent(Float.self, forKey: .pickupDistance)
        pickupLat = try values?.decodeIfPresent(String.self, forKey: .pickupLat)
        pickupLng = try values?.decodeIfPresent(String.self, forKey: .pickupLng)
        pickupNote = try values?.decodeIfPresent(String.self, forKey: .pickupNote)
        pickupTimeFrom = try values?.decodeIfPresent(String.self, forKey: .pickupTimeFrom)
        pickupTimeTo = try values?.decodeIfPresent(String.self, forKey: .pickupTimeTo)
        shipperDetails = try values?.decodeIfPresent(HomeShipperDetail.self, forKey: .shipperDetails)
        status = try values?.decodeIfPresent(String.self, forKey: .status)
        trucks = try values?.decodeIfPresent(HomeTruck.self, forKey: .trucks)
        txnId = try values?.decodeIfPresent(String.self, forKey: .txnId)
        updatedAt = try values?.decodeIfPresent(String.self, forKey: .updatedAt)
        driverBid = try values?.decodeIfPresent(Int.self, forKey: .driverBid)
        totalWeight = try values?.decodeIfPresent(String.self, forKey: .totalWeight)
    }
    
}
