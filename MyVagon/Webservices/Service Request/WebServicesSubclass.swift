//
//  WebServicesSubclass.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//

import Foundation
import UIKit
class WebServiceSubClass{

//    //MARK:- Init
//    class func InitApi(completion: @escaping (Bool,String,InitResponseModel?,Any) -> ()) {
//        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.Init.rawValue + kAPPVesion + "/" + Singleton.sharedInstance.UserId, responseModel: InitResponseModel.self) { (status, message, response, error) in
//            completion(status, message, response, error)
//        }
//    }
    
    //MARK: -Login
    class func Login(reqModel: LoginReqModel, completion: @escaping (Bool,String,LoginResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.Login.rawValue, requestModel: reqModel, responseModel: LoginResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Forgot Password
    class func ForgotPasswordOTP(reqModel: ForgotPasswordReqModel, completion: @escaping (Bool,String,VerifyResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.forgotpassword.rawValue, requestModel: reqModel, responseModel: VerifyResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -ResetNewPassword
    class func ResetNewPassword(reqModel: ResetNewPasswordReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ResetPassword.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -ChangePassword
    class func ChangePassword(reqModel: ChangePasswordReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ChangePassword.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -PostTruck
    class func PostTruck(reqModel: PostTruckReqModel, completion: @escaping (Bool,String,PostTruckResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.PostAvailability.rawValue, requestModel: reqModel, responseModel: PostTruckResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Settings
    class func Settings(reqModel: SettingsReqModel, completion: @escaping (Bool,String,SettingsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.Settings.rawValue, requestModel: reqModel, responseModel: SettingsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -GetSettings
    class func GetSettings(reqModel: GetSettingsListReqModel, completion: @escaping (Bool,String,SettingsGetResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.GetSettings.rawValue, requestModel: reqModel, responseModel: SettingsGetResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -VerifyEmail
    class func VerifyEmail(reqModel: EmailVerifyReqModel, completion: @escaping (Bool,String,VerifyResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.EmailVerify.rawValue, requestModel: reqModel, responseModel: VerifyResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -VerifyPhone
    class func VerifyPhone(reqModel: MobileVerifyReqModel, completion: @escaping (Bool,String,VerifyResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.PhoneNumberVerify.rawValue, requestModel: reqModel, responseModel: VerifyResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Register
    class func Register(reqModel: RegisterReqModel, completion: @escaping (Bool,String,RegisterResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.Register.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    
    //MARK: -TruckType
    class func TruckType(completion: @escaping (Bool,String,TruckTypeListingResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckTypeListing.rawValue, responseModel: TruckTypeListingResModel.self) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckTypeList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -PackageListing
    class func PackageListing(completion: @escaping (Bool,String,PackageListingResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.PackageListing.rawValue, responseModel: PackageListingResModel.self) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.PackageList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -TruckUnit
    class func TruckUnit(completion: @escaping (Bool,String,TruckUnitResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckUnitListing.rawValue, responseModel: TruckUnitResModel.self) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckunitList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -TruckFeatures
    class func TruckFeatures(completion: @escaping (Bool,String,TruckFeaturesResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckFeatureListing.rawValue, responseModel: TruckFeaturesResModel.self) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckFeatureList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -TruckBrand
    class func TruckBrand(completion: @escaping (Bool,String,TruckBrandsResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckBrandListing.rawValue, responseModel: TruckBrandsResModel.self) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckBrandList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -ImageUpload
    class func ImageUpload(imgArr:[UIImage], completion: @escaping (Bool,String,ImageUploadResModel?,Any) -> ()){
        
        URLSessionRequestManager.makeMultipleImageRequest(urlString: ApiKey.TempImageUpload.rawValue, requestModel: [String:String](), responseModel: ImageUploadResModel.self, imageKey: "images[]", arrImageData: imgArr) { status, message, response, error in
            completion(status, message, response, error)
        }
        
    }
    
    //MARK: -DocumentUpload
    class func DocumentUpload(Documents:[UploadMediaModel], completion: @escaping (Bool,String,ImageUploadResModel?,Any) -> ()){
        
        URLSessionRequestManager.makeMultipleMediaUploadRequest(urlString: ApiKey.TempImageUpload.rawValue, requestModel: [String:String](), responseModel: ImageUploadResModel.self, mediaArr: Documents) { status, message, response, error in
            completion(status, message, response, error)
        }
        
        
     
        
    }
    //MARK: -GetShipmentList
    class func GetShipmentList(reqModel: ShipmentListReqModel, completion: @escaping (Bool,String,HomeNewResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.SearchLoads.rawValue, requestModel: reqModel, responseModel: HomeNewResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -SearchShipemnet
    class func SearchShipment(reqModel: SearchLoadReqModel, completion: @escaping (Bool,String,HomeShipmentSearchResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.SearchLoads.rawValue, requestModel: reqModel, responseModel: HomeShipmentSearchResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -BidPost
    class func BidPost(reqModel: BidReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.BidPost.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -GetMyLoadesList
    class func GetMyLoadesList(reqModel: MyLoadsReqModel, completion: @escaping (Bool,String,MyLoadsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.MyLoades.rawValue, requestModel: reqModel, responseModel: MyLoadsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- ProfileEdit
    class func ProfileEdit(reqModel: ProfileEditReqModel, completion: @escaping (Bool,String,LoginResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ProfileUpdate.rawValue, requestModel: reqModel, responseModel: LoginResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- GetDriverList
    class func GetDriverList(reqModel: GetDriverListReqModel, completion: @escaping (Bool,String,DriverListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ManageDriver.rawValue, requestModel: reqModel, responseModel: DriverListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Settings
    class func PermissionSettings(reqModel: ChangePermissionReqModel, completion: @escaping (Bool,String,DriverPermissionChangeResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ChangePermission.rawValue, requestModel: reqModel, responseModel: DriverPermissionChangeResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
}
