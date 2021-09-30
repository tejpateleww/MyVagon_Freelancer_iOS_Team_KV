//
//  ForgotPasswordViewModel.swift
//  MyVagon
//
//  Created by Apple on 12/08/21.
//

import Foundation
import UIKit
class ForgotPasswordViewModel {
    weak var sendOTPForForgotVC : SendOTPForForgotVC? = nil
    
    func SendOTPForForgotPassword(ReqModel:ForgotPasswordReqModel){
       
        Utilities.ShowLoaderButtonInButton(Button: sendOTPForForgotVC?.BtnSendOTP ?? themeButton(), vc: sendOTPForForgotVC ?? UIViewController())
        WebServiceSubClass.ForgotPasswordOTP(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.sendOTPForForgotVC?.BtnSendOTP ?? themeButton(), vc: self.sendOTPForForgotVC ?? UIViewController())
            if status {
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
                controller.EnteredText = "Enter an otp send to \n\(ReqModel.phone ?? "")"
                controller.OtpString = "\(response?.data?.oTP ?? 0)"
                controller.ResendDetails = [KeyOfResend.IsFrom.rawValue:OTPFor.phoneNumber.rawValue,KeyOfResend.ReqModel.rawValue:ReqModel]
                controller.ClosourVerify = {
                    controller.dismiss(animated: true, completion: nil)
                    let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SetNewPasswordViewController.storyboardID) as! SetNewPasswordViewController
                    controller.isFromForgot = true
                    controller.PhoneNumber = ReqModel.phone ?? ""
                    self.sendOTPForForgotVC?.navigationController?.pushViewController(controller, animated: true)
                }
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                self.sendOTPForForgotVC?.present(controller, animated: true, completion: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}



