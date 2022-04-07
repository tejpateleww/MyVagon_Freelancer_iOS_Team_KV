//
//  EditLicenceDetailViewModel.swift
//  MyVagon
//
//  Created by Harshit K on 16/03/22.
//

import Foundation
import UIKit

class EditLicenceDetailViewModel {
    weak var editLicenceDetailsVC : EditLicenceDetailsVC? = nil
    
    func WebServiceImageUpload(images:[UIImage],uploadFor:DocumentType){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
            
                response?.data?.images?.forEach({ element in
                    if uploadFor == .IdentityProof {
                        self.editLicenceDetailsVC?.idProofImage = element
                    } else if uploadFor == .Licence {
                        self.editLicenceDetailsVC?.licenceImage = element
                    }
                    
                })
              
            } else {
                if uploadFor == .IdentityProof {
                    self.editLicenceDetailsVC?.ImageViewIdentity = nil
                } else if uploadFor == .Licence {
                    self.editLicenceDetailsVC?.ImageViewLicence = nil
                }
            }
        })
    }
    
    
    func WebServiceForLicenceDeatilUpdate(ReqModel:EditLicenceDetailsReqModel){
        Utilities.ShowLoaderButtonInButton(Button: editLicenceDetailsVC?.SaveButton ?? themeButton(), vc: editLicenceDetailsVC ?? UIViewController())
        WebServiceSubClass.updateLicenceDetail(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.editLicenceDetailsVC?.SaveButton ?? themeButton(), vc: self.editLicenceDetailsVC ?? UIViewController())
            if status{
                //self.VC?.popBack()
                AppDelegate.shared.Logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
}
