/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PostedTruckBidProducts : Codable {
	let id : Int?
	let booking_id : Int?
	let location_id : Int?
	let product_id : PostedTruckBidProductId?
	let product_type : PostedTruckBidProductType?
	let qty : String?
	let weight : String?
	let unit : PostedTruckBidUnit?
	let note : String?
	let is_fragile : Int?
	let is_sensetive : Int?
	let created_at : String?
	let updated_at : String?
	let is_pickup : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case booking_id = "booking_id"
		case location_id = "location_id"
		case product_id = "product_id"
		case product_type = "product_type"
		case qty = "qty"
		case weight = "weight"
		case unit = "unit"
		case note = "note"
		case is_fragile = "is_fragile"
		case is_sensetive = "is_sensetive"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case is_pickup = "is_pickup"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try? values.decodeIfPresent(Int.self, forKey: .id)
		booking_id = try? values.decodeIfPresent(Int.self, forKey: .booking_id)
		location_id = try? values.decodeIfPresent(Int.self, forKey: .location_id)
		product_id = try? values.decodeIfPresent(PostedTruckBidProductId.self, forKey: .product_id)
		product_type = try? values.decodeIfPresent(PostedTruckBidProductType.self, forKey: .product_type)
		qty = try? values.decodeIfPresent(String.self, forKey: .qty)
		weight = try? values.decodeIfPresent(String.self, forKey: .weight)
		unit = try? values.decodeIfPresent(PostedTruckBidUnit.self, forKey: .unit)
		note = try? values.decodeIfPresent(String.self, forKey: .note)
		is_fragile = try? values.decodeIfPresent(Int.self, forKey: .is_fragile)
		is_sensetive = try? values.decodeIfPresent(Int.self, forKey: .is_sensetive)
		created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try? values.decodeIfPresent(String.self, forKey: .updated_at)
		is_pickup = try? values.decodeIfPresent(Int.self, forKey: .is_pickup)
	}

}
