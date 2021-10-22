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
    case ProfileUpdate                          = "driver/profile/update"
    case EmailVerify                            = "email/verify"
    case PhoneNumberVerify                      = "phone/verify"
    
    case TempImageUpload                        = "image/upload"
    case TruckTypeListing                       = "truck/type/listing"
    case TruckBrandListing                      = "truck/brands"
    case TruckFeatureListing                    = "truck/features"
    case TruckUnitListing                       = "truck/unit"
    
    
    case PackageListing                         = "package/listing"
    case ShipmentList                          = "shipment/search"
    case MyLoades                               = "booking/my_loads"
    
    case BidPost                               = "driver/post/bid"
    
    case ManageDriver                           = "dispature/manage-drivers"
    case ChangePermission                       = "dispature/edit-permission"
}

 

