//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
class SingletonClass: NSObject
{
    var SelectedLanguage : String = ""
    
    static let sharedInstance = SingletonClass()
    
   
    
    func clearSingletonClass() {
        
        Reg_FullName = ""
        Reg_CountryCode = ""
        Reg_PhoneNumber = ""
        Reg_Email = ""
        Reg_Password = ""
        Reg_TruckType = ""
        Reg_TruckWeight = ""
        Reg_TruckWeightUnit = ""
        Reg_TruckLoadCapacity = ""
        Reg_TruckLoadCapacityUnit = ""
        Reg_TruckBrand = ""
        Reg_TruckCapacity = ""
        Reg_CargorLoadCapacity = ""
        Reg_OtherTypes = []
        Reg_TruckFualType = ""
        Reg_RegistrationNumber = ""
        Reg_VehiclePhoto = Data()
        Reg_vehicalPhotoName = ""
        Reg_IdentityProofDocument = Data()
        Reg_IdentityProofDocumentName = ""
        LicenceDocument = Data()
        LicenceDocumentname = ""
        
    }
    func SaveRegisterDataToUserDefault() {
        let SaveData : [String:Any] = ["Reg_FullName":Reg_FullName,
                                       "Reg_CountryCode":Reg_CountryCode,
                                       "Reg_PhoneNumber":Reg_PhoneNumber,
                                       "Reg_Email":Reg_Email,
                                       "Reg_Password":Reg_Password,
                                       "Reg_TruckType":Reg_TruckType,
                                       "Reg_TruckWeight":Reg_TruckWeight,
                                       "Reg_TruckWeightUnit":Reg_TruckWeightUnit,
                                       "Reg_TruckLoadCapacity":Reg_TruckLoadCapacity,
                                       "Reg_TruckLoadCapacityUnit":Reg_TruckLoadCapacityUnit,
                                       "Reg_TruckBrand":Reg_TruckBrand,
                                       "Reg_TruckCapacity":Reg_TruckCapacity,
                                       "Reg_CargorLoadCapacity":Reg_CargorLoadCapacity,
                                       "Reg_OtherTypes":Reg_OtherTypes,
                                       "Reg_TruckFualType":Reg_TruckFualType,
                                       "Reg_RegistrationNumber":Reg_RegistrationNumber,
                                       "Reg_VehiclePhoto":Reg_VehiclePhoto,
                                       "Reg_vehicalPhotoName":Reg_vehicalPhotoName,
                                       "Reg_IdentityProofDocument":Reg_IdentityProofDocument,
                                       "Reg_IdentityProofDocumentName":Reg_IdentityProofDocumentName,
                                       "LicenceDocument":LicenceDocument,
                                       "LicenceDocumentname":LicenceDocumentname]
        
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
            Reg_TruckWeight = SavedData["Reg_TruckWeight"] as? String ?? ""
            Reg_TruckWeightUnit = SavedData["Reg_TruckWeightUnit"] as? String ?? ""
            Reg_TruckLoadCapacity = SavedData["Reg_TruckLoadCapacity"] as? String ?? ""
            Reg_TruckLoadCapacityUnit = SavedData["Reg_TruckLoadCapacityUnit"] as? String ?? ""
            Reg_TruckBrand = SavedData["Reg_TruckBrand"] as? String ?? ""
            Reg_TruckCapacity = SavedData["Reg_TruckCapacity"] as? String ?? ""
            Reg_CargorLoadCapacity = SavedData["Reg_CargorLoadCapacity"] as? String ?? ""
            Reg_OtherTypes = SavedData["Reg_OtherTypes"] as? [String] ?? []
            Reg_TruckFualType = SavedData["Reg_TruckFualType"] as? String ?? ""
            Reg_RegistrationNumber = SavedData["Reg_RegistrationNumber"] as? String ?? ""
            Reg_VehiclePhoto = SavedData["Reg_VehiclePhoto"] as? Data ?? Data()
            Reg_vehicalPhotoName = SavedData["Reg_VehiclePhoto"] as? String ?? ""
            Reg_IdentityProofDocument = SavedData["Reg_IdentityProofDocument"] as? Data ?? Data()
            Reg_IdentityProofDocumentName = SavedData["Reg_IdentityProofDocumentName"] as? String ?? ""
            LicenceDocument = SavedData["LicenceDocument"] as? Data ?? Data()
            LicenceDocumentname = SavedData["LicenceDocumentname"] as? String ?? ""
        }
        
       
        
    }
    
    var Reg_FullName = ""
    var Reg_CountryCode = ""
    var Reg_PhoneNumber = ""
    var Reg_Email = ""
    var Reg_Password = ""
    
    var Reg_TruckType = ""
    var Reg_TruckWeight = ""
    var Reg_TruckWeightUnit = ""
    var Reg_TruckLoadCapacity = ""
    var Reg_TruckLoadCapacityUnit = ""
    
    var Reg_TruckBrand = ""
    var Reg_TruckCapacity = ""
    var Reg_CargorLoadCapacity = ""
    var Reg_OtherTypes : [String] = []
    var Reg_TruckFualType = ""
    var Reg_RegistrationNumber = ""
    var Reg_VehiclePhoto = Data()
    var Reg_vehicalPhotoName = ""
    
    var Reg_IdentityProofDocument = Data()
    var Reg_IdentityProofDocumentName = ""
    
    var LicenceDocument = Data()
    var LicenceDocumentname = ""
    
}
