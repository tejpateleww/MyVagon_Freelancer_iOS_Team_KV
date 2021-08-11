//
//  EnterOTPViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit
//MARK:- ========= Enum Tab Type ======
enum KeyOfResend: String {
   case IsFrom
    case ReqModel
    
}
enum OTPFor: String {
   case email
    case phoneNumber
    
}
class EnterOTPViewController: BaseViewController,UITextFieldDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var ResendDetails : [String:Any] = [:]
    
    var enterOTPViewModel = EnterOTPViewModel()
    var EnteredText = ""
    var OtpString = "111111"
    var ClosourVerify : (() -> ())?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var LblEnterText: themeLabel!
    @IBOutlet weak var btnOTP: themeButton!
    @IBOutlet weak var BtnVerify: themeButton!
    @IBOutlet weak var TextFieldOTP: themeTextfield!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LblEnterText.text = EnteredText
        TextFieldOTP.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        StartTimer()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
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
                    UIView.performWithoutAnimation {
                        //self.btnOTP.setTitle("Resend after \(secondsRemaining) seconds", for: .normal)
                        self.btnOTP.setWithOutunderline(title: "Resend after \(secondsRemaining) seconds", color: UIColor.black, font: CustomFont.PoppinsMedium.returnFont(16))
                        secondsRemaining -= 1
                        self.btnOTP.layoutIfNeeded()
                    }
                
                } else if secondsRemaining == 1 {
                    UIView.performWithoutAnimation {
                       // self.btnOTP.setTitle("Resend after \(secondsRemaining) second", for: .normal)
                    self.btnOTP.setWithOutunderline(title: "Resend after \(secondsRemaining) second", color: UIColor.black, font: CustomFont.PoppinsMedium.returnFont(16))
                        secondsRemaining -= 1
                        self.btnOTP.layoutIfNeeded()
                    }
                } else {
                    UIView.performWithoutAnimation {
                        
                    self.btnOTP.setunderline(title: "Resend OTP", color: UIColor.black, font: CustomFont.PoppinsMedium.returnFont(16))
                        self.btnOTP.isEnabled = true
                        Timer.invalidate()
                    }
                    
                }
            }
        }
    }
    func Validate() -> (Bool,String){
        if TextFieldOTP.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return (false,"Please enter OTP")
        } else {
            if OtpString != TextFieldOTP.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""{
                return (false,ErrorMessages.Invelid_Otp.rawValue)
               
               
            }
        }
        return (true,"")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
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
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}

extension UITextField {
    func StopWrittingAtCharactorLimit(CharLimit:Int,range:NSRange,string:String) -> Bool {
      

           let startingLength = self.text?.count ?? 0
           let lengthToAdd = string.count
           let lengthToReplace =  range.length
           let newLength = startingLength + lengthToAdd - lengthToReplace

           return newLength <= CharLimit
    }
}
