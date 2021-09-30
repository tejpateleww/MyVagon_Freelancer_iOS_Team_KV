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
    case none, back, chat , chatList
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .back:
            return "back"
        case .chat:
            return "chat"
        case .chatList:
            return "chatList"
        }
    }
}


enum NavItemsRight {
    case none,skip,chat,notification,RequestEdit ,contactus
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .skip:
            return "skip"
        case .chat:
            return "chat"
        case .notification:
            return "notification"
        case .RequestEdit:
            return "RequestEdit"
        case .contactus:
            return "contactus"
        }
       
    }
}
enum NavTitles
{
    case none,TruckType,TermsCondition
    
    var value:String
    {
        switch self
        {
        case .none:
            return ""
        case .TruckType:
            return "Truck Type"
        case .TermsCondition:
        return "Terms & Conditions"
        
        }
    }
}
