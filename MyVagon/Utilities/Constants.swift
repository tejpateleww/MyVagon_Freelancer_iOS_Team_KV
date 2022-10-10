//
//  Constants.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 02/10/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit

let DateFormatForDisplay = "EEEE, dd/MM/yyyy"
let timeFormatForDisplay = "EEEE, dd/MM/yyyy h:mm a"
let Currency = "€"
var PageLimit = 10
let keywindow = UIApplication.shared.keyWindow
var UserDefault = UserDefaults.standard
let appDel = UIApplication.shared.delegate as! AppDelegate
let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
let AppName = AppInfo.appName
let AppURL = AppInfo.appUrl // "itms-apps://itunes.apple.com/app/id1547969270"
let ReqDeviceType = "1"
let Headerkey = ""

let NotificationBadges = NSNotification.Name(rawValue:"NotificationBadges")

var NameTotalCount = 30

let RingtoneSoundName = "Reflection"
let CallKitIconName = "notification_icon"

let RefreshControlColor : UIColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)

let MaximumFileUploadSize:Double = 10.0

typealias EmptyClosure = () -> Void



enum DateFormatterString : String{
    case timeWithDate = "yyyy-MM-dd HH:mm:ss"
    case onlyDate = "dd-MM-yyyy"
    case onlyTime = "h:mm a"
}


var RequestRejectMessage = "Request rejected"


struct DeviceType {
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_SE         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

struct ScreenSize {

    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)

}

enum GlobalStrings : String{
    case Alert_logout = "Are you sure you want to logout ?"
}
enum ErrorMessages : String{
    case Invelid_Otp = "Please enter valid OTP"
}

