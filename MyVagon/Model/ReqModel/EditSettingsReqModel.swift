//
//  EditSettingsReqModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 24/05/22.
//

import Foundation
class EditSettingsReqModel: Encodable{
    var driverId : String?
    var settingKey : String?
    var settingValue : String?
    enum CodingKeys: String, CodingKey {
        case driverId = "driver_id"
        case settingKey = "setting_key"
        case settingValue = "setting_value"
    }
}


class LanguageChangeReqModel: Encodable{
    var driverId : String?
    var language : String?
    enum CodingKeys: String, CodingKey {
        case driverId = "driver_id"
        case language = "language"
    }
}
