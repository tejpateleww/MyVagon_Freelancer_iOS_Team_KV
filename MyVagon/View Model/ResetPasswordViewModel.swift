//
//  ResetPasswordViewModel.swift
//  MyVagon
//
//  Created by Apple on 12/08/21.
//

import Foundation
import UIKit
class ResetPasswordViewModel {
    weak var setNewPasswordViewController : ChangePasswordVC? = nil
    
    func ResetNewPassword(ReqModel:ResetNewPasswordReqModel){
       
        Utilities.ShowLoaderButtonInButton(Button: self.setNewPasswordViewController?.btnSetPassword ?? themeButton(), vc: self.setNewPasswordViewController ?? UIViewController())
        WebServiceSubClass.ResetNewPassword(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.setNewPasswordViewController?.btnSetPassword ?? themeButton(), vc: self.setNewPasswordViewController ?? UIViewController())
         
            if status {
                appDel.NavigateToLogin()
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func Changepassword(ReqModel:ChangePasswordReqModel){
        
        Utilities.ShowLoaderButtonInButton(Button: self.setNewPasswordViewController?.btnSetPassword ?? themeButton(), vc: self.setNewPasswordViewController ?? UIViewController())
        WebServiceSubClass.ChangePassword(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.setNewPasswordViewController?.btnSetPassword ?? themeButton(), vc: self.setNewPasswordViewController ?? UIViewController())
           
            if status {
                self.setNewPasswordViewController?.navigationController?.popViewController(animated: true)
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}



