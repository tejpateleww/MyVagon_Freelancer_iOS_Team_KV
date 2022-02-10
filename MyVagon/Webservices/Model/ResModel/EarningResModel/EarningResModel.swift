//
//	EarningResModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct EarningResModel: Codable {

    let status: Bool?
    let message: String?
    let data: [EarningResData]?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([EarningResData].self, forKey: .data)
    }

}

struct EarningResData: Codable {

    let id: Int?
    let bookingId: Int?
    let driverId: Int?
    let amount: String?
    let transactionId: Int?
    let transactionType: String?
    let status: String?
    let date: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let bookingData: BookingData?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bookingId = "booking_id"
        case driverId = "driver_id"
        case amount = "amount"
        case transactionId = "transaction_id"
        case transactionType = "transaction_type"
        case status = "status"
        case date = "date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case bookingData = "booking_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        transactionId = try values.decodeIfPresent(Int.self, forKey: .transactionId)
        transactionType = try values.decodeIfPresent(String.self, forKey: .transactionType)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        deletedAt = try values.decodeIfPresent(String.self, forKey: .deletedAt)
        bookingData = try values.decodeIfPresent(BookingData.self, forKey: .bookingData)
    }

}

struct BookingData: Codable {

    let id: Int?
    let txnId: String?
    let userId: Int?
    let bookingType: String?
    let pickupAddress: String?
    let pickupLat: String?
    let pickupLng: String?
    let pickupDate: String?
    let pickupTimeTo: String?
    let pickupTimeFrom: String?
    let pickupNote: String?
    let distance: String?
    let journey: String?
    let journeyType: String?
    let isPublic: Int?
    let amount: String?
    let cancellationTerm: String?
    let cancellationCharge: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let isBid: Int?
    let isTracking: Int?
    let emailOrNumber: String?
    let endTrip: String?
    let podImage: String?
    let rateShipper: Int?
    let paymentStatus: String?
    let transactionId: Int?
    let shipperCancelDriver: String?
    let scheduleTime: String?
    let trucks: EarningResTrucks?
    let shipperDetails: ShipperDetails?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case txnId = "txn_id"
        case userId = "user_id"
        case bookingType = "booking_type"
        case pickupAddress = "pickup_address"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case pickupDate = "pickup_date"
        case pickupTimeTo = "pickup_time_to"
        case pickupTimeFrom = "pickup_time_from"
        case pickupNote = "pickup_note"
        case distance = "distance"
        case journey = "journey"
        case journeyType = "journey_type"
        case isPublic = "is_public"
        case amount = "amount"
        case cancellationTerm = "cancellation_term"
        case cancellationCharge = "cancellation_charge"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case isBid = "is_bid"
        case isTracking = "is_tracking"
        case emailOrNumber = "email_or_number"
        case endTrip = "end_trip"
        case podImage = "pod_image"
        case rateShipper = "rate_shipper"
        case paymentStatus = "payment_status"
        case transactionId = "transaction_id"
        case shipperCancelDriver = "shipper_cancel_driver"
        case scheduleTime = "schedule_time"
        case trucks = "trucks"
        case shipperDetails = "shipper_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        txnId = try values.decodeIfPresent(String.self, forKey: .txnId)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        bookingType = try values.decodeIfPresent(String.self, forKey: .bookingType)
        pickupAddress = try values.decodeIfPresent(String.self, forKey: .pickupAddress)
        pickupLat = try values.decodeIfPresent(String.self, forKey: .pickupLat)
        pickupLng = try values.decodeIfPresent(String.self, forKey: .pickupLng)
        pickupDate = try values.decodeIfPresent(String.self, forKey: .pickupDate)
        pickupTimeTo = try values.decodeIfPresent(String.self, forKey: .pickupTimeTo)
        pickupTimeFrom = try values.decodeIfPresent(String.self, forKey: .pickupTimeFrom)
        pickupNote = try values.decodeIfPresent(String.self, forKey: .pickupNote)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        journey = try values.decodeIfPresent(String.self, forKey: .journey)
        journeyType = try values.decodeIfPresent(String.self, forKey: .journeyType)
        isPublic = try values.decodeIfPresent(Int.self, forKey: .isPublic)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        cancellationTerm = try values.decodeIfPresent(String.self, forKey: .cancellationTerm)
        cancellationCharge = try values.decodeIfPresent(String.self, forKey: .cancellationCharge)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        deletedAt = try values.decodeIfPresent(String.self, forKey: .deletedAt)
        isBid = try values.decodeIfPresent(Int.self, forKey: .isBid)
        isTracking = try values.decodeIfPresent(Int.self, forKey: .isTracking)
        emailOrNumber = try values.decodeIfPresent(String.self, forKey: .emailOrNumber)
        endTrip = try values.decodeIfPresent(String.self, forKey: .endTrip)
        podImage = try values.decodeIfPresent(String.self, forKey: .podImage)
        rateShipper = try values.decodeIfPresent(Int.self, forKey: .rateShipper)
        paymentStatus = try values.decodeIfPresent(String.self, forKey: .paymentStatus)
        transactionId = try values.decodeIfPresent(Int.self, forKey: .transactionId)
        shipperCancelDriver = try values.decodeIfPresent(String.self, forKey: .shipperCancelDriver)
        scheduleTime = try values.decodeIfPresent(String.self, forKey: .scheduleTime)
        trucks = try values.decodeIfPresent(EarningResTrucks.self, forKey: .trucks)
        shipperDetails = try values.decodeIfPresent(ShipperDetails.self, forKey: .shipperDetails)
    }

}

struct EarningResTrucks: Codable {

    let id: Int?
    let driverId: Int?
    let bookingId: Int?
    let truckId: Int?
    let payout: String?
    let truckType: Int?
    let truckTypeCategory: [EarningResTruckTypeCategory]?
    let note: String?
    let isHydraulic: Int?
    let isCooling: Int?
    let createdAt: String?
    let updatedAt: String?
    let locations: [Locations]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case driverId = "driver_id"
        case bookingId = "booking_id"
        case truckId = "truck_id"
        case payout = "payout"
        case truckType = "truck_type"
        case truckTypeCategory = "truck_type_category"
        case note = "note"
        case isHydraulic = "is_hydraulic"
        case isCooling = "is_cooling"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case locations = "locations"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        payout = try values.decodeIfPresent(String.self, forKey: .payout)
        truckType = try values.decodeIfPresent(Int.self, forKey: .truckType)
        truckTypeCategory = try values.decodeIfPresent([EarningResTruckTypeCategory].self, forKey: .truckTypeCategory)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        isHydraulic = try values.decodeIfPresent(Int.self, forKey: .isHydraulic)
        isCooling = try values.decodeIfPresent(Int.self, forKey: .isCooling)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        locations = try values.decodeIfPresent([Locations].self, forKey: .locations)
    }

}

struct EarningResTruckTypeCategory: Codable {

    let id: Int?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }

}

struct Locations: Codable {

    let id: Int?
    let truckId: Int?
    let bookingId: Int?
    let companyName: String?
    let dropLocation: String?
    let dropLat: String?
    let dropLng: String?
    let distance: String?
    let journey: String?
    let deadhead: String?
    let deliveryTimeFrom: String?
    let deliveryTimeTo: String?
    let isPickup: Int?
    let note: String?
    let deliveredAt: String?
    let createdAt: String?
    let updatedAt: String?
    let otp: String?
    let verifyOtp: Int?
    let arrivedAt: String?
    let startLoading: String?
    let startJourney: String?
    let products: [Products]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case truckId = "truck_id"
        case bookingId = "booking_id"
        case companyName = "company_name"
        case dropLocation = "drop_location"
        case dropLat = "drop_lat"
        case dropLng = "drop_lng"
        case distance = "distance"
        case journey = "journey"
        case deadhead = "deadhead"
        case deliveryTimeFrom = "delivery_time_from"
        case deliveryTimeTo = "delivery_time_to"
        case isPickup = "is_pickup"
        case note = "note"
        case deliveredAt = "delivered_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case otp = "otp"
        case verifyOtp = "verify_otp"
        case arrivedAt = "arrived_at"
        case startLoading = "start_loading"
        case startJourney = "start_journey"
        case products = "products"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        dropLocation = try values.decodeIfPresent(String.self, forKey: .dropLocation)
        dropLat = try values.decodeIfPresent(String.self, forKey: .dropLat)
        dropLng = try values.decodeIfPresent(String.self, forKey: .dropLng)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        journey = try values.decodeIfPresent(String.self, forKey: .journey)
        deadhead = try values.decodeIfPresent(String.self, forKey: .deadhead)
        deliveryTimeFrom = try values.decodeIfPresent(String.self, forKey: .deliveryTimeFrom)
        deliveryTimeTo = try values.decodeIfPresent(String.self, forKey: .deliveryTimeTo)
        isPickup = try values.decodeIfPresent(Int.self, forKey: .isPickup)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        deliveredAt = try values.decodeIfPresent(String.self, forKey: .deliveredAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        verifyOtp = try values.decodeIfPresent(Int.self, forKey: .verifyOtp)
        arrivedAt = try values.decodeIfPresent(String.self, forKey: .arrivedAt)
        startLoading = try values.decodeIfPresent(String.self, forKey: .startLoading)
        startJourney = try values.decodeIfPresent(String.self, forKey: .startJourney)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
    }

}

struct Products: Codable {

    let id: Int?
    let bookingId: Int?
    let locationId: Int?
    let productId: ProductId?
    let productType: ProductType?
    let qty: String?
    let weight: String?
    let unit: Unit?
    let note: String?
    let isFragile: Int?
    let isSensetive: Int?
    let createdAt: String?
    let updatedAt: String?
    let isPickup: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bookingId = "booking_id"
        case locationId = "location_id"
        case productId = "product_id"
        case productType = "product_type"
        case qty = "qty"
        case weight = "weight"
        case unit = "unit"
        case note = "note"
        case isFragile = "is_fragile"
        case isSensetive = "is_sensetive"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isPickup = "is_pickup"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        bookingId = try values.decodeIfPresent(Int.self, forKey: .bookingId)
        locationId = try values.decodeIfPresent(Int.self, forKey: .locationId)
        productId = try values.decodeIfPresent(ProductId.self, forKey: .productId)
        productType = try values.decodeIfPresent(ProductType.self, forKey: .productType)
        qty = try values.decodeIfPresent(String.self, forKey: .qty)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        unit = try values.decodeIfPresent(Unit.self, forKey: .unit)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        isFragile = try values.decodeIfPresent(Int.self, forKey: .isFragile)
        isSensetive = try values.decodeIfPresent(Int.self, forKey: .isSensetive)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        isPickup = try values.decodeIfPresent(Int.self, forKey: .isPickup)
    }

}

struct ProductId: Codable {

    let id: Int?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct ProductType: Codable {

    let id: Int?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Unit: Codable {

    let id: Int?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct ShipperDetails: Codable {

    let id: Int?
    let name: String?
    let profile: String?
    let companyName: String?
    let shipperRating: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case profile = "profile"
        case companyName = "company_name"
        case shipperRating = "shipper_rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        shipperRating = try values.decodeIfPresent(Int.self, forKey: .shipperRating)
    }

}
