/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct BidRequestBooking_request : Codable {
	let id : Int?
	let booking_id : Int?
	let driver_id : Int?
	let shipper_id : Int?
	let availability_id : Int?
	let amount : String?
	let status : Int?
	let is_bid : Int?
	let created_at : String?
	let updated_at : String?
	let request_time : String?
	let accept_time : String?
	let booking_info : BidRequestBooking_info?
	let time_difference : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case booking_id = "booking_id"
		case driver_id = "driver_id"
		case shipper_id = "shipper_id"
		case availability_id = "availability_id"
		case amount = "amount"
		case status = "status"
		case is_bid = "is_bid"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case request_time = "request_time"
		case accept_time = "accept_time"
		case booking_info = "booking_info"
		case time_difference = "time_difference"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try? values.decodeIfPresent(Int.self, forKey: .id)
		booking_id = try? values.decodeIfPresent(Int.self, forKey: .booking_id)
		driver_id = try? values.decodeIfPresent(Int.self, forKey: .driver_id)
		shipper_id = try? values.decodeIfPresent(Int.self, forKey: .shipper_id)
		availability_id = try? values.decodeIfPresent(Int.self, forKey: .availability_id)
		amount = try? values.decodeIfPresent(String.self, forKey: .amount)
		status = try? values.decodeIfPresent(Int.self, forKey: .status)
		is_bid = try? values.decodeIfPresent(Int.self, forKey: .is_bid)
		created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try? values.decodeIfPresent(String.self, forKey: .updated_at)
		request_time = try? values.decodeIfPresent(String.self, forKey: .request_time)
		accept_time = try? values.decodeIfPresent(String.self, forKey: .accept_time)
		booking_info = try? values.decodeIfPresent(BidRequestBooking_info.self, forKey: .booking_info)
		time_difference = try? values.decodeIfPresent(Int.self, forKey: .time_difference)
	}

}
