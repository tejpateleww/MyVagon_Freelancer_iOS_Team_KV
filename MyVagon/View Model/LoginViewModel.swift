//
//  LoginViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
import UIKit
class LoginViewModel {
    weak var signInDriverVC : SignInDriverVC? = nil
    
    func Login(ReqModel:LoginReqModel){
        Utilities.ShowLoaderButtonInButton(Button: signInDriverVC?.BtnSignIn ?? themeButton(), vc: signInDriverVC ?? UIViewController())
       // Utilities.showHud()
        WebServiceSubClass.Login(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.signInDriverVC?.BtnSignIn ?? themeButton(), vc: self.signInDriverVC ?? UIViewController())
           // Utilities.hideHud()
            if status{
                UserDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                
                SingletonClass.sharedInstance.UserProfileData = response?.data
                UserDefault.setUserData()
                if let token = response?.data?.token{
                    SingletonClass.sharedInstance.Token = token
                  
                    UserDefault.setValue(response?.data?.token, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                }
                if response?.data?.type == LoginType.freelancer.rawValue {
                    UserDefault.setValue(LoginType.freelancer.rawValue, forKey: UserDefaultsKey.LoginUserType.rawValue)
                    appDel.NavigateToHome()
                } else if response?.data?.type == LoginType.company.rawValue {
                    UserDefault.setValue(LoginType.company.rawValue, forKey: UserDefaultsKey.LoginUserType.rawValue)
                    appDel.NavigateToDispatcher()
                } else if response?.data?.type == LoginType.driver.rawValue {
                    UserDefault.setValue(LoginType.driver.rawValue, forKey: UserDefaultsKey.LoginUserType.rawValue)
                    appDel.NavigateToHome()
                }
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
               
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

enum LoginType:String {
    case freelancer
    case company
    case driver
}
