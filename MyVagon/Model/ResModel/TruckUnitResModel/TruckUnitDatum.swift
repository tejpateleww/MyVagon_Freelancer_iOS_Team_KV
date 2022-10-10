//
//  TruckUnitDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2021

import Foundation

struct TruckUnitDatum : Codable {
    
    let id : Int?
    let name : String?
    let greekName : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case greekName = "name_greek"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
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
