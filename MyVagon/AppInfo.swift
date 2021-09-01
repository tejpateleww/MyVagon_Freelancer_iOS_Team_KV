//
//  AppInfo.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
struct AppInfo {
    
    static var appVersion: String {
        if let app_version = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
            return app_version
        } else{
            return "no Version"
        }
    }
    
    static var appName:String{
        return Bundle.appName()
    }
    
    static var appHeaderKey:String {
        return "key"
    }
    
    static var appDynamicHeaderKey:String{
        return "x-api-key"
    }
    
    
    static var appStaticHeader:String{
        return "TempleBliss123*#*"
    }
    
    static var deviceType:String{
        return "ios"
    }
    
    static var appUrl:String{

        return "itms-apps://itunes.apple.com/app/id1547969270"
    }
    
    
    //
    static var Google_API_Key: String {
        //Added api key on 4-3-21, from newly create google project for Beat, com.eww.HCProDoctor1 bundle id
//        return "AIzaSyAsK4EKl6GkGqELS8YySwoIWVjNjAwR7dg"//"AIzaSyCEprsNUdaa55kxsn8z8m-4ECirG0dL_qM"
        return "AIzaSyD9IuC2O3dbiKoMZ5bwvLJdttBCuO-1-Rc"
    }
    //AIzaSyDqBqjXeHoTf6TC7bjs0OogaxWb0Ev_vxM
    

}


extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}
