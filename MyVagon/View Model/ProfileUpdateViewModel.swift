//
//  ProfileUpdateViewModel.swift
//  MyVagon
//
//  Created by Apple on 07/10/21.
//

import Foundation

import UIKit
class ProfileUpdateViewModel {
    weak var profileEditViewController : ProfileEditViewController? = nil
    
    func WebserviceForProfileEidt(ReqModel:ProfileEditReqModel){
        Utilities.ShowLoaderButtonInButton(Button: profileEditViewController?.btnUpdate ?? themeButton(), vc: profileEditViewController ?? UIViewController())
        WebServiceSubClass.ProfileEdit(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.profileEditViewController?.btnUpdate ?? themeButton(), vc: self.profileEditViewController ?? UIViewController())
            if status{
              
                UserDefault.setValue(SingletonClass.sharedInstance.Token, forKey: UserDefaultsKey.X_API_KEY.rawValue)
              
                SingletonClass.sharedInstance.UserProfileData = response?.data
                SingletonClass.sharedInstance.UserProfileData?.token = SingletonClass.sharedInstance.Token
                UserDefault.setUserData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfileEdit"), object: nil, userInfo: nil)
    
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                self.profileEditViewController?.navigationController?.popViewController(animated: true)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    func WebServiceImageUpload(images:[UIImage],uploadFor:DocumentType){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
               
                response?.data?.images?.forEach({ element in
                    if uploadFor == .IdentityProof {
                        
                        SingletonClass.sharedInstance.ProfileData.Reg_id_proof = response?.data?.images ?? []
                    } else if uploadFor == .Licence {
                        SingletonClass.sharedInstance.ProfileData.Reg_license = response?.data?.images ?? []
                    } else if uploadFor == .Vehicle {
                        self.profileEditViewController?.arrImages.append(element)
                        self.profileEditViewController?.collectionImages.reloadData()
                    } else if uploadFor == .Profile {
                        SingletonClass.sharedInstance.ProfileData.Reg_profilePic = response?.data?.images ?? []
                    }
                    
                })
               
              
            } else {
                if uploadFor == .IdentityProof {
                    self.profileEditViewController?.ImageViewIdentity = nil
                } else if uploadFor == .Licence {
                    self.profileEditViewController?.ImageViewLicence = nil
                }
            }
        })
    }
    
}
