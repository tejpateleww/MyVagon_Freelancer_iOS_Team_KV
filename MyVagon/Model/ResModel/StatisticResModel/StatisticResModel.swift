//
//  StatisticResModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on February 18, 2022
//
import Foundation

struct StatisticResModel: Codable {

    var status: Bool?
    var message: String?
    var data: [StatisticListData]?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([StatisticListData].self, forKey: .data)
    }

}

struct StatisticListData: Codable {

    var name: String?
    var value: String?
    var color: String?
    var statisticType: String?

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
        case color = "color"
        case statisticType = "statistic_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        statisticType = try values.decodeIfPresent(String.self, forKey: .statisticType)
    }

}
