//
//  SignInDriverVC.swift
//  MyVagon
//
//  Created by Admin on 26/07/21.
//

import UIKit

class SignInDriverVC: UIViewController,UITextFieldDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldEmail: themeTextfield!
    @IBOutlet weak var TextFieldPassword: themeTextfield!
    
    @IBOutlet weak var BtnSignIn: themeButton!
    @IBOutlet weak var BtnJoinInForFree: themeButton!
    @IBOutlet weak var BtnForgot: UIButton!
    
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextFieldEmail.text = "ankur@yopmail.com"
        TextFieldPassword.text = "12345678"
        TextFieldPassword.delegate = self
        SetLocalization()
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetLocalization() {
//        BtnSignIn.setTitle("Sign In", for: .normal)
//        BtnJoinInForFree.setTitle("Join For Free!", for: .normal)
//        BtnForgot.setTitle("Forgot?", for: .normal)
//
//        TextFieldEmail.placeholder = "Email or Phone#"
//        TextFieldPassword.placeholder = "Password"
        
        BtnSignIn.setTitle("Sign In".Localized(), for: .normal)
        BtnJoinInForFree.setTitle("Join For Free!".Localized(), for: .normal)
        BtnForgot.setTitle("Forgot?".Localized(), for: .normal)

        TextFieldEmail.placeholder = "Email or Phone number".Localized()
        TextFieldPassword.placeholder = "Password".Localized()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == TextFieldPassword {
            if textField.text == "" {
                if (string == " ") {
                    return false
                }
                return true
            } else {
                return true
            }
        }
        return true
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnSignInAction(_ sender: themeButton) {
        
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            appDel.NavigateToHome()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
//
        
    }
    @IBAction func BtnJoinForFreeAction(_ sender: themeButton) {
        appDel.NavigateToRegister()
    }
    
    @IBAction func BtnForgotPasswordClick(_ sender: UIButton) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SendOTPForForgotVC.storyboardID) as! SendOTPForForgotVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validations ---------
    // ----------------------------------------------------
    
    func Validate() -> (Bool,String) {
        
        let checkEmail = TextFieldEmail.validatedText(validationType: ValidatorType.email)
        let checkPassword = TextFieldPassword.validatedText(validationType: ValidatorType.password(field: "password"))
        
        if (!checkEmail.0){
           
            return (checkEmail.0,checkEmail.1)
        }else if(!checkPassword.0)
        {
            return (checkPassword.0,checkPassword.1)
        }
        return (true,"")
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
