//
//  apiPaths.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//

import Foundation

typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum APIEnvironment  {
 
    static var environment: Environment{
        return .Development
    }
    
    static var socketBaseURL : String {
        if APIEnvironment.environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.DevelopmentSocketBaseURL.rawValue
        } else {
            return BaseURLS.LiveSocketBaseURL.rawValue
        }
    }
    
    static var PODImageURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.PODImageURL.rawValue
        } else {
            return BaseURLS.PODImageURL.rawValue
        }
    }
    
    static var TempProfileURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.TempProfileURL.rawValue
        } else {
            return BaseURLS.TempProfileURL.rawValue
        }
    }
    
    static var ShipperImageURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.ShipperImageURL.rawValue
        } else {
            return BaseURLS.ShipperImageURL.rawValue
        }
    }
    
    static var DriverImageURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.DriverImageURL.rawValue
        } else {
            return BaseURLS.DriverImageURL.rawValue
        }
    }
    
    static var baseURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.DevelopmentServer.rawValue
        } else {
            return BaseURLS.LiveServer.rawValue
        }
    }
    
    static var profileBaseURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.Copydevelopement.rawValue
        } else {
            return BaseURLS.CopyLiveServer.rawValue
        } 
    }
    
    static var tempURL : String {
        if environment.rawValue == Environment.Development.rawValue {
            return BaseURLS.devlopmentProfile.rawValue
        } else {
            return BaseURLS.liveProfile.rawValue
        }
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
        let langCode = Localize.currentLanguage()
        if UserDefault.bool(forKey: UserDefaultsKey.isUserLogin.rawValue) {
            if UserDefault.object(forKey:  UserDefaultsKey.userProfile.rawValue) != nil {
                do {
                    let _ = UserDefault.getUserData()
                    return [UrlConstant.Localization : langCode,UrlConstant.AppAuthentication : UrlConstant.AppAuthenticationValue, UrlConstant.XApiKey : "Bearer \(SingletonClass.sharedInstance.UserProfileData?.token ?? "")"]
                }
            }
        }
        return [UrlConstant.Localization : langCode,UrlConstant.AppAuthentication : UrlConstant.AppAuthenticationValue,UrlConstant.HeaderKey : UrlConstant.AppHostKey]
    }
}

enum ApiKey: String {
    case Init                                   = "init/ios_driver"
    case Login                                  = "driver/login"
    case forgotpassword                         = "forgot/password"
    case ResetPassword                          = "password/reset"
    case ChangePassword                         = "driver/change/password"
    case PostAvailability                       = "post-availability"
    case Settings                               = "driver/settings"
    case GetSettings                            = "driver/get/settings"
    case Register                               = "driver/register_new"
    case ProfileUpdate                          = "driver/profile/update"
    case EmailVerify                            = "email/verify"
    case PhoneNumberVerify                      = "phone/verify"
    case TempImageUpload                        = "image/upload"
    case TruckTypeListing                       = "truck/type/listing"
    case TruckBrandListing                      = "truck/brands"
    case TruckFeatureListing                    = "truck/features"
    case TruckUnitListing                       = "truck/unit"
    case CancellationReason                     = "cancellation-reasons"
    case PackageListing                         = "package/listing"
    case ShipmentList                           = "shipment/search"
    case SearchLoads                            = "search-loads"
    case BookNow                                = "driver/post/book"
    case BidRequest                             = "bid-requests"
    case PostAvailabilityResult                 = "post-availability-result"
    case BidRequestAcceptreject                 = "bid-request-accept-reject"
    case SystemDateTime                         = "system-date-time"
    case RejectBookingRequest                   = "RejectBookingRequest"
    case MyLoades                               = "my-loads"
    case BidPost                                = "driver/post/bid"
    case ManageDriver                           = "dispature/manage-drivers"
    case ChangePermission                       = "dispature/edit-permission"
    case BookingLoadDetails                     = "booking-load-detail"
    case ArrivedAtLocation                      = "arrived-at-location"
    case StartLoading                           = "start-loading"
    case StartJourney                           = "start-journey"
    case CompleteTrip                           = "complete-trip"
    case UploadPOD                              = "upload-pod"
    case RateShipper                            = "review-rating"
    case NotificationList                       = "notification-list"
    case CancelRequest                          = "cancel-bid-request"
    case DeleteRequest                          = "cancel-request"
    case chatMessages                           = "chat-messages"
    case chatUsers                              = "chat-users"
    case statisticsDetail                       = "statistics-detail"
    case acceptPayment                          = "accept-payment"
    case contactUs                              = "contact-us"
    case statistics                             = "statistics"
    case getPaymentDetails                      = "get-payment-details"
    case updatePaymentDetails                   = "update-bank-details"
    case shipperDetail                          = "shipper-detail"
    case locationDetail                         = "location-details"
    case updateBasicDetails                     = "update-basic-details"
    case updateLicenceDetails                   = "update-personal-details"
    case tractorDetailEdit                      = "update-tractor-details"
    case editTruckDetail                        = "update-truck-details"
    case addTruck                               = "add-truck-details"
    case relatedMatch                           = "related-matches"
    case startTrip                              = "start-trip"
    case cancelBookRequest                      = "cancel-book-request"
    case removeTruckDetails                     = "remove-truck-details"
    case trashPostedTruck                       = "trash-posted-truck"
    case makeAsDefaultTruck                     = "make-as-default-truck"
    case logOut                                 = "logout"
    case driverGetSetting                       = "driver-get-settings"
    case driverEditSettings                     = "driver-edit-settings"
    case changeLanguage                         = "change-language"
    case deleteUser                             = ""
}

enum socketApiKeys : String {
    case driverConnect = "driver_connect"
    case updateLocation = "update_location"
    case startTrip = "start_trip"
    case HideAtPickup = "hide_at_pickup"
    //Chat
    case SendMessage                              = "send_message"
    case ReceiverMessage                          = "new_message"
}

enum BaseURLS:String {
    case TempProfileURL = "http://3.66.160.72/public/temp/"
    case ShipperImageURL = "https://myvagon.s3.eu-west-3.amazonaws.com/shipper/"
    case DriverImageURL = "https://myvagon.s3.eu-west-3.amazonaws.com/driver/"
    case PODImageURL = "https://myvagon.s3.eu-west-3.amazonaws.com/POD/"
    //App urls
    case DevelopmentServer = "http://3.66.160.72/api/"
    case Copydevelopement = "http://3.66.160.72/"
    case devlopmentProfile = "http://3.66.160.72/temp/"
    case liveProfile = "http://13.36.112.48/temp/"
    case LiveServer = "http://13.36.112.48/api/"
    case CopyLiveServer = "http://13.36.112.48/"
    //socket
    case LiveSocketBaseURL = "http://13.36.112.48:3000"
    case DevelopmentSocketBaseURL = "http://3.66.160.72:3000"
}

enum Environment : String {
    case Development
    case Live
}

