//
//  PaymentDetailResModel.swift
//  MyVagon
//
//  Created by Harshit K on 14/03/22.
//

import Foundation



struct PaymentDetailResModel: Codable {

    let status: Bool
    let message: String
    let data: PaymentDetailData

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(Bool.self, forKey: .status)
        message = try values.decode(String.self, forKey: .message)
        data = try values.decode(PaymentDetailData.self, forKey: .data)
    }

}


struct PaymentDetailData: Codable {

    let paymentType: Int
    let paymentDetail: PaymentDetail?

    private enum CodingKeys: String, CodingKey {
        case paymentType = "payment_type"
        case paymentDetail = "payment_detail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        paymentType = try values.decode(Int.self, forKey: .paymentType)
        paymentDetail = try? values.decode(PaymentDetail.self, forKey: .paymentDetail)
    }

}

struct PaymentDetail: Codable {

    let id: Int
    let userId: Int
    let iban: String
    let accountNumber: String
    let bankName: String
    let country: String
    let createdAt: String
    let updatedAt: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case iban = "iban"
        case accountNumber = "account_number"
        case bankName = "bank_name"
        case country = "country"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        userId = try values.decode(Int.self, forKey: .userId)
        iban = try values.decode(String.self, forKey: .iban)
        accountNumber = try values.decode(String.self, forKey: .accountNumber)
        bankName = try values.decode(String.self, forKey: .bankName)
        country = try values.decode(String.self, forKey: .country)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        updatedAt = try values.decode(String.self, forKey: .updatedAt)
    }

}
