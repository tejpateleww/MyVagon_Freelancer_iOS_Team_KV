//
//  SendOTPForForgotVC.swift
//  MyVagon
//
//  Created by Apple on 30/07/21.
//

import UIKit

class ForgotPasswordVC: BaseViewController {

    //MARK: - Propartes
    @IBOutlet weak var txtPhone: themeTextfield!
    @IBOutlet weak var btnSendOTP: themeButton!
    @IBOutlet weak var lblTitleForgotPass: themeLabel!
    @IBOutlet weak var lblTitleDesc: themeLabel!
    
    var forgotPasswordViewModel = ForgotPasswordViewModel()

    //MARK: - Life cycle Method
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
    }
    
    //MARK: - IBAction Method
    @IBAction func btnSendOTPAction(_ sender: themeButton) {
        let CheckValidation = validate()
        if CheckValidation.0 {
            callWebservice()
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
    
    //MARK: - Custom method
    func setLocalization() {
        btnSendOTP.setTitle("SendOTP".localized, for: .normal)
        txtPhone.placeholder = "MobileNumber".localized
        lblTitleForgotPass.text = "ForgotPassword".localized
        lblTitleDesc.text = "ForgotPasswordDesc".localized
    }

    func validate() -> (Bool,String) {
        self.txtPhone.text = txtPhone.text?.trimmedString
        let checkEmail = self.txtPhone.validatedText(validationType: ValidatorType.requiredField(field: "MobileNumber".localized))
        if (!checkEmail.0){
            return checkEmail
        }
        return (true,"")
    }
}

//MARK: - API call
extension ForgotPasswordVC {
    func callWebservice() {
        self.forgotPasswordViewModel.VC = self
        let ReqModelForForgotPassword = ForgotPasswordReqModel()
        ReqModelForForgotPassword.phone = txtPhone.text ?? ""
        self.forgotPasswordViewModel.SendOTPForForgotPassword(ReqModel: ReqModelForForgotPassword)
    }
}

//MARK: - TextField Delegate
extension ForgotPasswordVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone{
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 50, range: range, string: string)
            return CheckWritting
        }
        return true
    }
}
