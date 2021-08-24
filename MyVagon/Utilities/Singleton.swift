//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit
class SingletonClass: NSObject
{
    static let sharedInstance = SingletonClass()
    
    //Login Data
    var UserProfileData : LoginDatum?
    var Token = ""
    
    //Default device data
    var DeviceName = UIDevice.modelName
    var DeviceToken : String? = "1111"
    var DeviceType : String? = "ios"
    var AppVersion : String?
    
    //Language
    var SelectedLanguage : String = ""
    
   
    //Truck Data
    var TruckTypeList : [TruckTypeDatum]?
    var TruckBrandList : [TruckBrandsDatum]?
    var TruckFeatureList : [TruckFeaturesDatum]?
    var TruckunitList : [TruckUnitDatum]?
    
    
    func ClearSigletonClassForLogin() {
        UserProfileData = nil
        Token = ""
    }
    
    
    
    //RegisterData and methods
    func clearSingletonClassForRegister() {
        UserDefault.setValue(-1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
        Reg_FullName = ""
        Reg_CountryCode = ""
        Reg_PhoneNumber = ""
        Reg_Email = ""
        Reg_Password = ""
        Reg_TruckType = ""
        Reg_SubTruckType = ""
        Reg_TruckWeight = ""
        Reg_TruckWeightUnit = ""
        Reg_TruckLoadCapacity = ""
        Reg_TruckLoadCapacityUnit = ""
        Reg_TruckBrand = ""
        Reg_Pallets = ""
        Reg_TruckCapacity = ""
        Reg_CargorLoadCapacity = ""
        Reg_AdditionalTypes = []
        Reg_TruckFualType = ""
        Reg_RegistrationNumber = ""
        Reg_VehiclePhoto = []
        Reg_vehicalPhotoName = ""
        Reg_IdentityProofDocument = []
        Reg_IdentityProofDocumentName = ""
        Reg_LicenceDocument = []
        Reg_LicenceDocumentname = ""
        Reg_EmailVerified = false
        Reg_PhoneVerified = false
        SaveRegisterDataToUserDefault()
        
    }
    func SaveRegisterDataToUserDefault() {
        let SaveData : [String:Any] = ["Reg_FullName":Reg_FullName,
                                       "Reg_CountryCode":Reg_CountryCode,
                                       "Reg_PhoneNumber":Reg_PhoneNumber,
                                       "Reg_Email":Reg_Email,
                                       "Reg_Password":Reg_Password,
                                       "Reg_TruckType":Reg_TruckType,
                                       "Reg_SubTruckType":Reg_SubTruckType,
                                       "Reg_TruckWeight":Reg_TruckWeight,
                                       "Reg_TruckWeightUnit":Reg_TruckWeightUnit,
                                       "Reg_TruckLoadCapacity":Reg_TruckLoadCapacity,
                                       "Reg_TruckLoadCapacityUnit":Reg_TruckLoadCapacityUnit,
                                       "Reg_TruckBrand":Reg_TruckBrand,
                                       "Reg_Pallets":Reg_Pallets,
                                       "Reg_TruckCapacity":Reg_TruckCapacity,
                                       "Reg_CargorLoadCapacity":Reg_CargorLoadCapacity,
                                       "Reg_AdditionalTypes":Reg_AdditionalTypes,
                                       "Reg_TruckFualType":Reg_TruckFualType,
                                       "Reg_RegistrationNumber":Reg_RegistrationNumber,
                                       "Reg_VehiclePhoto":Reg_VehiclePhoto,
                                       "Reg_vehicalPhotoName":Reg_vehicalPhotoName,
                                       "Reg_IdentityProofDocument":Reg_IdentityProofDocument,
                                       "Reg_IdentityProofDocumentName":Reg_IdentityProofDocumentName,
                                       "Reg_LicenceDocument":Reg_LicenceDocument,
                                       "Reg_LicenceDocumentname":Reg_LicenceDocumentname,
                                       "Reg_EmailVerified":Reg_EmailVerified,
                                       "Reg_PhoneVerified":Reg_PhoneVerified]
        
        UserDefault.setValue(SaveData, forKey: UserDefaultsKey.RegisterData.rawValue)
        UserDefault.synchronize()
    }
    func GetRegisterData() {
        if let SavedData = UserDefault.value(forKey: UserDefaultsKey.RegisterData.rawValue) as? [String:Any] {
            Reg_FullName = SavedData["Reg_FullName"] as? String ?? ""
            Reg_CountryCode = SavedData["Reg_CountryCode"] as? String ?? ""
            Reg_PhoneNumber = SavedData["Reg_PhoneNumber"] as? String ?? ""
            Reg_Email = SavedData["Reg_Email"] as? String ?? ""
            Reg_Password = SavedData["Reg_Password"] as? String ?? ""
            Reg_TruckType = SavedData["Reg_TruckType"] as? String ?? ""
            Reg_SubTruckType = SavedData["Reg_SubTruckType"] as? String ?? ""
            Reg_TruckWeight = SavedData["Reg_TruckWeight"] as? String ?? ""
            Reg_TruckWeightUnit = SavedData["Reg_TruckWeightUnit"] as? String ?? ""
            Reg_TruckLoadCapacity = SavedData["Reg_TruckLoadCapacity"] as? String ?? ""
            Reg_TruckLoadCapacityUnit = SavedData["Reg_TruckLoadCapacityUnit"] as? String ?? ""
            Reg_TruckBrand = SavedData["Reg_TruckBrand"] as? String ?? ""
            Reg_Pallets = SavedData["Reg_Pallets"] as? String ?? ""
            Reg_TruckCapacity = SavedData["Reg_TruckCapacity"] as? String ?? ""
            Reg_CargorLoadCapacity = SavedData["Reg_CargorLoadCapacity"] as? String ?? ""
            Reg_AdditionalTypes = SavedData["Reg_AdditionalTypes"] as? [String] ?? []
            Reg_TruckFualType = SavedData["Reg_TruckFualType"] as? String ?? ""
            Reg_RegistrationNumber = SavedData["Reg_RegistrationNumber"] as? String ?? ""
            Reg_VehiclePhoto = SavedData["Reg_VehiclePhoto"] as? [String] ?? []
            Reg_vehicalPhotoName = SavedData["Reg_VehiclePhoto"] as? String ?? ""
            Reg_IdentityProofDocument = SavedData["Reg_IdentityProofDocument"] as? [String] ?? []
            Reg_IdentityProofDocumentName = SavedData["Reg_IdentityProofDocumentName"] as? String ?? ""
            Reg_LicenceDocument = SavedData["Reg_LicenceDocument"] as? [String] ?? []
            Reg_LicenceDocumentname = SavedData["Reg_LicenceDocumentname"] as? String ?? ""
            Reg_PhoneVerified = SavedData["Reg_PhoneVerified"] as? Bool ?? false
            Reg_EmailVerified = SavedData["Reg_EmailVerified"] as? Bool ?? false
        
        }
        
    }
    
    var Reg_FullName = ""
    var Reg_CountryCode = ""
    var Reg_PhoneNumber = ""
    var Reg_Email = ""
    var Reg_Password = ""
    
    var Reg_TruckType = ""
    var Reg_SubTruckType = ""
    var Reg_TruckWeight = ""
    var Reg_TruckWeightUnit = ""
    var Reg_TruckLoadCapacity = ""
    var Reg_TruckLoadCapacityUnit = ""
    
    var Reg_TruckBrand = ""
    var Reg_TruckCapacity = ""
    var Reg_Pallets = ""
  
    var Reg_CargorLoadCapacity = ""
    var Reg_AdditionalTypes : [String] = []
    var Reg_TruckFualType = ""
    var Reg_RegistrationNumber = ""
    var Reg_VehiclePhoto : [String] = []
    var Reg_vehicalPhotoName = ""
    
    var Reg_IdentityProofDocument : [String] = []
    var Reg_IdentityProofDocumentName = ""
    
    var Reg_LicenceDocument : [String] = []
    var Reg_LicenceDocumentname = ""
    
    var Reg_EmailVerified : Bool = false
    var Reg_PhoneVerified : Bool = false
    
}
