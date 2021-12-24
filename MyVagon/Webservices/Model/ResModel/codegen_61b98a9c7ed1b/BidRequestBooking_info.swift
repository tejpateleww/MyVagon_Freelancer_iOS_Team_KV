/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct BidRequestBooking_info : Codable {
    
	let id : Int?
	let txn_id : String?
	let user_id : Int?
	let booking_type : String?
	let pickup_address : String?
	let pickup_lat : String?
	let pickup_lng : String?
	let pickup_date : String?
	let pickup_time_to : String?
	let pickup_time_from : String?
	let pickup_note : String?
	let distance : String?
	let journey : String?
	let journey_type : String?
	let is_public : Int?
	let amount : String?
	let cancellation_term : String?
	let cancellation_charge : String?
	let status : String?
	let created_at : String?
	let updated_at : String?
	let deleted_at : String?
	let is_bid : Int?
	let is_tracking : Int?
	let email_or_number : String?
	let trucks : BidRequestTrucks?
	let shipper_details : BidRequestShipper_details?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case txn_id = "txn_id"
		case user_id = "user_id"
		case booking_type = "booking_type"
		case pickup_address = "pickup_address"
		case pickup_lat = "pickup_lat"
		case pickup_lng = "pickup_lng"
		case pickup_date = "pickup_date"
		case pickup_time_to = "pickup_time_to"
		case pickup_time_from = "pickup_time_from"
		case pickup_note = "pickup_note"
		case distance = "distance"
		case journey = "journey"
		case journey_type = "journey_type"
		case is_public = "is_public"
		case amount = "amount"
		case cancellation_term = "cancellation_term"
		case cancellation_charge = "cancellation_charge"
		case status = "status"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case deleted_at = "deleted_at"
		case is_bid = "is_bid"
		case is_tracking = "is_tracking"
		case email_or_number = "email_or_number"
		case trucks = "trucks"
		case shipper_details = "shipper_details"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try? values.decodeIfPresent(Int.self, forKey: .id)
		txn_id = try? values.decodeIfPresent(String.self, forKey: .txn_id)
		user_id = try? values.decodeIfPresent(Int.self, forKey: .user_id)
		booking_type = try? values.decodeIfPresent(String.self, forKey: .booking_type)
		pickup_address = try? values.decodeIfPresent(String.self, forKey: .pickup_address)
		pickup_lat = try? values.decodeIfPresent(String.self, forKey: .pickup_lat)
		pickup_lng = try? values.decodeIfPresent(String.self, forKey: .pickup_lng)
		pickup_date = try? values.decodeIfPresent(String.self, forKey: .pickup_date)
		pickup_time_to = try? values.decodeIfPresent(String.self, forKey: .pickup_time_to)
		pickup_time_from = try? values.decodeIfPresent(String.self, forKey: .pickup_time_from)
		pickup_note = try? values.decodeIfPresent(String.self, forKey: .pickup_note)
		distance = try? values.decodeIfPresent(String.self, forKey: .distance)
		journey = try? values.decodeIfPresent(String.self, forKey: .journey)
		journey_type = try? values.decodeIfPresent(String.self, forKey: .journey_type)
		is_public = try? values.decodeIfPresent(Int.self, forKey: .is_public)
		amount = try? values.decodeIfPresent(String.self, forKey: .amount)
		cancellation_term = try? values.decodeIfPresent(String.self, forKey: .cancellation_term)
		cancellation_charge = try? values.decodeIfPresent(String.self, forKey: .cancellation_charge)
		status = try? values.decodeIfPresent(String.self, forKey: .status)
		created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try? values.decodeIfPresent(String.self, forKey: .updated_at)
		deleted_at = try? values.decodeIfPresent(String.self, forKey: .deleted_at)
		is_bid = try? values.decodeIfPresent(Int.self, forKey: .is_bid)
		is_tracking = try? values.decodeIfPresent(Int.self, forKey: .is_tracking)
		email_or_number = try? values.decodeIfPresent(String.self, forKey: .email_or_number)
		trucks = try? values.decodeIfPresent(BidRequestTrucks.self, forKey: .trucks)
		shipper_details = try? values.decodeIfPresent(BidRequestShipper_details.self, forKey: .shipper_details)
	}

}
