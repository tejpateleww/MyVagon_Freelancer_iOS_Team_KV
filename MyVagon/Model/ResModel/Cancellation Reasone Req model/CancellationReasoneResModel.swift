//
//  CancellationReasoneResModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 28/03/22.
//

import Foundation
class CancellationReasoneResModel: Codable {

    let status: Bool?
    let message: String?
    let data: [Reasone]?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decode(Bool.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
        data = try? values.decode([Reasone].self, forKey: .data)
    }

}
class Reasone: Codable {

    let id: Int?
    let reason: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case reason = "reason"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        reason = try? values.decode(String.self, forKey: .reason)
    }

}
