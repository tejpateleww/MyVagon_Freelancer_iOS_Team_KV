//
//  EnterOTPViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit

class EnterOTPViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
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
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
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
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
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
