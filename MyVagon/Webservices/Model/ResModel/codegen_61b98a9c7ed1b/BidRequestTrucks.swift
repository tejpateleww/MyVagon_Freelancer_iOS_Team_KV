/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct BidRequestTrucks : Codable {
	let id : Int?
	let driver_id : Int?
	let booking_id : Int?
	let truck_id : Int?
	let payout : String?
	let truck_type : Int?
	let truck_type_category : [BidRequestTruck_type_category]?
	let note : String?
	let is_hydraulic : Int?
	let is_cooling : Int?
	let created_at : String?
	let updated_at : String?
	let locations : [BidRequestLocations]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case driver_id = "driver_id"
		case booking_id = "booking_id"
		case truck_id = "truck_id"
		case payout = "payout"
		case truck_type = "truck_type"
		case truck_type_category = "truck_type_category"
		case note = "note"
		case is_hydraulic = "is_hydraulic"
		case is_cooling = "is_cooling"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case locations = "locations"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try? values.decodeIfPresent(Int.self, forKey: .id)
		driver_id = try? values.decodeIfPresent(Int.self, forKey: .driver_id)
		booking_id = try? values.decodeIfPresent(Int.self, forKey: .booking_id)
		truck_id = try? values.decodeIfPresent(Int.self, forKey: .truck_id)
		payout = try? values.decodeIfPresent(String.self, forKey: .payout)
		truck_type = try? values.decodeIfPresent(Int.self, forKey: .truck_type)
		truck_type_category = try? values.decodeIfPresent([BidRequestTruck_type_category].self, forKey: .truck_type_category)
		note = try? values.decodeIfPresent(String.self, forKey: .note)
		is_hydraulic = try? values.decodeIfPresent(Int.self, forKey: .is_hydraulic)
		is_cooling = try? values.decodeIfPresent(Int.self, forKey: .is_cooling)
		created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try? values.decodeIfPresent(String.self, forKey: .updated_at)
		locations = try? values.decodeIfPresent([BidRequestLocations].self, forKey: .locations)
	}

}
