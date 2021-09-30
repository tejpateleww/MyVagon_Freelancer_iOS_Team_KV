//
//  EnterOTPViewModel.swift
//  MyVagon
//
//  Created by Apple on 10/08/21.
//

import Foundation

class EnterOTPViewModel {
    weak var enterOTPViewController : EnterOTPViewController? = nil
    
    func ResendOTPForEmail(ReqModel:EmailVerifyReqModel){
        Utilities.showHud()
        WebServiceSubClass.VerifyEmail(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                self.enterOTPViewController?.OtpString = "\(response?.data?.oTP ?? 0)"
                self.enterOTPViewController?.TextFieldOTP.text = ""
                self.enterOTPViewController?.StartTimer()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func ResendOTPForPhoneNumber(ReqModel:MobileVerifyReqModel){
        Utilities.showHud()
        WebServiceSubClass.VerifyPhone(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                self.enterOTPViewController?.OtpString = "\(response?.data?.oTP ?? 0)"
                self.enterOTPViewController?.TextFieldOTP.text = ""
                self.enterOTPViewController?.StartTimer()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
