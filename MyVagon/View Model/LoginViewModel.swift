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
        WebServiceSubClass.Login(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                UserDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                
                SingletonClass.sharedInstance.UserProfileData = response?.data
                UserDefault.setUserData()
                if let token = response?.data?.token{
                    SingletonClass.sharedInstance.Token = token
                  
                    UserDefault.setValue(response?.data?.token, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                }
                
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                appDel.NavigateToHome()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

