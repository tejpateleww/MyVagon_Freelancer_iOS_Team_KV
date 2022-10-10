//
//  UrlServiceConstant.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//

import Foundation

class UrlConstant{
    
    
    //MARK:- WebService Header Key
    static let HeaderKey = "key"
    static let XApiKey = "Authorization"
    static let AppHostKey = "MyVagon"
    static let AppAuthentication = "Content-Type"
    static let AppAuthenticationValue = "application/json"
    static let ResponseMessage = "message"
    static let SomethingWentWrong = "SomethingWentWrong"
    static let NoInternetConnection = "NoInternetConnection"
    static let Localization = "X-localization"
    static let SessionExpired = "SessionExpired"
    static let Status = "status".localized
    static let Ok = "UrlConstant_Ok".Localized()
    static let RequestTimeOut = "UrlConstant_RequestTimeOut".Localized()
    static let LocationRequired = "UrlConstant_LocationRequiredMessage".Localized()
    static let Yes = "UrlConstant_Yes".Localized()
    static let Retry = "UrlConstant_Retry".Localized()
    static let Cancel = "UrlConstant_Cancel".Localized()
    
    //MARK:- Message Title
//    static let Required = "UrlConstant_Required".Localized()
//    static let Success = "UrlConstant_Success".Localized()
//    static let Failed = "UrlConstant_Failed".Localized()
//   
//    static let RequestTimeOut = "UrlConstant_RequestTimeOut".Localized()
//    static let LocationRequired = "UrlConstant_LocationRequiredMessage".Localized()
//    
//    static let Ok = "UrlConstant_Ok".Localized()
//    static let Yes = "UrlConstant_Yes".Localized()
//    static let Cancel = "UrlConstant_Cancel".Localized()
//    static let No = "UrlConstant_No".Localized()
//    static let Retry = "UrlConstant_Retry".Localized()
//    static let SelectCard = "UrlConstant_SelectCard".Localized()
//    static let Continue = "UrlConstant_Continue".Localized()
//    static let Settings = "UrlConstant_Settings".Localized()
//    static let Logout = "UrlConstant_Logout".Localized()
//    static let Help = "UrlConstant_Help".Localized()
//    static let Invalid = "UrlConstant_Invalid".Localized()
//    static let Expiry = "UrlConstant_Expiry".Localized()
//    
//    //Validation Message
//    static let ValidPhoneNo = "UrlConstant_ValidPhoneNo".Localized()
//    static let AgeIsRequired = "UrlConstant_AgeIsRequired".Localized()
//    static let AgeMustNumber = "UrlConstant_AgeMustNumber".Localized()
//    static let InvalidAgeNumber = "UrlConstant_InvalidAgeNumber".Localized()
//    static let Age18YearsOld = "UrlConstant_Age18YearsOld".Localized()
//    static let RequiredVerificationCode = "UrlConstant_RequiredVerificationCode".Localized()
//    static let InvalidVerificationCode = "UrlConstant_InvalidVerificationCode".Localized()
//    static let LogoutMessage = "UrlConstant_LogoutMessage".Localized()
//    static let InvalidEmail = "UrlConstant_InvalidEmailMessage".Localized()
//    static let EnterEmail = "UrlConstant_EnterEmailMessage".Localized()
//    static let InvalidCardNumber = "UrlConstant_InvalidCardNumber".Localized()
    
}

let SessionExpiredResponseDic = [UrlConstant.ResponseMessage: UrlConstant.SessionExpired.localized]
let SomethingWentWrongResponseDic = [UrlConstant.ResponseMessage: UrlConstant.SomethingWentWrong.localized]
let NoInternetResponseDic = [UrlConstant.ResponseMessage: UrlConstant.NoInternetConnection.localized]



