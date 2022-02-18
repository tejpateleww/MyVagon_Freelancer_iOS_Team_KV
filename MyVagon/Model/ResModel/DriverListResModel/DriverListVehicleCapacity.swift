//
//  DriverListVehicleCapacity.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 18, 2021

import Foundation

struct DriverListVehicleCapacity : Codable {

        let createdAt : String?
        let driverVehicleId : Int?
        let id : Int?
        let packageTypeId : DriverListPackageTypeId?
        let updatedAt : String?
        let value : String?

        enum CodingKeys: String, CodingKey {
                case createdAt = "created_at"
                case driverVehicleId = "driver_vehicle_id"
                case id = "id"
                case packageTypeId = "package_type_id"
                case updatedAt = "updated_at"
                case value = "value"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
                driverVehicleId = try? values.decodeIfPresent(Int.self, forKey: .driverVehicleId)
                id = try? values.decodeIfPresent(Int.self, forKey: .id)
                packageTypeId = try? values.decodeIfPresent(DriverListPackageTypeId.self, forKey: .packageTypeId) 
                updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
                value = try? values.decodeIfPresent(String.self, forKey: .value)
        }

}
