//
//  VerifyDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 9, 2021

import Foundation

struct VerifyDatum : Codable {

        let oTP : Int?

        enum CodingKeys: String, CodingKey {
                case oTP = "OTP"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                oTP = try? values.decodeIfPresent(Int.self, forKey: .oTP)
        }

}
