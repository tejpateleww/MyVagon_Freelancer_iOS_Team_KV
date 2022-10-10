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
    
    case cencelBid,deleteBid,decline
    
    var Name:String {
        switch self {
        case .cencelBid:
            return "Cancel Bid Request"
        case .deleteBid:
            return "Request To Cancel"
        case .decline:
            return "Declined the load"
        }
    }
}

enum TripStatus {
    case ClicktoStartTrip
    case RateShipper
    case UploadPOD
    
    var Name:String {
        switch self {
        case .ClicktoStartTrip:
            return "Click to Start Trip"
        case .UploadPOD:
            return "Upload POD"
        case .RateShipper:
            return "Rate Shipper"
        }
    }
}

enum TrackStates: String {
    case Starttrip = "Start Trip"
    case EntrouteTo = "Enroute to"
    case ArrivedAt = "Arrived at"
    case StartLoading = "Loading at"
    case CompleteLoading = "Complete Loading"
    case CompleteUnloding = "Complete Unloading"
    case CompleteTrip = "Complete Shipment"
    case StartUnloding = "Unloading at"
    case LodingUnloding = "Loading/Unloading at"
    case CompletelodingUnloding = "Complete Loading/Unloading"
}
