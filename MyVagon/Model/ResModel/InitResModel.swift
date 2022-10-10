//
//  InitResModel.swift
//  MyVagon
//
//  Created by Apple on 21/12/21.
//

import Foundation

struct InitResModel : Codable {
    
    let message : String?
    let status : Bool?
    let update :Bool?
    let forceUpdate :Bool?
    let maintenance :Bool?
    let data : InitDatum?
    
    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case update = "update"
        case maintenance = "maintenance"
        case data = "data"
        case forceUpdate = "force_update"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        update = try? values.decodeIfPresent(Bool.self, forKey: .update)
        maintenance = try? values.decodeIfPresent(Bool.self, forKey: .maintenance)
        forceUpdate = try? values.decodeIfPresent(Bool.self, forKey: .forceUpdate)
        data = try? values.decodeIfPresent(InitDatum.self, forKey: .data)
    }
    
}

struct InitDatum : Codable {
    
    let bookingData : MyLoadsNewBid?
    let updateLocationInterval : Int?
    let termsAndCondition: String?
    let privacyPolicy: String?
    let aboutUs: String?
    let radius: Int?
    let localizationLanguage: [LocalizationLanguage]?
    
    private enum CodingKeys: String, CodingKey {
        case bookingData = "booking"
        case updateLocationInterval = "update_location_interval"
        case termsAndCondition = "terms_and_condition"
        case privacyPolicy = "privacy_policy"
        case aboutUs = "about_us"
        case radius = "radius"
        case localizationLanguage = "localization_language"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bookingData = try? values.decodeIfPresent(MyLoadsNewBid.self, forKey: .bookingData)
        updateLocationInterval = try? values.decodeIfPresent(Int.self, forKey: .updateLocationInterval)
        termsAndCondition = try values.decodeIfPresent(String.self, forKey: .termsAndCondition)
        privacyPolicy = try values.decodeIfPresent(String.self, forKey: .privacyPolicy)
        aboutUs = try values.decodeIfPresent(String.self, forKey: .aboutUs)
        radius = try values.decodeIfPresent(Int.self, forKey: .radius)
        localizationLanguage = try values.decode([LocalizationLanguage].self, forKey: .localizationLanguage)
    }
    
}

struct LocalizationLanguage: Codable {
    
    let name: String?
    let localizationCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case localizationCode = "localization_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        localizationCode = try values.decodeIfPresent(String.self, forKey: .localizationCode)
    }
    
}
