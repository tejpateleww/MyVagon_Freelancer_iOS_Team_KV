/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct BidRequestData : Codable {
	let id : Int?
	let truck_type_id : Int?
	let driver_id : String?
	let booking_id : String?
	let date : String?
	let time : String?
	let from_address : String?
	let start_lat : String?
	let start_lng : String?
	let to_address : String?
	let end_lat : String?
	let end_lng : String?
	let is_bid : Int?
	let bid_amount : String?
	let load_status : String?
	let created_at : String?
	let updated_at : String?
	let booking_request : [MyLoadsNewPostedTruck]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case truck_type_id = "truck_type_id"
		case driver_id = "driver_id"
		case booking_id = "booking_id"
		case date = "date"
		case time = "time"
		case from_address = "from_address"
		case start_lat = "start_lat"
		case start_lng = "start_lng"
		case to_address = "to_address"
		case end_lat = "end_lat"
		case end_lng = "end_lng"
		case is_bid = "is_bid"
		case bid_amount = "bid_amount"
		case load_status = "load_status"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case booking_request = "booking_request"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try? values.decodeIfPresent(Int.self, forKey: .id)
		truck_type_id = try? values.decodeIfPresent(Int.self, forKey: .truck_type_id)
		driver_id = try? values.decodeIfPresent(String.self, forKey: .driver_id)
		booking_id = try? values.decodeIfPresent(String.self, forKey: .booking_id)
		date = try? values.decodeIfPresent(String.self, forKey: .date)
		time = try? values.decodeIfPresent(String.self, forKey: .time)
		from_address = try? values.decodeIfPresent(String.self, forKey: .from_address)
		start_lat = try? values.decodeIfPresent(String.self, forKey: .start_lat)
		start_lng = try? values.decodeIfPresent(String.self, forKey: .start_lng)
		to_address = try? values.decodeIfPresent(String.self, forKey: .to_address)
		end_lat = try? values.decodeIfPresent(String.self, forKey: .end_lat)
		end_lng = try? values.decodeIfPresent(String.self, forKey: .end_lng)
		is_bid = try? values.decodeIfPresent(Int.self, forKey: .is_bid)
		bid_amount = try? values.decodeIfPresent(String.self, forKey: .bid_amount)
		load_status = try? values.decodeIfPresent(String.self, forKey: .load_status)
		created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try? values.decodeIfPresent(String.self, forKey: .updated_at)
		booking_request = try? values.decodeIfPresent([MyLoadsNewPostedTruck].self, forKey: .booking_request)
	}

}
