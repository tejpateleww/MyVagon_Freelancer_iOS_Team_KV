//
//  Enums.swift
//  MyVagon
//
//  Created by Tej P on 08/06/22.
//

import Foundation

enum MyLoadesStatus {
    case all,pending,scheduled,inprocess,past,completed,canceled
    var Name:String {
        switch self {
        case .all:
            return "all"
        case .pending:
            return "pending"
        case .scheduled:
            return "scheduled"
        case .inprocess:
            return "in-progress"
        case .past:
            return "past"
        case .completed:
            return "completed"
        case .canceled:
            return "canceled"
        }
    }
}

enum UserDefaultsKey : String {
    case IntroScreenStatus = "IntroScreenStatus"
    case SelectedLanguage = "SelectedLanguage"
    case UserDefaultKeyForRegister = "UserDefaultKeyForRegister"
    case RegisterData = "RegisterData"
    case userProfile = "userProfile"
    case isUserLogin = "isUserLogin"
    case X_API_KEY = "X_API_KEY"
    case DeviceToken = "DeviceToken"
    case LoginUserType = "LoginUserType"
}

enum Tabselect: String {
    case Diesel
    case Electrical
    case Hydrogen
}

enum AddCapacityTypeButtonName {
    case Add
    case Update
}

enum SelectedTextFieldForGeneralPicker {
    case CapacityType
    case TruckBrandList
}

enum KeyOfResend: String {
    case IsFrom
    case ReqModel
}

enum OTPFor: String {
    case email
    case phoneNumber
}

enum bidStatus {
    case BookNow
    case BidNow
    case Bidded
    var Name:String {
        switch self {
        case .BookNow:
            return "Book Now"
        case .BidNow:
            return "Bid Now"
        case .Bidded:
            return "Bidded"
        }
    }
}

enum MyAccountSectionTitle {
    case Language,Myprofile,Payment,settings,Statistics,Changepassword,AboutMYVAGON,ContactUs,Logout
    var StringName:String  {
        switch self {
        case .Language:
            return "Language".localized
        case .Myprofile:
            return "My profile".localized
        case .Payment:
            return "Payments".localized
        case .settings:
            return "Notifications".localized
        case .Statistics:
            return "Statistics".localized
        case .Changepassword:
            return "Change password".localized
        case .AboutMYVAGON:
            return "About MYVAGON".localized
        case .ContactUs:
            return "Contact us".localized
        case .Logout:
            return "Log out".localized
        }
    }
}

enum MyLoadType  {
    case Bid,Book,PostedTruck
    var Name : String {
        switch self {
        case .Bid:
            return "bid"
        case .Book:
            return  "book"
        case .PostedTruck:
            return "posted_truck"
        }
    }
}

enum NotificationTitle {
    case AllNotification,Messages,Bidreceive,Bidaccepted,Loadsassignedbydispacter,Starttripreminder,Completetripreminder,PODreminder,Matcheswithshipmentnearyou,Matcheswithshipmentnearlastdeliverypoint, RateShipper
    var Name:String {
        switch self {
        case .AllNotification:
            return "All Notifications"
        case .Messages:
            return "Messages"
        case .Bidreceive:
            return "Bid received"
        case .Bidaccepted:
            return "Bid accepted"
        case .Loadsassignedbydispacter:
            return "Loads assigned by dispacter"
        case .Starttripreminder:
            return "Start trip reminder"
        case .Completetripreminder:
            return "Complete trip reminder"
        case .PODreminder:
            return "POD reminder"
        case .Matcheswithshipmentnearyou:
            return "Matches with shipment near you"
        case .Matcheswithshipmentnearlastdeliverypoint:
            return "Matches with shipment near last delivery point"
        case .RateShipper:
            return "Rate Shipper"
        }
    }
}

enum PlacerPickerOpenFor:String {
    case StartLoction
    case EndLocation
}

enum BidStatus:String {
    case all
    case pending
    case scheduled
    case inProgress
    case past
}
