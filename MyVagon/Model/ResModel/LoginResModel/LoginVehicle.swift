//
//  LoginVehicle.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 24, 2021

import Foundation

struct LoginVehicle : Codable {

        let brand : String?
        let capacityPallets : String?
        let cooling : Int?
        let createdAt : String?
        let fuelType : String?
        let hydraulicDoor : Int?
        let id : Int?
        let idProof : String?
        let images : [String]?
        let license : String?
        let loadCapacity : String?
        let loadCapacityUnit : LoginLoadCapacityUnit?
        let pallets : Int?
        let registrationNo : String?
        let truckFeatures : [LoginTruckFeature]?
        let truckSubCategory : LoginTruckSubCategory?
        let truckType : LoginTruckType?
        let userId : Int?
        let weight : String?
        let weightUnit : LoginWeightUnit?

        enum CodingKeys: String, CodingKey {
                case brand = "brand"
                case capacityPallets = "capacity_pallets"
                case cooling = "cooling"
                case createdAt = "created_at"
                case fuelType = "fuel_type"
                case hydraulicDoor = "hydraulic_door"
                case id = "id"
                case idProof = "id_proof"
                case images = "images"
                case license = "license"
                case loadCapacity = "load_capacity"
                case loadCapacityUnit = "load_capacity_unit"
                case pallets = "pallets"
                case registrationNo = "registration_no"
                case truckFeatures = "truck_features"
                case truckSubCategory = "truck_sub_category"
                case truckType = "truck_type"
                case userId = "user_id"
                case weight = "weight"
                case weightUnit = "weight_unit"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                brand = try values?.decodeIfPresent(String.self, forKey: .brand)
                capacityPallets = try values?.decodeIfPresent(String.self, forKey: .capacityPallets)
                cooling = try values?.decodeIfPresent(Int.self, forKey: .cooling)
                createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
                fuelType = try values?.decodeIfPresent(String.self, forKey: .fuelType)
                hydraulicDoor = try values?.decodeIfPresent(Int.self, forKey: .hydraulicDoor)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                idProof = try values?.decodeIfPresent(String.self, forKey: .idProof)
                images = try values?.decodeIfPresent([String].self, forKey: .images)
                license = try values?.decodeIfPresent(String.self, forKey: .license)
                loadCapacity = try values?.decodeIfPresent(String.self, forKey: .loadCapacity)
                loadCapacityUnit = try values?.decodeIfPresent(LoginLoadCapacityUnit.self, forKey: .loadCapacityUnit)
                pallets = try values?.decodeIfPresent(Int.self, forKey: .pallets)
                registrationNo = try values?.decodeIfPresent(String.self, forKey: .registrationNo)
                truckFeatures = try values?.decodeIfPresent([LoginTruckFeature].self, forKey: .truckFeatures)
                truckSubCategory = try values?.decodeIfPresent(LoginTruckSubCategory.self, forKey: .truckSubCategory)
                truckType = try values?.decodeIfPresent(LoginTruckType.self, forKey: .truckType)
                userId = try values?.decodeIfPresent(Int.self, forKey: .userId)
                weight = try values?.decodeIfPresent(String.self, forKey: .weight)
                weightUnit = try values?.decodeIfPresent(LoginWeightUnit.self, forKey: .weightUnit)
        }

}
