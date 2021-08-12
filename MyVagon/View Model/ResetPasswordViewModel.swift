//
//  ResetPasswordViewModel.swift
//  MyVagon
//
//  Created by Apple on 12/08/21.
//

import Foundation
class ResetPasswordViewModel {
    weak var setNewPasswordViewController : SetNewPasswordViewController? = nil
    
    func ResetNewPassword(ReqModel:ResetNewPasswordReqModel){
       
        Utilities.showHud()
        WebServiceSubClass.ResetNewPassword(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                appDel.NavigateToLogin()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}



