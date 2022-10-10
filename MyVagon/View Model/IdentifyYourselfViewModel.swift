//
//  IdentifyYourselfViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
import UIKit
class IdentifyYourselfViewModel {
    weak var identifyYourselfVC : IdentifyYourselfVC? = nil
    
    func WebServiceImageUpload(images:[UIImage],uploadFor:DocumentType){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
            
                response?.data?.images?.forEach({ element in
                    if uploadFor == .IdentityProof {
                        self.identifyYourselfVC?.idProofImage = response?.data?.images?.first ?? ""
                    }else if uploadFor == .Licence {
                        self.identifyYourselfVC?.licenceImage = response?.data?.images?.first ?? ""
                    }else if uploadFor == .LicenceBack {
                        self.identifyYourselfVC?.licenceBackImag = response?.data?.images?.first ?? ""
                    }
                })
               
              
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
                if uploadFor == .IdentityProof {
                    self.identifyYourselfVC?.ImageViewIdentity = nil
                    self.identifyYourselfVC?.idProofImage = ""
                }else if uploadFor == .Licence {
                    self.identifyYourselfVC?.ImageViewLicence = nil
                    self.identifyYourselfVC?.licenceImage = ""
                }else if uploadFor == .LicenceBack {
                    self.identifyYourselfVC?.imageLicenceBack = nil
                    self.identifyYourselfVC?.licenceBackImag = ""
                }
            }
        })
    }
    
    func WebServiceForLicenceDeatilUpdate(ReqModel:EditLicenceDetailsReqModel){
        Utilities.ShowLoaderButtonInButton(Button: identifyYourselfVC?.NextButton ?? themeButton(), vc: identifyYourselfVC ?? UIViewController())
        WebServiceSubClass.updateLicenceDetail(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.identifyYourselfVC?.NextButton ?? themeButton(), vc: self.identifyYourselfVC ?? UIViewController())
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
enum DocumentType {
    case IdentityProof
    case LicenceBack
    case Licence
    case Vehicle
    case Profile
}
