//
//  ChangeLanguageResModel.swift
//  MyVagon
//
//  Created by Tej P on 07/06/22.
//

import Foundation

struct ChangeLanguageResModel: Codable {

    var status: Bool?
    var message: String?
    var data: [String]?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }

}
