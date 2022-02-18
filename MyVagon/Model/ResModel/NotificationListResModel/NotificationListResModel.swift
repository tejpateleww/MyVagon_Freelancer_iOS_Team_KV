//
//  NotificationResModel.swift
//  MyVagon
//
//  Created by Apple on 04/01/22.
//

import Foundation

// MARK: - Welcome
struct NotificationListResModel: Codable {
    let status: Bool?
    let message: String?
    let data: [NotificationListData]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        data = try? values.decodeIfPresent([NotificationListData].self, forKey: .data)
    }
}

// MARK: - Datum
struct NotificationListData: Codable {
    let id, userID: Int?
    let title, message: String?
    let readStatus: Int?
    let createdAt,date: String?
    
    enum CodingKeys: String, CodingKey {
        case id,date
        case userID = "user_id"
        case title, message
        case readStatus = "read_status"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        userID = try? values.decodeIfPresent(Int.self, forKey: .userID)
        title = try? values.decodeIfPresent(String.self, forKey: .title)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        readStatus = try? values.decodeIfPresent(Int.self, forKey: .readStatus)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        date = try? values.decodeIfPresent(String.self, forKey: .date)
    }
}
