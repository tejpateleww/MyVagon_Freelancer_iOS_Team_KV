//
//  SendOTPForForgotVC.swift
//  MyVagon
//
//  Created by Apple on 30/07/21.
//

import UIKit

class SendOTPForForgotVC: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var forgotPasswordViewModel = ForgotPasswordViewModel()
    
   
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var TextFieldPhone: themeTextfield!
    
    @IBOutlet weak var BtnSendOTP: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
//        DispatchQueue.main.async {
//            self.TextFieldEmail.becomeFirstResponder()
//        }
        
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func BtnSendOTPAction(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            CallWebservice()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func CallWebservice() {
        self.forgotPasswordViewModel.sendOTPForForgotVC = self
        
        let ReqModelForForgotPassword = ForgotPasswordReqModel()
        ReqModelForForgotPassword.phone = TextFieldPhone.text ?? ""
        
        self.forgotPasswordViewModel.SendOTPForForgotPassword(ReqModel: ReqModelForForgotPassword)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validations ---------
    // ----------------------------------------------------
    
    func Validate() -> (Bool,String) {
        
        let checkMobileNumber = TextFieldPhone.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 15))
      
        
        if (!checkMobileNumber.0){
            return (checkMobileNumber.0,checkMobileNumber.1)
        } 
        return (true,"")
    }

}
