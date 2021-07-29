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

        TextFieldEmail.placeholder = "Email or Phone#".Localized()
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
        appDel.NavigateToHome()
//        Utilities.ShowAlert(OfMessage: "Login successful")
//        let CheckValidation = Validate()
//        if CheckValidation.0 {
//            Utilities.ShowAlert(OfMessage: "Login successful")
//        } else {
//            Utilities.ShowAlert(OfMessage: CheckValidation.1)
//        }
//
        
    }
    @IBAction func BtnJoinForFreeAction(_ sender: themeButton) {
        appDel.NavigateToRegister()
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
