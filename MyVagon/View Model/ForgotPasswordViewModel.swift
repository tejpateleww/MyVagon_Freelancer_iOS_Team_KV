//
//  ForgotPasswordViewModel.swift
//  MyVagon
//
//  Created by Apple on 12/08/21.
//

import Foundation
import UIKit
class ForgotPasswordViewModel {
    weak var VC : ForgotPasswordVC? = nil
    
    func SendOTPForForgotPassword(ReqModel:ForgotPasswordReqModel){
        VC?.btnSendOTP.showLoading()
        WebServiceSubClass.ForgotPasswordOTP(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnSendOTP.hideLoading()
            if status {
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
                controller.EnteredText = "\("Enter an otp send to".localized) \n\(ReqModel.phone ?? "")"
                controller.OtpString = "\(response?.data?.oTP ?? 0)"
                controller.ResendDetails = [KeyOfResend.IsFrom.rawValue:OTPFor.phoneNumber.rawValue,KeyOfResend.ReqModel.rawValue:ReqModel]
                controller.ClosourVerify = {
                    controller.dismiss(animated: true, completion: nil)
                    let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: ChangePasswordVC.storyboardID) as! ChangePasswordVC
                    controller.isFromForgot = true
                    controller.phoneNumber = ReqModel.phone ?? ""
                    self.VC?.navigationController?.pushViewController(controller, animated: true)
                }
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                self.VC?.present(controller, animated: true, completion: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}



