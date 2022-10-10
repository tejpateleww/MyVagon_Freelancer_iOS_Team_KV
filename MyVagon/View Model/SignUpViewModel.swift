//
//  SignUpViewModel.swift
//  MyVagon
//
//  Created by Apple on 09/08/21.
//

import Foundation
class SignUpViewModel {
    weak var freelancerDriverSignupVC3 : FreelancerDriverSignupVC3? = nil
    
    func VerifyEmail(ReqModel:EmailVerifyReqModel){
        Utilities.showHud()
        WebServiceSubClass.VerifyEmail(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
                controller.EnteredText = "\("Enter an otp send to".localized) \n\(ReqModel.email ?? "")"
                controller.OtpString = "\(response?.data?.oTP ?? 0)"
                controller.ResendDetails = [KeyOfResend.IsFrom.rawValue:OTPFor.email.rawValue,KeyOfResend.ReqModel.rawValue:ReqModel]
                controller.ClosourVerify = {
                    self.freelancerDriverSignupVC3?.IsEmailVerify = true
                    self.freelancerDriverSignupVC3?.VerifiedEmail = self.freelancerDriverSignupVC3?.TextFieldEmail.text ?? ""
                    controller.dismiss(animated: true, completion: nil)
                    self.freelancerDriverSignupVC3?.BtnVerifyEmail.isSelected = true
                }
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                self.freelancerDriverSignupVC3?.present(controller, animated: true, completion: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func VerifyPhone(ReqModel:MobileVerifyReqModel){
        Utilities.showHud()
//        appDel.NavigateToHome()
        WebServiceSubClass.VerifyPhone(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
                controller.EnteredText = "\("Enter an otp send to".localized) \n\(ReqModel.mobile_number ?? "")"
                controller.OtpString = "\(response?.data?.oTP ?? 0)"
                controller.ResendDetails = [KeyOfResend.IsFrom.rawValue:OTPFor.phoneNumber.rawValue,KeyOfResend.ReqModel.rawValue:ReqModel]
                controller.ClosourVerify = {
                    self.freelancerDriverSignupVC3?.IsPhoneVerify = true
                    self.freelancerDriverSignupVC3?.verifiedPhone = self.freelancerDriverSignupVC3?.TextFieldMobileNumber.text ?? ""

                    controller.dismiss(animated: true, completion: nil)
                    self.freelancerDriverSignupVC3?.BtnVerifyPhoneNumber.isSelected = true
                }
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                self.freelancerDriverSignupVC3?.present(controller, animated: true, completion: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

class EditPersonViewModel {
    weak var editPersonalInfoVC : EditPersonalInfoVC? = nil
    
    
    func VerifyPhone(ReqModel:MobileVerifyReqModel){
        Utilities.showHud()
//        appDel.NavigateToHome()
        WebServiceSubClass.VerifyPhone(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Utilities.ShowToastMessage(OfMessage: apiMessage)
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
                controller.EnteredText = "\("Enter an otp send to".localized) \n\(ReqModel.mobile_number ?? "")"
                controller.OtpString = "\(response?.data?.oTP ?? 0)"
                controller.ResendDetails = [KeyOfResend.IsFrom.rawValue:OTPFor.phoneNumber.rawValue,KeyOfResend.ReqModel.rawValue:ReqModel]
                controller.ClosourVerify = {
                    self.editPersonalInfoVC?.IsPhoneVerify = true
                    self.editPersonalInfoVC?.verifiedPhone = self.editPersonalInfoVC?.TextFieldMobileNumber.text ?? ""

                    controller.dismiss(animated: true, completion: nil)
                    self.editPersonalInfoVC?.btnVarifyNumber.isSelected = true
                }
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                self.editPersonalInfoVC?.present(controller, animated: true, completion: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

