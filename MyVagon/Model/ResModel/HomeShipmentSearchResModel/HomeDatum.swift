//
//  HomeDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 22, 2021

import Foundation

struct HomeDatum : Codable {

        let bidsData : [HomeBidsDatum]?
        let date : String?

        enum CodingKeys: String, CodingKey {
                case bidsData = "bids_data"
                case date = "date"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bidsData = try? values.decodeIfPresent([HomeBidsDatum].self, forKey: .bidsData)
                date = try? values.decodeIfPresent(String.self, forKey: .date)
        }
    
    
    init(Date:String,BidsData:[HomeBidsDatum]) {
        self.date = Date
        self.bidsData = BidsData
    }

}
