//
//  MyLoadsNewDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation

struct MyLoadsNewDatum : Codable {
    
    var bid : MyLoadsNewBid?
    var book : MyLoadsNewBid?
    let postedTruck : MyLoadsNewPostedTruck?
    let type : String?
    let date : String?
    
    enum CodingKeys: String, CodingKey {
        case bid = "bid"
        case book = "book"
        case postedTruck = "posted_truck"
        case type = "type"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bid = try? values.decodeIfPresent(MyLoadsNewBid.self, forKey: .bid)
        book = try? values.decodeIfPresent(MyLoadsNewBid.self, forKey: .book)
        postedTruck = try? values.decodeIfPresent(MyLoadsNewPostedTruck.self, forKey: .postedTruck)
        type = try? values.decodeIfPresent(String.self, forKey: .type)
        date = try? values.decodeIfPresent(String.self, forKey: .date)
    }
    
    init(PostedTruck:MyLoadsNewPostedTruck,Type:String,Date:String) {
        self.bid = nil
        self.book = nil
        self.postedTruck = PostedTruck
        self.type = Type
        self.date = Date
    }
    
}
