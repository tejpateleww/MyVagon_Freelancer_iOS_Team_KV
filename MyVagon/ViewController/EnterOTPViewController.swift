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
    var strOtp = "111111"
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
        if strOtp != "" {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnClosePopupAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func BtnVerifyAction(_ sender: Any) {
        if let click = self.ClosourVerify {
            click()
        }
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
