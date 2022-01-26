//
//  ChatMessagesResModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on January 26, 2022
//
import Foundation

struct ChatMessagesResModel: Codable {

    var status: Bool
    var message: String
    var data: [chatData]

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(Bool.self, forKey: .status)
        message = try values.decode(String.self, forKey: .message)
        data = try values.decode([chatData].self, forKey: .data)
    }

}

struct chatData: Codable {

    var receiverId: Int
    var receiverName: String
    var senderId: Int
    var senderName: String
    var createdAt: String
    var message: String

    private enum CodingKeys: String, CodingKey {
        case receiverId = "receiver_id"
        case receiverName = "receiver_name"
        case senderId = "sender_id"
        case senderName = "sender_name"
        case createdAt = "created_at"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        receiverId = try values.decode(Int.self, forKey: .receiverId)
        receiverName = try values.decode(String.self, forKey: .receiverName)
        senderId = try values.decode(Int.self, forKey: .senderId)
        senderName = try values.decode(String.self, forKey: .senderName)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        message = try values.decode(String.self, forKey: .message)
    }

}

struct chatSocketResponseData: Codable {

    var senderId: Int
    var receiverId: String
    var type: Int
    var message: String
    var createdAt: String

    private enum CodingKeys: String, CodingKey {
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case type = "type"
        case message = "message"
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        senderId = try values.decode(Int.self, forKey: .senderId)
        receiverId = try values.decode(String.self, forKey: .receiverId)
        type = try values.decode(Int.self, forKey: .type)
        message = try values.decode(String.self, forKey: .message)
        createdAt = try values.decode(String.self, forKey: .createdAt)
    }

}


struct ChatUserListResModel: Codable {

    let status: Bool
    let message: String
    let data: [ChatUserList]

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(Bool.self, forKey: .status)
        message = try values.decode(String.self, forKey: .message)
        data = try values.decode([ChatUserList].self, forKey: .data)
    }

}

struct ChatUserList: Codable {

    let id: Int
    let name: String
    let firstName: String
    let lastName: String
    let email: String
    let profile: String
    let phone: String
    let countryCode: String
    let selfDes: String
    let type: String
    let companyRefId: String
    let companyName: String
    let postcode: String
    let city: Int
    let state: Int
    let country: Int
    let ssn: String
    let companyPhone: String
    let emailVerify: String
    let phoneVerify: String
    let emailVerifiedAt: String
    let password: String
    let rememberToken: String
    let status: Int
    let blockStatus: String
    let stage: String
    let licenceNumber: String
    let licenceExpiryDate: String
    let busy: String
    let createdAt: String
    let updatedAt: String
    let message: String

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
        case password = "password"
        case rememberToken = "remember_token"
        case status = "status"
        case blockStatus = "block_status"
        case stage = "stage"
        case licenceNumber = "licence_number"
        case licenceExpiryDate = "licence_expiry_date"
        case busy = "busy"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        email = try values.decode(String.self, forKey: .email)
        profile = try values.decode(String.self, forKey: .profile)
        phone = try values.decode(String.self, forKey: .phone)
        countryCode = try values.decode(String.self, forKey: .countryCode)
        selfDes = try values.decode(String.self, forKey: .selfDes)
        type = try values.decode(String.self, forKey: .type)
        companyRefId = try values.decode(String.self, forKey: .companyRefId)
        companyName = try values.decode(String.self, forKey: .companyName)
        postcode = try values.decode(String.self, forKey: .postcode)
        city = try values.decode(Int.self, forKey: .city)
        state = try values.decode(Int.self, forKey: .state)
        country = try values.decode(Int.self, forKey: .country)
        ssn = try values.decode(String.self, forKey: .ssn)
        companyPhone = try values.decode(String.self, forKey: .companyPhone)
        emailVerify = try values.decode(String.self, forKey: .emailVerify)
        phoneVerify = try values.decode(String.self, forKey: .phoneVerify)
        emailVerifiedAt = try values.decode(String.self, forKey: .emailVerifiedAt)
        password = try values.decode(String.self, forKey: .password)
        rememberToken = try values.decode(String.self, forKey: .rememberToken)
        status = try values.decode(Int.self, forKey: .status)
        blockStatus = try values.decode(String.self, forKey: .blockStatus)
        stage = try values.decode(String.self, forKey: .stage)
        licenceNumber = try values.decode(String.self, forKey: .licenceNumber)
        licenceExpiryDate = try values.decode(String.self, forKey: .licenceExpiryDate)
        busy = try values.decode(String.self, forKey: .busy)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        updatedAt = try values.decode(String.self, forKey: .updatedAt)
        message = try values.decode(String.self, forKey: .message)
    }

}
