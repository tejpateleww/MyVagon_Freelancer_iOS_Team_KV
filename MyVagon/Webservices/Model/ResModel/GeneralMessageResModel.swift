//
//  GeneralMessageResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 12, 2021

import Foundation

struct GeneralMessageResModel : Codable {

        let data : [String]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try? values.decodeIfPresent([String].self, forKey: .data)
                message = try? values.decodeIfPresent(String.self, forKey: .message)
                status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct SystemDateResModel : Codable {

        let data : String?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try? values.decodeIfPresent(String.self, forKey: .data)
                message = try? values.decodeIfPresent(String.self, forKey: .message)
                status = try? values.decodeIfPresent(Bool.self, forKey: .status)
        }
}


//struct CancelBidRequestResModel: Codable {
//
//    let status: Bool?
//    let message: String?
//    let data: Data?
//
//    private enum CodingKeys: String, CodingKey {
//        case status = "status"
//        case message = "message"
//        case data = "data"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        status = try? values.decode(Bool.self, forKey: .status)
//        message = try? values.decode(String.self, forKey: .message)
//        data = try? values.decode(Data.self, forKey: .data)
//    }
//
//}
//
//struct Data: Codable {
//
//}
