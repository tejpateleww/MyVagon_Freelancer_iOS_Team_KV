/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PostedTruckBidLocations : Codable {
	let id : Int?
	let truck_id : Int?
	let booking_id : Int?
	let company_name : String?
	let drop_location : String?
	let drop_lat : String?
	let drop_lng : String?
	let distance : String?
	let journey : String?
	let deadhead : String?
	let delivery_time_from : String?
	let delivery_time_to : String?
	let is_pickup : Int?
	let note : String?
	let delivered_at : String?
	let created_at : String?
	let updated_at : String?
	let otp : String?
	let verify_otp : Int?
	let products : [PostedTruckBidProducts]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case truck_id = "truck_id"
		case booking_id = "booking_id"
		case company_name = "company_name"
		case drop_location = "drop_location"
		case drop_lat = "drop_lat"
		case drop_lng = "drop_lng"
		case distance = "distance"
		case journey = "journey"
		case deadhead = "deadhead"
		case delivery_time_from = "delivery_time_from"
		case delivery_time_to = "delivery_time_to"
		case is_pickup = "is_pickup"
		case note = "note"
		case delivered_at = "delivered_at"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case otp = "otp"
		case verify_otp = "verify_otp"
		case products = "products"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try? values.decodeIfPresent(Int.self, forKey: .id)
		truck_id = try? values.decodeIfPresent(Int.self, forKey: .truck_id)
		booking_id = try? values.decodeIfPresent(Int.self, forKey: .booking_id)
		company_name = try? values.decodeIfPresent(String.self, forKey: .company_name)
		drop_location = try? values.decodeIfPresent(String.self, forKey: .drop_location)
		drop_lat = try? values.decodeIfPresent(String.self, forKey: .drop_lat)
		drop_lng = try? values.decodeIfPresent(String.self, forKey: .drop_lng)
		distance = try? values.decodeIfPresent(String.self, forKey: .distance)
		journey = try? values.decodeIfPresent(String.self, forKey: .journey)
		deadhead = try? values.decodeIfPresent(String.self, forKey: .deadhead)
		delivery_time_from = try? values.decodeIfPresent(String.self, forKey: .delivery_time_from)
		delivery_time_to = try? values.decodeIfPresent(String.self, forKey: .delivery_time_to)
		is_pickup = try? values.decodeIfPresent(Int.self, forKey: .is_pickup)
		note = try? values.decodeIfPresent(String.self, forKey: .note)
		delivered_at = try? values.decodeIfPresent(String.self, forKey: .delivered_at)
		created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try? values.decodeIfPresent(String.self, forKey: .updated_at)
		otp = try? values.decodeIfPresent(String.self, forKey: .otp)
		verify_otp = try? values.decodeIfPresent(Int.self, forKey: .verify_otp)
		products = try? values.decodeIfPresent([PostedTruckBidProducts].self, forKey: .products)
	}

}
