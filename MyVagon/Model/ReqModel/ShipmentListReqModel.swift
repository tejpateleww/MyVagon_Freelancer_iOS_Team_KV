//
//  ShipmentListReqModel.swift
//  MyVagon
//
//  Created by Apple on 16/09/21.
//

import Foundation
class ShipmentListReqModel : Encodable {
    var driver_id : String?
    var page : String?
    
    var pickup_date : String?
    var min_price : String?
    var max_price : String?
    var pickup_lat : String?
    var pickup_lng : String?
    var dropoff_lat : String?
    var dropoff_lng : String?
    var min_weight : String?
    var max_weight : String?
    var min_weight_unit : String?
    var max_weight_unit : String?
    
    var price_sort : String?
    var total_distance_sort : String?
    var rating_sort : String?
    var jurnyType : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case page = "page_num"
        case pickup_date = "pickup_date"
        case min_price = "min_price"
        case max_price = "max_price"
        case pickup_lat = "pickup_lat"
        case pickup_lng = "pickup_lng"
        case dropoff_lat = "dropoff_lat"
        case dropoff_lng = "dropoff_lng"
        
        case min_weight = "weight_min"
        case max_weight = "weight_max"
        case min_weight_unit = "min_weight_unit"
        case max_weight_unit = "max_weight_unit"
        
        case price_sort = "price_sort"
        case total_distance_sort = "total_distance_sort"
        case rating_sort = "rating_sort"
        case jurnyType = "journey_type"
        
        
    }
}

class BidReqModel : Encodable {
    var driver_id,booking_id,amount,availability_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case amount = "amount"
        case availability_id = "availability_id"
    }
}
class MyLoadsReqModel : Encodable {
    var driver_id,page_num,status,type : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case page_num = "page_num"
        case status = "status"
        case type = "type"
    }
}
class BookNowReqModel : Encodable {
    var driver_id,booking_id,availability_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case availability_id = "availability_id"
    }
}

class PostTruckBidReqModel : Encodable {
    var driver_id,availability_id,sort : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case availability_id = "availability_id"
        case sort = "sort"   
    }
}
class BidAcceptRejectReqModel : Encodable {
    var driver_id,booking_request_id,status : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_request_id = "booking_request_id"
        case status = "status"
        
    }
}
class ArraivedAtLocationReqModel : Encodable {
    var driver_id,booking_id,location_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case location_id = "location_id"
        
    }
}
class StartLoadingReqModel : Encodable {
    var driver_id,booking_id,location_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case location_id = "location_id"
        
    }
}
class StartJourneyReqModel : Encodable {
    var driver_id,booking_id,location_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case location_id = "location_id"
    
    }
}
class LoadDetailsReqModel : Encodable {
    var driver_id,booking_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
       
    }
}
class CompleteTripReqModel : Encodable {
    var driver_id,booking_id,pod_image,location_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case pod_image = "pod_image"
        case location_id = "location_id"
        
    }
}

class CancelBidReqModel : Encodable {
    var driver_id,booking_id,shipper_id : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case shipper_id = "shipper_id"
        
    }
}
class UploadPODReqModel : Encodable {
    var driver_id,booking_id,pod_image : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case pod_image = "pod_image"
    
        
    }
}
class RateReviewReqModel : Encodable {
    var driver_id,booking_id,rating,review : String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
        case rating = "rating"
        case review = "review"
    }
}
class chatMessageReqModel : Encodable {
    var driver_id,shipper_id: String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case shipper_id = "shipper_id"
    }
}

class chatListReqModel : Encodable {
    var driver_id: String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
    }
}

class EarningReqModel : Encodable {
    var driver_id: String?
    var statisticType: String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case statisticType = "statistic_type"
        
    }
}

class AcceptPaymentReqModel : Encodable {
    var driver_id: String?
    var booking_id: String?

    enum CodingKeys: String, CodingKey {
        case driver_id = "driver_id"
        case booking_id = "booking_id"
    }
}

class PaymentDetailUpdateReqModel : Encodable {
    var payment_type: String?
    var iban: String?
    var account_number: String?
    var bank_name: String?
    var country: String?
    
    

    enum CodingKeys: String, CodingKey {
        case payment_type = "payment_type"
        case iban = "iban"
        case account_number = "account_number"
        case bank_name = "bank_name"
        case country = "country"
    }
}


//class sendMessageReqModel : RequestModel {
//    var sender_id : String = ""
//    var receiver_id : String = ""
//    var message : String = ""
//    var sender_name : String = ""
//    var receiver_name : String = ""
//    var created_at : String = ""
//}

