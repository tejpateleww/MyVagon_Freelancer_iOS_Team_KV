//
//  SetNewPasswordViewController.swift
//  MyVagon
//
//  Created by Apple on 30/07/21.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var viewCurrentPassword: UIView!
    @IBOutlet weak var btnSetPassword: themeButton!
    @IBOutlet weak var textFieldCurrentPassword: themeTextfield!
    @IBOutlet weak var textFieldNewPassword: themeTextfield!
    @IBOutlet weak var textFieldConfirmPassword: themeTextfield!
    
    var customTabBarController: CustomTabBarVC?
    var isFromForgot : Bool = false
    var resetPasswordViewModel = ResetPasswordViewModel()
    var phoneNumber = ""
    
    // MARK: - Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        self.setLocalization()
    }

    // MARK: - Custom Methods
    func setUpUI(){
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        if isFromForgot {
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Set new password".localized.localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
            viewCurrentPassword.isHidden = true
            btnSetPassword.setTitle("Set New Password".localized, for: .normal)
        } else {
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Change Password".localized.localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
            viewCurrentPassword.isHidden = false
            btnSetPassword.setTitle("Reset New Password".localized, for: .normal)
        }
        self.addObserver()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func setLocalization(){
        self.textFieldConfirmPassword.placeholder = "Confirm Password".localized
        self.textFieldNewPassword.placeholder = "New Password".localized
        self.textFieldCurrentPassword.placeholder = "Current Password".localized
    }
    
    func validate() -> (Bool,String) {
        if !isFromForgot {
            let CheckOldPassword = textFieldCurrentPassword.validatedText(validationType: ValidatorType.requiredField(field: "current password".localized))
            if(!CheckOldPassword.0){
                return (CheckOldPassword.0,CheckOldPassword.1)
            }
        }
        let checkPassword = textFieldNewPassword.validatedText(validationType: ValidatorType.password(field: "new password".localized))
        let checkConfirmPassword = textFieldConfirmPassword.validatedText(validationType: ValidatorType.requiredField(field: "confirm password".localized))
        if(!checkPassword.0){
            return (checkPassword.0,checkPassword.1)
        }else if(!checkConfirmPassword.0){
            return (checkConfirmPassword.0,checkConfirmPassword.1)
        }else if textFieldNewPassword.text != textFieldConfirmPassword.text{
            return (false,"Password and confirm password does not match".localized)
        }else if textFieldNewPassword.text == textFieldCurrentPassword.text{
            return (false,"Current password and new password must be different".localized)
        }
        return (true,"")
    }
    
    // MARK: - IBAction Methods
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    @IBAction func btnSetNewPassword(_ sender: themeButton) {
        let CheckValidation = validate()
        if CheckValidation.0 {
            callWebservice()
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
}

//MARK: - WebService method
extension ChangePasswordVC{
    func callWebservice() {
        if isFromForgot {
            self.resetPasswordViewModel.setNewPasswordViewController =  self
            let ReqModelForResetPassword = ResetNewPasswordReqModel()
            ReqModelForResetPassword.phone = phoneNumber
            ReqModelForResetPassword.password = textFieldNewPassword.text ?? ""
            self.resetPasswordViewModel.ResetNewPassword(ReqModel: ReqModelForResetPassword)
        } else {
            self.resetPasswordViewModel.setNewPasswordViewController =  self
            let ReqModelForChangePassword = ChangePasswordReqModel()
            ReqModelForChangePassword.user_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
            ReqModelForChangePassword.old_password = textFieldCurrentPassword.text ?? ""
            ReqModelForChangePassword.new_password = textFieldNewPassword.text ?? ""
            self.resetPasswordViewModel.Changepassword(ReqModel: ReqModelForChangePassword)
        }
    }
}
