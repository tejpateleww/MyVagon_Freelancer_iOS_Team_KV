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
    case none, back
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .back:
            return "back"
        
        }
    }
}


enum NavItemsRight {
    case none,skip
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .skip:
            return "skip"
        
        }
       
    }
}
enum NavTitles
{
    case none,TruckType
    
    var value:String
    {
        switch self
        {
        case .none:
            return ""
        case .TruckType:
            return "Truck Type"
        
        }
    }
}
