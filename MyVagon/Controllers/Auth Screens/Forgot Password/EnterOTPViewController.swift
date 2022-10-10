//
//  EnterOTPViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit

class EnterOTPViewController: BaseViewController,UITextFieldDelegate {

    //MARK: - Propertise
    @IBOutlet weak var LblEnterText: themeLabel!
    @IBOutlet weak var btnOTP: themeButton!
    @IBOutlet weak var BtnVerify: themeButton!
    @IBOutlet weak var TextFieldOTP: themeTextfield!
    
    var ResendDetails : [String:Any] = [:]
    var enterOTPViewModel = EnterOTPViewModel()
    var EnteredText = ""
    var OtpString = "111111"
    var ClosourVerify : (() -> ())?

    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LblEnterText.text = EnteredText
        TextFieldOTP.delegate = self
        btnOTP.titleLabel?.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StartTimer()
        setLocalization()
    }

    // MARK: - Custom methods
    func setLocalization() {
        self.BtnVerify.setTitle("Verify".localized, for: .normal)
        self.TextFieldOTP.placeholder = "Enter6digitOTP".localized
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         textField.StopWrittingAtCharactorLimit(CharLimit: OtpString.count, range: range, string: string)
    }
    
    func StartTimer() {
        if OtpString != "" {
            TextFieldOTP.becomeFirstResponder()
            var secondsRemaining = 30
            self.btnOTP.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if secondsRemaining > 1 {
                    let text = "Resend after".localized + " \(secondsRemaining) " + "seconds".localized
                    UIView.performWithoutAnimation {
                        self.btnOTP.setWithOutunderline(title: text, color: UIColor.black, font: CustomFont.PoppinsMedium.returnFont(16))
                        secondsRemaining -= 1
                        self.btnOTP.layoutIfNeeded()
                    }
                } else if secondsRemaining == 1 {
                    UIView.performWithoutAnimation {
                    let text = "Resend after".localized + " \(secondsRemaining) " + "second".localized
                    self.btnOTP.setWithOutunderline(title: text, color: UIColor.black, font: CustomFont.PoppinsMedium.returnFont(16))
                        secondsRemaining -= 1
                        self.btnOTP.layoutIfNeeded()
                    }
                } else {
                    UIView.performWithoutAnimation {
                        self.btnOTP.setunderline(title: "Resend OTP".localized, color: UIColor.black, font: CustomFont.PoppinsMedium.returnFont(16))
                        self.btnOTP.isEnabled = true
                        Timer.invalidate()
                    }
                }
            }
        }
    }
    
    func Validate() -> (Bool,String){
        if TextFieldOTP.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return (false,"Please enter OTP".localized)
        } else {
            if OtpString != TextFieldOTP.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""{
                return (false,ErrorMessages.Invelid_Otp.rawValue.localized)
            }
        }
        return (true,"")
    }
    
    // MARK: - IBAction methods
    @IBAction func BtnClosePopupAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnResendOTP(_ sender: Any) {
        if ResendDetails[KeyOfResend.IsFrom.rawValue] as? String ?? "" == OTPFor.email.rawValue {
            let ReqModelResendEmail = ResendDetails[KeyOfResend.ReqModel.rawValue] as? EmailVerifyReqModel ?? EmailVerifyReqModel()
            self.enterOTPViewModel.enterOTPViewController = self
            self.enterOTPViewModel.ResendOTPForEmail(ReqModel: ReqModelResendEmail)
        } else if ResendDetails[KeyOfResend.IsFrom.rawValue] as? String ?? "" == OTPFor.phoneNumber.rawValue {
            let ReqModelResendPhoneNumber = ResendDetails[KeyOfResend.ReqModel.rawValue] as? MobileVerifyReqModel ?? MobileVerifyReqModel()
            self.enterOTPViewModel.enterOTPViewController = self
            self.enterOTPViewModel.ResendOTPForPhoneNumber(ReqModel: ReqModelResendPhoneNumber)
        }
    }
    
    @IBAction func BtnVerifyAction(_ sender: Any) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            if let click = self.ClosourVerify {
                click()
            }
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
}

