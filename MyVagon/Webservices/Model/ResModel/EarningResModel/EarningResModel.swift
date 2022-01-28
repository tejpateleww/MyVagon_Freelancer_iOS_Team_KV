//
//	EarningResModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct EarningResModel : Codable {

	let data : [Earning]?
	let message : String?
	let status : Bool?


	enum CodingKeys: String, CodingKey {
		case data = "data"
		case message = "message"
		case status = "status"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([Earning].self, forKey: .data)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
	}


}

struct Earning : Codable {

    let amount : String?
    let bookingData : BookingData?
    let bookingId : Int?
    let createdAt : String?
    let date : String?
    let deletedAt : String?
    let driverId : Int?
    let id : Int?
    let status : String?
    let transactionId : String?
    let transactionType : String?
    let updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case bookingData
        case bookingId = "booking_id"
        case createdAt = "created_at"
        case date = "date"
        case deletedAt = "deleted_at"
        case driverId = "driver_id"
        case id = "id"
        case status = "status"
        case transactionId = "transaction_id"
        case transactionType = "transaction_type"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        bookingData = try BookingData(from: decoder)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        deletedAt = try values.decodeIfPresent(String.self, forKey: .deletedAt)
        driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        transactionType = try values.decodeIfPresent(String.self, forKey: .transactionType)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct BookingData : Codable {

    let amount : String?
    let bookingType : String?
    let cancellationCharge : String?
    let cancellationTerm : String?
    let createdAt : String?
    let deletedAt : String?
    let distance : String?
    let emailOrNumber : String?
    let endTrip : String?
    let id : Int?
    let isBid : Int?
    let isPublic : Int?
    let isTracking : Int?
    let journey : String?
    let journeyType : String?
    let paymentStatus : String?
    let pickupAddress : String?
    let pickupDate : String?
    let pickupLat : String?
    let pickupLng : String?
    let pickupNote : String?
    let pickupTimeFrom : String?
    let pickupTimeTo : String?
    let podImage : String?
    let rateShipper : Int?
    let shipperCancelDriver : String?
    let shipperDetails : ShipperDetail?
    let status : String?
    let transactionId : Int?
    let trucks : Truck?
    let txnId : String?
    let updatedAt : String?
    let userId : Int?


    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case bookingType = "booking_type"
        case cancellationCharge = "cancellation_charge"
        case cancellationTerm = "cancellation_term"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case distance = "distance"
        case emailOrNumber = "email_or_number"
        case endTrip = "end_trip"
        case id = "id"
        case isBid = "is_bid"
        case isPublic = "is_public"
        case isTracking = "is_tracking"
        case journey = "journey"
        case journeyType = "journey_type"
        case paymentStatus = "payment_status"
        case pickupAddress = "pickup_address"
        case pickupDate = "pickup_date"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case pickupNote = "pickup_note"
        case pickupTimeFrom = "pickup_time_from"
        case pickupTimeTo = "pickup_time_to"
        case podImage = "pod_image"
        case rateShipper = "rate_shipper"
        case shipperCancelDriver = "shipper_cancel_driver"
        case shipperDetails
        case status = "status"
        case transactionId = "transaction_id"
        case trucks
        case txnId = "txn_id"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        bookingType = try values.decodeIfPresent(String.self, forKey: .bookingType)
        cancellationCharge = try values.decodeIfPresent(String.self, forKey: .cancellationCharge)
        cancellationTerm = try values.decodeIfPresent(String.self, forKey: .cancellationTerm)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        deletedAt = try values.decodeIfPresent(String.self, forKey: .deletedAt)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        emailOrNumber = try values.decodeIfPresent(String.self, forKey: .emailOrNumber)
        endTrip = try values.decodeIfPresent(String.self, forKey: .endTrip)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isBid = try values.decodeIfPresent(Int.self, forKey: .isBid)
        isPublic = try values.decodeIfPresent(Int.self, forKey: .isPublic)
        isTracking = try values.decodeIfPresent(Int.self, forKey: .isTracking)
        journey = try values.decodeIfPresent(String.self, forKey: .journey)
        journeyType = try values.decodeIfPresent(String.self, forKey: .journeyType)
        paymentStatus = try values.decodeIfPresent(String.self, forKey: .paymentStatus)
        pickupAddress = try values.decodeIfPresent(String.self, forKey: .pickupAddress)
        pickupDate = try values.decodeIfPresent(String.self, forKey: .pickupDate)
        pickupLat = try values.decodeIfPresent(String.self, forKey: .pickupLat)
        pickupLng = try values.decodeIfPresent(String.self, forKey: .pickupLng)
        pickupNote = try values.decodeIfPresent(String.self, forKey: .pickupNote)
        pickupTimeFrom = try values.decodeIfPresent(String.self, forKey: .pickupTimeFrom)
        pickupTimeTo = try values.decodeIfPresent(String.self, forKey: .pickupTimeTo)
        podImage = try values.decodeIfPresent(String.self, forKey: .podImage)
        rateShipper = try values.decodeIfPresent(Int.self, forKey: .rateShipper)
        shipperCancelDriver = try values.decodeIfPresent(String.self, forKey: .shipperCancelDriver)
        shipperDetails = try ShipperDetail(from: decoder)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        transactionId = try values.decodeIfPresent(Int.self, forKey: .transactionId)
        trucks = try Truck(from: decoder)
        txnId = try values.decodeIfPresent(String.self, forKey: .txnId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}

struct Truck : Codable {

    let bookingId : Int?
    let createdAt : String?
    let driverId : Int?
    let id : Int?
    let isCooling : Int?
    let isHydraulic : Int?
    let locations : [Location]?
    let note : String?
    let payout : String?
    let truckId : Int?
    let truckType : Int?
    let truckTypeCategory : [ProductId]?
    let updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case createdAt = "created_at"
        case driverId = "driver_id"
        case id = "id"
        case isCooling = "is_cooling"
        case isHydraulic = "is_hydraulic"
        case locations = "locations"
        case note = "note"
        case payout = "payout"
        case truckId = "truck_id"
        case truckType = "truck_type"
        case truckTypeCategory = "truck_type_category"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isCooling = try values.decodeIfPresent(Int.self, forKey: .isCooling)
        isHydraulic = try values.decodeIfPresent(Int.self, forKey: .isHydraulic)
        locations = try values.decodeIfPresent([Location].self, forKey: .locations)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        payout = try values.decodeIfPresent(String.self, forKey: .payout)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        truckType = try values.decodeIfPresent(Int.self, forKey: .truckType)
        truckTypeCategory = try values.decodeIfPresent([ProductId].self, forKey: .truckTypeCategory)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }


}

struct Location : Codable {

    let arrivedAt : String?
    let bookingId : Int?
    let companyName : String?
    let createdAt : String?
    let deadhead : String?
    let deliveredAt : String?
    let deliveryTimeFrom : String?
    let deliveryTimeTo : String?
    let distance : String?
    let dropLat : String?
    let dropLng : String?
    let dropLocation : String?
    let id : Int?
    let isPickup : Int?
    let journey : String?
    let note : String?
    let otp : String?
    let products : [Product]?
    let startJourney : String?
    let startLoading : String?
    let truckId : Int?
    let updatedAt : String?
    let verifyOtp : Int?


    enum CodingKeys: String, CodingKey {
        case arrivedAt = "arrived_at"
        case bookingId = "booking_id"
        case companyName = "company_name"
        case createdAt = "created_at"
        case deadhead = "deadhead"
        case deliveredAt = "delivered_at"
        case deliveryTimeFrom = "delivery_time_from"
        case deliveryTimeTo = "delivery_time_to"
        case distance = "distance"
        case dropLat = "drop_lat"
        case dropLng = "drop_lng"
        case dropLocation = "drop_location"
        case id = "id"
        case isPickup = "is_pickup"
        case journey = "journey"
        case note = "note"
        case otp = "otp"
        case products = "products"
        case startJourney = "start_journey"
        case startLoading = "start_loading"
        case truckId = "truck_id"
        case updatedAt = "updated_at"
        case verifyOtp = "verify_otp"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        arrivedAt = try values.decodeIfPresent(String.self, forKey: .arrivedAt)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        deadhead = try values.decodeIfPresent(String.self, forKey: .deadhead)
        deliveredAt = try values.decodeIfPresent(String.self, forKey: .deliveredAt)
        deliveryTimeFrom = try values.decodeIfPresent(String.self, forKey: .deliveryTimeFrom)
        deliveryTimeTo = try values.decodeIfPresent(String.self, forKey: .deliveryTimeTo)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        dropLat = try values.decodeIfPresent(String.self, forKey: .dropLat)
        dropLng = try values.decodeIfPresent(String.self, forKey: .dropLng)
        dropLocation = try values.decodeIfPresent(String.self, forKey: .dropLocation)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isPickup = try values.decodeIfPresent(Int.self, forKey: .isPickup)
        journey = try values.decodeIfPresent(String.self, forKey: .journey)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
        startJourney = try values.decodeIfPresent(String.self, forKey: .startJourney)
        startLoading = try values.decodeIfPresent(String.self, forKey: .startLoading)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        verifyOtp = try values.decodeIfPresent(Int.self, forKey: .verifyOtp)
    }


}

struct Product : Codable {

    let bookingId : Int?
    let createdAt : String?
    let id : Int?
    let isFragile : Int?
    let isPickup : Int?
    let isSensetive : Int?
    let locationId : Int?
    let note : String?
    let productId : ProductId?
    let productType : ProductId?
    let qty : String?
    let unit : ProductId?
    let updatedAt : String?
    let weight : String?


    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case createdAt = "created_at"
        case id = "id"
        case isFragile = "is_fragile"
        case isPickup = "is_pickup"
        case isSensetive = "is_sensetive"
        case locationId = "location_id"
        case note = "note"
        case productId
        case productType
        case qty = "qty"
        case unit
        case updatedAt = "updated_at"
        case weight = "weight"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isFragile = try values.decodeIfPresent(Int.self, forKey: .isFragile)
        isPickup = try values.decodeIfPresent(Int.self, forKey: .isPickup)
        isSensetive = try values.decodeIfPresent(Int.self, forKey: .isSensetive)
        locationId = try values.decodeIfPresent(Int.self, forKey: .locationId)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        productId = try ProductId(from: decoder)
        productType = try ProductId(from: decoder)
        qty = try values.decodeIfPresent(String.self, forKey: .qty)
        unit = try ProductId(from: decoder)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
    }


}


struct ProductId : Codable {

    let id : Int?
    let name : String?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }


}

struct ShipperDetail : Codable {

    let companyName : String?
    let id : Int?
    let name : String?
    let profile : String?
    let shipperRating : Int?


    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case id = "id"
        case name = "name"
        case profile = "profile"
        case shipperRating = "shipper_rating"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
        shipperRating = try values.decodeIfPresent(Int.self, forKey: .shipperRating)
    }


}
