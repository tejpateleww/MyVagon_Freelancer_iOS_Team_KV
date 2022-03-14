//
//  LocationDetailResModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 14/03/22.
//

import Foundation

struct LocationDetailResModel: Codable {

    let status: Bool?
    let message: String?
    let data: LocationDetailData?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decode(Bool.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
        data = try? values.decode(LocationDetailData.self, forKey: .data)
    }

}

struct LocationDetailData: Codable {

    let id: Int?
    let userId: Int?
    let insertBy: Int?
    let name: String?
    let address: String?
    let city: String?
    let state: String?
    let country: Country?
    let zipcode: Int?
    let phone: String?
    let email: String?
    let addressLat: String?
    let addressLng: String?
    let addressAmenitiesId: String?
    let restroomService: String?
    let foodService: String?
    let restAreaService: String?
    let status: Int?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let note: String?
    let addressAmenities: [AddressAmenities]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case insertBy = "insert_by"
        case name = "name"
        case address = "address"
        case city = "city"
        case state = "state"
        case country = "country"
        case zipcode = "zipcode"
        case phone = "phone"
        case email = "email"
        case addressLat = "address_lat"
        case addressLng = "address_lng"
        case addressAmenitiesId = "address_amenities_id"
        case restroomService = "restroom_service"
        case foodService = "food_service"
        case restAreaService = "rest_area_service"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case note = "note"
        case addressAmenities = "address_amenities"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        userId = try? values.decode(Int.self, forKey: .userId)
        insertBy = try? values.decode(Int.self, forKey: .insertBy)
        name = try? values.decode(String.self, forKey: .name)
        address = try? values.decode(String.self, forKey: .address)
        city = try? values.decode(String.self, forKey: .city)
        state = try? values.decode(String.self, forKey: .state)
        country = try? values.decode(Country.self, forKey: .country)
        zipcode = try? values.decode(Int.self, forKey: .zipcode)
        phone = try? values.decode(String.self, forKey: .phone)
        email = try? values.decode(String.self, forKey: .email)
        addressLat = try? values.decode(String.self, forKey: .addressLat)
        addressLng = try? values.decode(String.self, forKey: .addressLng)
        addressAmenitiesId = try? values.decode(String.self, forKey: .addressAmenitiesId)
        restroomService = try? values.decode(String.self, forKey: .restroomService)
        foodService = try? values.decode(String.self, forKey: .foodService)
        restAreaService = try? values.decode(String.self, forKey: .restAreaService)
        status = try? values.decode(Int.self, forKey: .status)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        updatedAt = try? values.decode(String.self, forKey: .updatedAt)
        deletedAt = try? values.decode(String.self, forKey: .deletedAt)
        note = try? values.decode(String.self, forKey: .note)
        addressAmenities = try? values.decode([AddressAmenities].self, forKey: .addressAmenities)
    }

}
struct Country: Codable {

    let id: Int?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
    }

}
struct AddressAmenities: Codable {

    let id: Int?
    let name: String?
    let flag: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case flag = "flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        flag = try? values.decode(Int.self, forKey: .flag)
    }

}
