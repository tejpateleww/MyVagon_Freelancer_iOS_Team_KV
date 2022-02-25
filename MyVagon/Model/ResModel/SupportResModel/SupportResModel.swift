//
//  SupportResModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on February 16, 2022
//
import Foundation

struct SupportResModel: Codable {

	let status: Bool?
	let message: String?
	let data: SupportData?

	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(SupportData.self, forKey: .data)
	}

}

struct SupportData: Codable {

    let call: String?
    let chat: SupportChat?

    private enum CodingKeys: String, CodingKey {
        case call = "call"
        case chat = "chat"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        call = try values.decodeIfPresent(String.self, forKey: .call)
        chat = try values.decodeIfPresent(SupportChat.self, forKey: .chat)
    }

}

struct SupportChat: Codable {

    let id: Int?
    let name: String?
    let profile: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case profile = "profile"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
    }

}


