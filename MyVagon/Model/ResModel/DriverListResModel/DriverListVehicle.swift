//
//  DriverListVehicle.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 18, 2021

import Foundation

struct DriverListVehicle : Codable {

        let brand : String?
        let brands : DriverListBrand?
        let capacityPallets : String?
        let createdAt : String?
        let fuelType : String?
        let id : Int?
        let idProof : String?
        let images : [String]?
        let license : String?
        let loadCapacity : String?
        let loadCapacityUnit : DriverListLoadCapacityUnit?
        let pallets : Int?
        let registrationNo : String?
        let truckFeatures : [DriverListTruckFeature]?
        let truckSubCategory : DriverListTruckSubCategory?
        let truckType : DriverListTruckType?
        let userId : Int?
        let vehicleCapacity : [DriverListVehicleCapacity]?
        let weight : String?
        let weightUnit : DriverListWeightUnit?

        enum CodingKeys: String, CodingKey {
                case brand = "brand"
                case brands = "brands"
                case capacityPallets = "capacity_pallets"
                case createdAt = "created_at"
                case fuelType = "fuel_type"
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
                case vehicleCapacity = "vehicle_capacity"
                case weight = "weight"
                case weightUnit = "weight_unit"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                brand = try? values.decodeIfPresent(String.self, forKey: .brand)
                brands = try? values.decodeIfPresent(DriverListBrand.self, forKey: .brands)
                capacityPallets = try? values.decodeIfPresent(String.self, forKey: .capacityPallets)
                createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
                fuelType = try? values.decodeIfPresent(String.self, forKey: .fuelType)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                idProof = try? values.decodeIfPresent(String.self, forKey: .idProof)
                images = try? values.decodeIfPresent([String].self, forKey: .images)
                license = try? values.decodeIfPresent(String.self, forKey: .license)
                loadCapacity = try? values.decodeIfPresent(String.self, forKey: .loadCapacity)
                loadCapacityUnit = try? values.decodeIfPresent(DriverListLoadCapacityUnit.self, forKey: .loadCapacityUnit)
                pallets = try? values.decodeIfPresent(Int.self, forKey: .pallets)
                registrationNo = try? values.decodeIfPresent(String.self, forKey: .registrationNo)
                truckFeatures = try? values.decodeIfPresent([DriverListTruckFeature].self, forKey: .truckFeatures)
                truckSubCategory = try? values.decodeIfPresent(DriverListTruckSubCategory.self, forKey: .truckSubCategory)
                truckType = try? values.decodeIfPresent(DriverListTruckType.self, forKey: .truckType)
                userId = try? values.decodeIfPresent(Int.self, forKey: .userId)
                vehicleCapacity = try? values.decodeIfPresent([DriverListVehicleCapacity].self, forKey: .vehicleCapacity)
                weight = try? values.decodeIfPresent(String.self, forKey: .weight)
                weightUnit = try? values.decodeIfPresent(DriverListWeightUnit.self, forKey: .weightUnit)
        }

}
