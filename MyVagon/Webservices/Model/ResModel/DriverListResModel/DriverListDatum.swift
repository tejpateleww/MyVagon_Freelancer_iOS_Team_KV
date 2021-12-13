//
//  DriverListDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 18, 2021

import Foundation

struct DriverListDatum : Codable {

        let blockStatus : String?
        let busy : String?
        let city : String?
        let companyName : String?
        let companyPhone : String?
        let companyRefId : Int?
        let country : String?
        let countryCode : String?
        let createdAt : String?
        let email : String?
        let emailVerifiedAt : String?
        let emailVerify : String?
        let firstName : String?
        let id : Int?
        let lastName : String?
        let licenceExpiryDate : String?
        let licenceNumber : String?
        let name : String?
        let permission : DriverListPermission?
        let phone : String?
        let phoneVerify : String?
        let postcode : String?
        let profile : String?
        let selfDes : String?
        let ssn : String?
        let stage : String?
        let state : String?
        let status : Int?
        let type : String?
        let updatedAt : String?
        let vehicle : DriverListVehicle?

        enum CodingKeys: String, CodingKey {
                case blockStatus = "block_status"
                case busy = "busy"
                case city = "city"
                case companyName = "company_name"
                case companyPhone = "company_phone"
                case companyRefId = "company_ref_id"
                case country = "country"
                case countryCode = "country_code"
                case createdAt = "created_at"
                case email = "email"
                case emailVerifiedAt = "email_verified_at"
                case emailVerify = "email_verify"
                case firstName = "first_name"
                case id = "id"
                case lastName = "last_name"
                case licenceExpiryDate = "licence_expiry_date"
                case licenceNumber = "licence_number"
                case name = "name"
                case permission = "permission"
                case phone = "phone"
                case phoneVerify = "phone_verify"
                case postcode = "postcode"
                case profile = "profile"
                case selfDes = "self_des"
                case ssn = "ssn"
                case stage = "stage"
                case state = "state"
                case status = "status"
                case type = "type"
                case updatedAt = "updated_at"
                case vehicle = "vehicle"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                blockStatus = try? values.decodeIfPresent(String.self, forKey: .blockStatus)
                busy = try? values.decodeIfPresent(String.self, forKey: .busy)
                city = try? values.decodeIfPresent(String.self, forKey: .city)
                companyName = try? values.decodeIfPresent(String.self, forKey: .companyName)
                companyPhone = try? values.decodeIfPresent(String.self, forKey: .companyPhone)
                companyRefId = try? values.decodeIfPresent(Int.self, forKey: .companyRefId)
                country = try? values.decodeIfPresent(String.self, forKey: .country)
                countryCode = try? values.decodeIfPresent(String.self, forKey: .countryCode)
                createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
                email = try? values.decodeIfPresent(String.self, forKey: .email)
                emailVerifiedAt = try? values.decodeIfPresent(String.self, forKey: .emailVerifiedAt)
                emailVerify = try? values.decodeIfPresent(String.self, forKey: .emailVerify)
                firstName = try? values.decodeIfPresent(String.self, forKey: .firstName)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                lastName = try? values.decodeIfPresent(String.self, forKey: .lastName)
                licenceExpiryDate = try? values.decodeIfPresent(String.self, forKey: .licenceExpiryDate)
                licenceNumber = try? values.decodeIfPresent(String.self, forKey: .licenceNumber)
                name = try? values.decodeIfPresent(String.self, forKey: .name)
                permission = try? values.decodeIfPresent(DriverListPermission.self, forKey: .permission)
                phone = try? values.decodeIfPresent(String.self, forKey: .phone)
                phoneVerify = try? values.decodeIfPresent(String.self, forKey: .phoneVerify)
                postcode = try? values.decodeIfPresent(String.self, forKey: .postcode)
                profile = try? values.decodeIfPresent(String.self, forKey: .profile)
                selfDes = try? values.decodeIfPresent(String.self, forKey: .selfDes)
                ssn = try? values.decodeIfPresent(String.self, forKey: .ssn)
                stage = try? values.decodeIfPresent(String.self, forKey: .stage)
                state = try? values.decodeIfPresent(String.self, forKey: .state)
                status = try? values.decodeIfPresent(Int.self, forKey: .status)
                type = try? values.decodeIfPresent(String.self, forKey: .type)
                updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
                vehicle = try? values.decodeIfPresent(DriverListVehicle.self, forKey: .vehicle)
        }

}
