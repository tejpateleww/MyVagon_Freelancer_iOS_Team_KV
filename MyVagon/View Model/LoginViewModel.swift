//
//  LoginViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
class LoginViewModel {
    weak var signInDriverVC : SignInDriverVC? = nil
    
    func Login(ReqModel:LoginReqModel){
        Utilities.showHud()
//        appDel.NavigateToHome()
        WebServiceSubClass.Login(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                appDel.NavigateToHome()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

