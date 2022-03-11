//
//  ReviewResModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 10/03/22.
//

import Foundation
struct ReviewResModel: Codable {

    var status: Bool?
    var message: String?
    var data: ReviewData?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decode(Bool.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
        data = try? values.decode(ReviewData.self, forKey: .data)
    }

}
struct ReviewData: Codable {

    var id: Int?
    var name: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var profile: String?
    var phone: String?
    var countryCode: String?
    var selfDes: String?
    var type: String?
    var companyRefId: String?
    var companyName: String?
    var postcode: String?
    var city: String?
    var state: String?
    var country: Int?
    var ssn: String?
    var companyPhone: String?
    var emailVerify: String?
    var phoneVerify: String?
    var emailVerifiedAt: String?
    var status: Int?
    var blockStatus: String?
    var stage: String?
    var licenceNumber: String?
    var licenceExpiryDate: String?
    var busy: String?
    var isAssing: Int?
    var commissionFee: Int?
    var paymentType: Int?
    var createdAt: String?
    var updatedAt: String?
    var review: [Review]?
    var oneStarRatingCount: Int?
    var twoStarRatingCount: Int?
    var threeStarRatingCount: Int?
    var fourStarRatingCount: Int?
    var fiveStarRatingCount: Int?
    var shipperRating: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case profile = "profile"
        case phone = "phone"
        case countryCode = "country_code"
        case selfDes = "self_des"
        case type = "type"
        case companyRefId = "company_ref_id"
        case companyName = "company_name"
        case postcode = "postcode"
        case city = "city"
        case state = "state"
        case country = "country"
        case ssn = "ssn"
        case companyPhone = "company_phone"
        case emailVerify = "email_verify"
        case phoneVerify = "phone_verify"
        case emailVerifiedAt = "email_verified_at"
        case status = "status"
        case blockStatus = "block_status"
        case stage = "stage"
        case licenceNumber = "licence_number"
        case licenceExpiryDate = "licence_expiry_date"
        case busy = "busy"
        case isAssing = "is_assing"
        case commissionFee = "commission_fee"
        case paymentType = "payment_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case review = "review"
        case oneStarRatingCount = "one_star_rating_count"
        case twoStarRatingCount = "two_star_rating_count"
        case threeStarRatingCount = "three_star_rating_count"
        case fourStarRatingCount = "four_star_rating_count"
        case fiveStarRatingCount = "five_star_rating_count"
        case shipperRating = "shipper_rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        firstName = try? values.decode(String.self, forKey: .firstName)
        lastName = try? values.decode(String.self, forKey: .lastName)
        email = try? values.decode(String.self, forKey: .email)
        profile = try? values.decode(String.self, forKey: .profile)
        phone = try? values.decode(String.self, forKey: .phone)
        countryCode = try? values.decode(String.self, forKey: .countryCode)
        selfDes = try? values.decode(String.self, forKey: .selfDes)
        type = try? values.decode(String.self, forKey: .type)
        companyRefId = try? values.decode(String.self, forKey: .companyRefId)
        companyName = try? values.decode(String.self, forKey: .companyName)
        postcode = try? values.decode(String.self, forKey: .postcode)
        city = try? values.decode(String.self, forKey: .city)
        state = try? values.decode(String.self, forKey: .state)
        country = try? values.decode(Int.self, forKey: .country)
        ssn = try? values.decode(String.self, forKey: .ssn)
        companyPhone = try? values.decode(String.self, forKey: .companyPhone)
        emailVerify = try? values.decode(String.self, forKey: .emailVerify)
        phoneVerify = try? values.decode(String.self, forKey: .phoneVerify)
        emailVerifiedAt = try? values.decode(String.self, forKey: .emailVerifiedAt)
        status = try? values.decode(Int.self, forKey: .status)
        blockStatus = try? values.decode(String.self, forKey: .blockStatus)
        stage = try? values.decode(String.self, forKey: .stage)
        licenceNumber = try? values.decode(String.self, forKey: .licenceNumber)
        licenceExpiryDate = try? values.decode(String.self, forKey: .licenceExpiryDate)
        busy = try? values.decode(String.self, forKey: .busy)
        isAssing = try? values.decode(Int.self, forKey: .isAssing)
        commissionFee = try? values.decode(Int.self, forKey: .commissionFee)
        paymentType = try? values.decode(Int.self, forKey: .paymentType)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        updatedAt = try? values.decode(String.self, forKey: .updatedAt)
        review = try? values.decode([Review].self, forKey: .review)
        oneStarRatingCount = try? values.decode(Int.self, forKey: .oneStarRatingCount)
        twoStarRatingCount = try? values.decode(Int.self, forKey: .twoStarRatingCount)
        threeStarRatingCount = try? values.decode(Int.self, forKey: .threeStarRatingCount)
        fourStarRatingCount = try? values.decode(Int.self, forKey: .fourStarRatingCount)
        fiveStarRatingCount = try? values.decode(Int.self, forKey: .fiveStarRatingCount)
        shipperRating = try? values.decode(Int.self, forKey: .shipperRating)
    }

}
struct Review: Codable {

    var id: Int?
    var bookingId: Int?
    var fromUserId: FromUserId?
    var toUserId: Int?
    var userType: String?
    var rating: Int?
    var review: String?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bookingId = "booking_id"
        case fromUserId = "from_user_id"
        case toUserId = "to_user_id"
        case userType = "user_type"
        case rating = "rating"
        case review = "review"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        bookingId = try? values.decode(Int.self, forKey: .bookingId)
        fromUserId = try? values.decode(FromUserId.self, forKey: .fromUserId)
        toUserId = try? values.decode(Int.self, forKey: .toUserId)
        userType = try? values.decode(String.self, forKey: .userType)
        rating = try? values.decode(Int.self, forKey: .rating)
        review = try? values.decode(String.self, forKey: .review)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        updatedAt = try? values.decode(String.self, forKey: .updatedAt)
        deletedAt =  try? values.decode(String.self, forKey: .deletedAt)
    }

}
struct FromUserId: Codable {

    var id: Int?
    var name: String?
    var shipperRating: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case shipperRating = "shipper_rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        shipperRating = try? values.decode(Int.self, forKey: .shipperRating)
    }

}
