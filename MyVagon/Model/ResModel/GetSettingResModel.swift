//
//  GetSettingResModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 23/05/22.
//

import Foundation

struct GetSettingResModel: Codable {

    let status: Bool?
    let message: String?
    let data: SettingData?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        data = try? values.decodeIfPresent(SettingData.self, forKey: .data)
    }

}
struct SettingData: Codable {

    let id: Int?
    let userId: Int?
    let pushNotification: [SettingNotification]?
    let emailNotification: [SettingNotification]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case pushNotification = "push_notification"
        case emailNotification = "email_notification"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        userId = try? values.decodeIfPresent(Int.self, forKey: .userId)
        pushNotification = try? values.decodeIfPresent([SettingNotification].self, forKey: .pushNotification)
        emailNotification = try? values.decodeIfPresent([SettingNotification].self, forKey: .emailNotification)
    }

}
struct SettingNotification: Codable {

    let key: String?
    let value: Int?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try? values.decodeIfPresent(String.self, forKey: .key)
        value = try? values.decodeIfPresent(Int.self, forKey: .value)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
    }

}
