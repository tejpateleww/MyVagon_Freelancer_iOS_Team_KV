//
//  RegisterViewModel.swift
//  MyVagon
//
//  Created by Apple on 23/09/21.
//

import Foundation
import UIKit
class RegisterViewModel {
    weak var paymentsVC : PaymentsVC? = nil
    
    func WebServiceForRegister(ReqModel:RegisterReqModel){
        Utilities.ShowLoaderButtonInButton(Button: paymentsVC?.btnSave ?? themeButton(), vc: paymentsVC ?? UIViewController())
        WebServiceSubClass.Register(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.paymentsVC?.btnSave ?? themeButton(), vc: self.paymentsVC ?? UIViewController())
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
