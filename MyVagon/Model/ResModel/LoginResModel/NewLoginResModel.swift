//
//  NewLoginResModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on March 08, 2022
//
import Foundation

struct NewLoginResModel: Codable {

	var status: Bool
	var message: String
	var data: Data

	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decode(Bool.self, forKey: .status)
		message = try values.decode(String.self, forKey: .message)
		data = try values.decode(Data.self, forKey: .data)
	}

}