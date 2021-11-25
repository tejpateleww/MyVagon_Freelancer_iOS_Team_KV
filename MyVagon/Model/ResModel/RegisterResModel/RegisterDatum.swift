//
//  RegisterDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2021

import Foundation

struct RegisterDatum : Codable {

        let appVersion : String?
        let brand : String?
        let capacityUnit : String?
        let countryCode : String?
        let deviceName : String?
        let deviceToken : String?
        let deviceType : String?
        let email : String?
        let fuelType : String?
        let fullname : String?
        let idProof : String?
        let license : String?
        let loadCapacity : String?
        let mobileNumber : String?
        let pallets : String?
        let password : String?
        let registrationNo : String?
        let token : String?
        let truckCapacity : String?
        let truckSubCategory : String?
        let truckType : String?
        let truckWeight : String?
        let vehicleImages : String?
        let weightUnit : String?

        enum CodingKeys: String, CodingKey {
                case appVersion = "app_version"
                case brand = "brand"
                case capacityUnit = "capacity_unit"
                case countryCode = "country_code"
                case deviceName = "device_name"
                case deviceToken = "device_token"
                case deviceType = "device_type"
                case email = "email"
                case fuelType = "fuel_type"
                case fullname = "fullname"
                case idProof = "id_proof"
                case license = "license"
                case loadCapacity = "load_capacity"
                case mobileNumber = "mobile_number"
                case pallets = "pallets"
                case password = "password"
                case registrationNo = "registration_no"
                case token = "token"
                case truckCapacity = "truck_capacity"
                case truckSubCategory = "truck_sub_category"
                case truckType = "truck_type"
                case truckWeight = "truck_weight"
                case vehicleImages = "vehicle_images"
                case weightUnit = "weight_unit"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                appVersion = try? values.decodeIfPresent(String.self, forKey: .appVersion)
                brand = try? values.decodeIfPresent(String.self, forKey: .brand)
                capacityUnit = try? values.decodeIfPresent(String.self, forKey: .capacityUnit)
                countryCode = try? values.decodeIfPresent(String.self, forKey: .countryCode)
                deviceName = try? values.decodeIfPresent(String.self, forKey: .deviceName)
                deviceToken = try? values.decodeIfPresent(String.self, forKey: .deviceToken)
                deviceType = try? values.decodeIfPresent(String.self, forKey: .deviceType)
                email = try? values.decodeIfPresent(String.self, forKey: .email)
                fuelType = try? values.decodeIfPresent(String.self, forKey: .fuelType)
                fullname = try? values.decodeIfPresent(String.self, forKey: .fullname)
                idProof = try? values.decodeIfPresent(String.self, forKey: .idProof)
                license = try? values.decodeIfPresent(String.self, forKey: .license)
                loadCapacity = try? values.decodeIfPresent(String.self, forKey: .loadCapacity)
                mobileNumber = try? values.decodeIfPresent(String.self, forKey: .mobileNumber)
                pallets = try? values.decodeIfPresent(String.self, forKey: .pallets)
                password = try? values.decodeIfPresent(String.self, forKey: .password)
                registrationNo = try? values.decodeIfPresent(String.self, forKey: .registrationNo)
                token = try? values.decodeIfPresent(String.self, forKey: .token)
                truckCapacity = try? values.decodeIfPresent(String.self, forKey: .truckCapacity)
                truckSubCategory = try? values.decodeIfPresent(String.self, forKey: .truckSubCategory)
                truckType = try? values.decodeIfPresent(String.self, forKey: .truckType)
                truckWeight = try? values.decodeIfPresent(String.self, forKey: .truckWeight)
                vehicleImages = try? values.decodeIfPresent(String.self, forKey: .vehicleImages)
                weightUnit = try? values.decodeIfPresent(String.self, forKey: .weightUnit)
        }

}
