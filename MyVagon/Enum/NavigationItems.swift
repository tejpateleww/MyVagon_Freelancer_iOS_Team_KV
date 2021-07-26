//
//  NavigationItems.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import Foundation
import Foundation
import UIKit

enum NavItemsLeft {
    case none, back , menu , cancel , cancelWhite,QuestionFalse
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .back:
            return "back"
        case .menu:
            return "ic_sideMenu"
        case .cancel:
            return "cancel"
        case .cancelWhite:
            return "cancelWhite"
        case .QuestionFalse:
            return "imgQuestionFalse"
        }
    }
}


enum NavItemsRight {
    case none,login,EditProfile,userProfile,Done,sos,help,skip,like,edit,viewNotes,AddNotes,skipTour
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .login:
            return "login"
        case .EditProfile:
            return "EditProfile"
        case .userProfile:
            return "like"
        case .Done:
            return "Done"
        case .sos:
            return "ic_SOSBtn"
        case .help:
            return "imgHelp"
        case .skip:
            return "skip"
        case .like:
            return "like"
        case .edit:
            return "edit"
        case .viewNotes:
            return "viewNotes"
        case .AddNotes:
            return "AddNotes"
        case .skipTour:
            return "skipTour"
        }
       
    }
}
enum NavTitles
{
    case none, Home,reasonForCancle,rating, CommonView,BankDetails,RideDetails,Addvehicle,CancelRide,Earning,Chat
    
    var value:String
    {
        switch self
        {
        case .none:
            return ""
        case .Home:
            return ""
        case .reasonForCancle:
            return "NavigationTitle_reasonForCancle"
        case .rating:
            return "NavigationTitle_Rating"
        case .CommonView:
            return "CommonView"
        case .BankDetails:
            return "Bank Details"
        case .RideDetails:
            return "Ride Details"
        case .Addvehicle:
            return "Add Vehicle"
        case .CancelRide:
            return "Cancel Ride"
        case .Earning:
            return "Earning"
        case .Chat:
            return "Chat"
        }
    }
}
