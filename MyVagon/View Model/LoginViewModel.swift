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
        appDel.NavigateToHome()
//        Utilities.showHud()
//        WebServiceSubClass.Login(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
//            Utilities.hideHud()
//            if status{
//                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
//                appDel.NavigateToHome()
//            } else {
//                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
//            }
//        })
    }
}

