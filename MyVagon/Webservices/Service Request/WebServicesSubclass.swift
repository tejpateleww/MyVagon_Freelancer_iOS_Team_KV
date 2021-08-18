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
    
    
}
