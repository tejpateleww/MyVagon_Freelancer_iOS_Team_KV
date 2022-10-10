//
//  TruckTypeDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 4, 2021

import Foundation

struct TruckTypeDatum : Codable {
    
    let category : [TruckTypeCategory]?
    let detetedAt : String?
    let icon : String?
    let id : Int?
    let name : String?
    let status : Int?
    let isTrailer : Int?
    let greekName: String?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case detetedAt = "deteted_at"
        case icon = "icon"
        case id = "id"
        case name = "name"
        case status = "status"
        case isTrailer = "is_trailer"
        case greekName = "name_greece"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try? values.decodeIfPresent([TruckTypeCategory].self, forKey: .category)
        detetedAt = try? values.decodeIfPresent(String.self, forKey: .detetedAt)
        icon = try? values.decodeIfPresent(String.self, forKey: .icon)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        status = try? values.decodeIfPresent(Int.self, forKey: .status)
        isTrailer = try? values.decodeIfPresent(Int.self, forKey: .isTrailer)
        greekName = try? values.decodeIfPresent(String.self, forKey: .greekName)
    }
    func getName() -> String{
        if (UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el" == "el"){
            return greekName ?? ""
        }else{
            return name ?? ""
        }
    }
    
}
import Foundation

struct TruckTypeCategory : Codable {
    
    let detetedAt : String?
    let id : Int?
    let name : String?
    let status : Int?
    let truckTypeId : Int?
    let greekName : String?
    
    enum CodingKeys: String, CodingKey {
        case detetedAt = "deteted_at"
        case id = "id"
        case name = "name"
        case status = "status"
        case truckTypeId = "truck_type_id"
        case greekName = "name_greek"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        detetedAt = try? values.decodeIfPresent(String.self, forKey: .detetedAt)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        status = try? values.decodeIfPresent(Int.self, forKey: .status)
        truckTypeId = try? values.decodeIfPresent(Int.self, forKey: .truckTypeId)
        greekName = try? values.decodeIfPresent(String.self, forKey: .greekName)
    }
    func getName() -> String{
        if (UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el" == "el"){
            return greekName ?? ""
        }else{
            return name ?? ""
        }
    }
}
