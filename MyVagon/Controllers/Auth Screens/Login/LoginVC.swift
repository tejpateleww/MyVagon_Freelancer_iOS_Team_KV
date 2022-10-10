//
//  LoginVC.swift
//  MyVagon
//
//  Created by Tej P on 07/06/22.
//

import UIKit

class LoginVC: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var txtEmail: themeTextfield!
    @IBOutlet weak var txtPassword: themeTextfield!
    @IBOutlet weak var btnSignIn: themeButton!
    @IBOutlet weak var btnJoinInForFree: themeButton!
    @IBOutlet weak var btnForgot: UIButton!

    var loginViewModel = LoginViewModel()
    let ACCEPTABLE_CHARACTERS_FOR_EMAIL = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@."
    let ACCEPTABLE_CHARACTERS_FOR_PHONE = "0123456789"
    let RISTRICTED_CHARACTERS_FOR_PASSWORD = " "
    
    // MARK: - Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    // MARK: - Custome methods
    private func prepareView() {
        self.setupUI()
        self.setupData()
    }
    
    private func setupUI() {
        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [], isTranslucent: true, setSegment: true)
        self.setLocalization()
    }
    
    private func setupData() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    private func setLocalization() {
        self.btnSignIn.setTitle("Sign In".localized, for: .normal)
        self.btnJoinInForFree.setTitle("Join For Free!".localized, for: .normal)
        self.btnForgot.setTitle("Forgot?".localized, for: .normal)
        self.txtEmail.placeholder = "Email or Phone number".localized
        self.txtPassword.placeholder = "Password".localized
    }
    
    private func selectedBtnUIChanges(isSelected: Bool, btn: UIButton) {
        btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        btn.setTitleColor(isSelected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText).withAlphaComponent(0.4), for: .normal)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func Validate() -> (Bool,String) {
        self.txtEmail.text = txtEmail.text?.trimmedString
        let checkEmail = self.txtEmail.validatedText(validationType: ValidatorType.requiredField(field: "email or phone number".localized))
        let checkPassword = self.txtPassword.validatedText(validationType: ValidatorType.password(field: "password".localized))
        if (!checkEmail.0){
            return (checkEmail.0,checkEmail.1)
        }else if(!checkPassword.0){
            return (checkPassword.0,checkPassword.1)
        }
        return (true,"")
    }
    
    //MARK: - IBAction method
    @IBAction func btnSignInAction(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            callLoginAPI()
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
    
    @IBAction func btnJoinForFreeAction(_ sender: themeButton) {
        UserDefault.getRegisterData()
        appDel.NavigateToRegister()
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: UIButton) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: ForgotPasswordVC.storyboardID) as! ForgotPasswordVC
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - API call methods
extension LoginVC {
    func callLoginAPI() {
        self.loginViewModel.VC = self
        let ReqModelForLogin = LoginReqModel()
        ReqModelForLogin.app_version = SingletonClass.sharedInstance.AppVersion
        ReqModelForLogin.device_name = SingletonClass.sharedInstance.DeviceName
        ReqModelForLogin.device_type = SingletonClass.sharedInstance.DeviceType
        ReqModelForLogin.device_token = SingletonClass.sharedInstance.DeviceToken
        ReqModelForLogin.email = self.txtEmail.text ?? ""
        ReqModelForLogin.password = self.txtPassword.text ?? ""
        self.loginViewModel.Login(ReqModel: ReqModelForLogin)
    }
}

// MARK: - UITextFieldDelegate methods
extension LoginVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.txtEmail:
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 50, range: range, string: string)
            return CheckWritting
        case self.txtPassword :
            let set = CharacterSet(charactersIn: RISTRICTED_CHARACTERS_FOR_PASSWORD)
            let inverted = set.inverted
            let filtered = string.components(separatedBy: inverted).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            return (string != filtered) ? (newString.length <= 25) : (isBackSpace == -92) ? true : false
        default:
            print("")
        }
        return true
    }
}
