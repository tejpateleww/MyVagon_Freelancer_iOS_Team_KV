//
//  EditLicenceDetailsReqModel.swift
//  MyVagon
//
//  Created by Harshit K on 16/03/22.
//

import Foundation

class EditLicenceDetailsReqModel : Encodable {
    var eu_registration_document: String?
    var license_number: String?
    var license_expiry_date: String?
    var license_image: String?
    

    enum CodingKeys: String, CodingKey {
        case eu_registration_document = "eu_registration_document"
        case license_number = "license_number"
        case license_expiry_date = "license_expiry_date"
        case license_image = "license_image"
    }
}
