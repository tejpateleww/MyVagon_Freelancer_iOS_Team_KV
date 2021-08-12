//
//  SetNewPasswordViewController.swift
//  MyVagon
//
//  Created by Apple on 30/07/21.
//

import UIKit

class SetNewPasswordViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var customTabBarController: CustomTabBarVC?
    var isFromForgot : Bool = false
    var resetPasswordViewModel = ResetPasswordViewModel()
    var PhoneNumber = ""
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var ViewCurrentPassword: UIView!
    @IBOutlet weak var BtnSetPassword: themeButton!
    @IBOutlet weak var TextFieldCurrentPassword: themeTextfield!
    @IBOutlet weak var TextFieldNewPassword: themeTextfield!
    @IBOutlet weak var TextFieldConfirmPassword: themeTextfield!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        if isFromForgot {
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Set new password", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        } else {
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Change Password", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        }
        
        
        if isFromForgot {
            ViewCurrentPassword.isHidden = true
            BtnSetPassword.setTitle("Set New Password", for: .normal)
        } else {
            ViewCurrentPassword.isHidden = false
            BtnSetPassword.setTitle("Reset New Password", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnSetNewPassword(_ sender: themeButton) {
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
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func CallWebservice() {
        self.resetPasswordViewModel.setNewPasswordViewController =  self
        
        let ReqModelForResetPassword = ResetNewPasswordReqModel()
        ReqModelForResetPassword.phone = PhoneNumber
        ReqModelForResetPassword.password = TextFieldNewPassword.text ?? ""
        
        self.resetPasswordViewModel.ResetNewPassword(ReqModel: ReqModelForResetPassword)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validations ---------
    // ----------------------------------------------------
    
    func Validate() -> (Bool,String) {
        
        let checkPassword = TextFieldNewPassword.validatedText(validationType: ValidatorType.password(field: "new password"))
        let checkConfirmPassword = TextFieldConfirmPassword.validatedText(validationType: ValidatorType.password(field: "confirm new password"))
        
        if(!checkPassword.0){
            return (checkPassword.0,checkPassword.1)
        }else if(!checkConfirmPassword.0){
            return (checkConfirmPassword.0,checkConfirmPassword.1)
        }else if TextFieldNewPassword.text != TextFieldConfirmPassword.text{
            return (false,"Password and confirm password does not match")
        }
        return (true,"")
    }
}
