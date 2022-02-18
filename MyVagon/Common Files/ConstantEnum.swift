//
//  ConstantEnum.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import Foundation
//DO NOT CHNAGE THIS ENUM ELSE URLSESSION WONT WORK
enum RequestString : String{
    case boundry = "Boundary-"
    case multiplePartFormData = "multipart/form-data; boundary="
    case contentType = "Content-Type"
}

enum GetRequestType: String{
    case GET
    case POST
    case DELETE
}

enum BidStatusLabel {
    
    case bidConfirmationPending,noBookings
    
    var Name:String {
        switch self {
        case .bidConfirmationPending:
            return "Bid Confirmation Pending"
        case .noBookings:
            return "No Bookings"
        }
    }
}

enum ReqCancelTitle {
    
    case cencelBid,deleteBid
    
    var Name:String {
        switch self {
        case .cencelBid:
            return "Cancel Bid Request"
        case .deleteBid:
            return "Request To Cancel"
        }
    }
}

