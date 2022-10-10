//
//  LoginViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
import UIKit
class LoginViewModel {
    weak var VC : LoginVC? = nil
    func Login(ReqModel:LoginReqModel){
        VC?.btnSignIn.showLoading()
        WebServiceSubClass.Login(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnSignIn.hideLoading()
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
                }else if response?.data?.type == LoginType.driver.rawValue {
                    UserDefault.setValue(LoginType.driver.rawValue, forKey: UserDefaultsKey.LoginUserType.rawValue)
                    appDel.NavigateToHome()
                }else if response?.data?.type == LoginType.dispatcher_driver.rawValue {
                    UserDefault.setValue(LoginType.dispatcher_driver.rawValue, forKey: UserDefaultsKey.LoginUserType.rawValue)
                    appDel.NavigateToHome()
                }
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
    case dispatcher_driver
}
