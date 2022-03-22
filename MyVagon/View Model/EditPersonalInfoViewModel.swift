//
//  EditPersonalInfoViewModel.swift
//  MyVagon
//
//  Created by Harshit K on 15/03/22.
//

import Foundation
import UIKit


class EditPersonalInfoModel {
    
    weak var VC : EditPersonalInfoVC? = nil
    
    
    func WebServiceImageUpload(images:[UIImage],uploadFor:DocumentType){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
               
                response?.data?.images?.forEach({ element in
                    self.VC?.profileImage = response?.data?.images ?? []
                })
            } else {
               
            }
        })
    }
    func WebServiceForPersonalInfoUpdate(ReqModel:EditPersonalInfoReqModel){
        WebServiceSubClass.editPersonalInfo(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status{
                appDel.Logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
