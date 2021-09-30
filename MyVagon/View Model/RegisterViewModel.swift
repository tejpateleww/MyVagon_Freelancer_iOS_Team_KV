//
//  RegisterViewModel.swift
//  MyVagon
//
//  Created by Apple on 23/09/21.
//

import Foundation
import UIKit
class RegisterViewModel {
    weak var termsConditionVC : TermsConditionVC? = nil
    
    func WebServiceForRegister(ReqModel:RegisterReqModel){
        Utilities.ShowLoaderButtonInButton(Button: termsConditionVC?.btnRegister ?? themeButton(), vc: termsConditionVC ?? UIViewController())
        WebServiceSubClass.Register(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.termsConditionVC?.btnRegister ?? themeButton(), vc: self.termsConditionVC ?? UIViewController())
            if status{
                UserDefault.removeObject(forKey: UserDefaultsKey.RegisterData.rawValue)
    
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                SingletonClass.sharedInstance.clearSingletonClassForRegister()
                appDel.NavigateToLogin()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
