//
//  apiPaths.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//

import Foundation

typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum APIEnvironment : String {
 
    
    case Development = "http://13.36.112.48/api/"
    case Profilebu = "http://65.1.154.172/"
    case Live = "not provided"
    case TempProfileURL = "http://13.36.112.48/public/temp/"
    case ShipperImageURL = "https://myvagon.s3.eu-west-3.amazonaws.com/shipper/"
    case DriverImageURL = "https://myvagon.s3.eu-west-3.amazonaws.com/driver/"
    
    
    static var baseURL: String{
        return APIEnvironment.environment.rawValue
    }
    
    static var environment: APIEnvironment{
        return .Development
    }
    
    static var BearerHeader : String {
        if UserDefault.bool(forKey: UserDefaultsKey.isUserLogin.rawValue)  {
            
            if UserDefault.object(forKey:  UserDefaultsKey.userProfile.rawValue) != nil {
                do {
                    let _ = UserDefault.getUserData()
                    return "Bearer \(SingletonClass.sharedInstance.UserProfileData?.token ?? "")"
                }
            }
        }
        return ""
    }
    
    static var headers : [String:String]{
        if UserDefault.bool(forKey: UserDefaultsKey.isUserLogin.rawValue) {
            if UserDefault.object(forKey:  UserDefaultsKey.userProfile.rawValue) != nil {
                do {
                        let _ = UserDefault.getUserData()
                        return [UrlConstant.AppAuthentication : UrlConstant.AppAuthenticationValue, UrlConstant.XApiKey : "Bearer \(SingletonClass.sharedInstance.UserProfileData?.token ?? "")"]
                }
            }
        }
        return [UrlConstant.AppAuthentication : UrlConstant.AppAuthenticationValue,UrlConstant.HeaderKey : UrlConstant.AppHostKey]
    }
//    static var headers : [String:String]{
//        if UserDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) != nil {
//
//            if UserDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == true {
//
//                if UserDefault.object(forKey:  UserDefaultsKey.userProfile.rawValue) != nil {
//                    do {
////                        if UserDefaults.standard.value(forKey: UserDefaultsKey.X_API_KEY.rawValue) != nil, UserDefaults.standard.value(forKey:  UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? Bool(){
////                            return [UrlConstant.HeaderKey : UrlConstant.AppHostKey, UrlConstant.XApiKey : Singleton.sharedInstance.UserProfilData?.xAPIKey ?? ""]
////                        }else{
//                            return [UrlConstant.HeaderKey : UrlConstant.AppHostKey]
////                        }
//                    }
//                }
//            }
//        }
//        return [UrlConstant.HeaderKey : UrlConstant.AppHostKey]
//    }
}

enum ApiKey: String {
    case Init                                   = "init/ios/"
    case Login                                  = "driver/login"
    case forgotpassword                         = "forgot/password"
    case ResetPassword                          = "password/reset"
    case ChangePassword                         = "driver/change/password"
    case PostAvailability                       = "post/truck/availability"
    case Settings                               = "driver/settings"
    case GetSettings                            = "driver/get/settings"
    
    case Register                               = "driver/register"
    case EmailVerify                            = "email/verify"
    case PhoneNumberVerify                      = "phone/verify"
    
    case TempImageUpload                        = "image/upload"
    case TruckTypeListing                       = "truck/type/listing"
    case TruckBrandListing                      = "truck/brands"
    case TruckFeatureListing                    = "truck/features"
    case TruckUnitListing                       = "truck/unit"
    
    
    case PackageListing                         = "package/listing"
    case ShipmentList                          = "shipment/search"
    
    case BidPost                               = "driver/post/bid"
}

 

