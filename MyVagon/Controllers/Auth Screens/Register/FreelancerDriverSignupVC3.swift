//
//  FreelancerDriverSignupVC3.swift
//  MyVagon
//
//  Created by Admin on 26/07/21.
//

import UIKit

class FreelancerDriverSignupVC3: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var TextFieldFullName: themeTextfield!
    @IBOutlet weak var TextFieldCountryCode: themeTextfield!
    @IBOutlet weak var TextFieldMobileNumber: themeTextfield!
    @IBOutlet weak var TextFieldEmail: themeTextfield!
    @IBOutlet weak var TextFieldPassword: themeTextfield!
    @IBOutlet weak var TextFieldConfirmPassword: themeTextfield!
    @IBOutlet weak var BtnVerifyEmail: ThemeButtonVerify!
    @IBOutlet weak var BtnVerifyPhoneNumber: ThemeButtonVerify!
    @IBOutlet weak var btnJoin: themeButton!
    @IBOutlet weak var btnSignIn: themeButton!
    
    var signUpViewModel = SignUpViewModel()
    var CountryCodeArray: [String] = ["+30"]
    let GeneralPicker = GeneralPickerView()
    var IsPhoneVerify : Bool = false
    var IsEmailVerify : Bool = false
    var VerifiedEmail = ""
    var verifiedPhone = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BtnVerifyPhoneNumber.titleLabel?.numberOfLines = 0
        self.BtnVerifyEmail.titleLabel?.numberOfLines = 0
        self.TextFieldFullName.delegate = self
        self.TextFieldPassword.delegate = self
        self.TextFieldConfirmPassword.delegate = self
        self.TextFieldCountryCode.delegate = self
        self.TextFieldEmail.delegate = self
        self.TextFieldMobileNumber.delegate = self
        self.setupDelegateForPickerView()
        self.setValue()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    //MARK: - Custom Methods
    func setLocalization() {
        self.TextFieldFullName.placeholder = "FullName".localized
        self.TextFieldMobileNumber.placeholder = "Phone".localized
        self.TextFieldEmail.placeholder = "Email".localized
        self.TextFieldPassword.placeholder = "Password".localized
        self.TextFieldConfirmPassword.placeholder = "ConfirmPassword".localized
        self.btnJoin.setTitle("JoinForFree!".localized, for: .normal)
        self.btnSignIn.setTitle("Sign In".localized, for: .normal)
        self.BtnVerifyPhoneNumber.setImage(UIImage(named: "Verified"), for: .selected)
        self.BtnVerifyPhoneNumber.setImage(UIImage(named: "Verify"), for: .normal)
        self.BtnVerifyEmail.setImage(UIImage(named: "Verified"), for: .selected)
        self.BtnVerifyEmail.setImage(UIImage(named: "Verify"), for: .normal)
    }
    
    func setValue() {
        self.TextFieldFullName.text = SingletonClass.sharedInstance.RegisterData.Reg_fullname
        self.TextFieldMobileNumber.text = SingletonClass.sharedInstance.RegisterData.Reg_mobile_number
        self.TextFieldEmail.text = SingletonClass.sharedInstance.RegisterData.Reg_email
        self.TextFieldPassword.text = SingletonClass.sharedInstance.RegisterData.Reg_password
        self.TextFieldConfirmPassword.text = SingletonClass.sharedInstance.RegisterData.Reg_password
        if SingletonClass.sharedInstance.RegisterData.Reg_mobile_number != "" {
            self.BtnVerifyPhoneNumber.isSelected = true
            self.verifiedPhone = SingletonClass.sharedInstance.RegisterData.Reg_mobile_number
        }
        if SingletonClass.sharedInstance.RegisterData.Reg_email != "" {
            self.BtnVerifyEmail.isSelected = true
            self.VerifiedEmail = SingletonClass.sharedInstance.RegisterData.Reg_email
        }
        if SingletonClass.sharedInstance.RegisterData.Reg_country_code != "" {
            self.TextFieldCountryCode.text = SingletonClass.sharedInstance.RegisterData.Reg_country_code
        } else {
            self.TextFieldCountryCode.text = self.CountryCodeArray.first
        }
    }
    
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        GeneralPicker.generalPickerDelegate = self
    }
    
    func phoneVerify() {
        self.signUpViewModel.freelancerDriverSignupVC3 = self
        let ReqModelForMobileVerify = MobileVerifyReqModel()
        ReqModelForMobileVerify.mobile_number = "\(TextFieldCountryCode.text ?? "")\(TextFieldMobileNumber.text ?? "")"
        self.signUpViewModel.VerifyPhone(ReqModel: ReqModelForMobileVerify)
    }
    
    func emailVerify() {
        self.signUpViewModel.freelancerDriverSignupVC3 = self
        let ReqModelForEmailVerify = EmailVerifyReqModel()
        ReqModelForEmailVerify.email = TextFieldEmail.text ?? ""
        self.signUpViewModel.VerifyEmail(ReqModel: ReqModelForEmailVerify)
    }
    
    func validate() -> (Bool,String) {
        self.TextFieldFullName.text = TextFieldFullName.text?.trimmedString
        self.TextFieldMobileNumber.text = self.TextFieldMobileNumber.text?.trimmedString
        self.TextFieldEmail.text = self.TextFieldEmail.text?.trimmedString
        self.TextFieldPassword.text = self.TextFieldPassword.text?.trimmedString
        self.TextFieldConfirmPassword.text = self.TextFieldConfirmPassword.text?.trimmedString
        let checkFullName = TextFieldFullName.validatedText(validationType: ValidatorType.username(field: "full name".localized,MaxChar: 70))
        let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 15))
        let checkEmail = TextFieldEmail.validatedText(validationType: ValidatorType.email)
        let checkPassword = TextFieldPassword.validatedText(validationType: ValidatorType.password(field: "password"))
        let checkConfirmPassword = TextFieldConfirmPassword.validatedText(validationType: ValidatorType.requiredField(field: "confirm password"))
        if (!checkFullName.0){
            return (checkFullName.0,checkFullName.1)
        } else if (!checkMobileNumber.0){
            return (checkMobileNumber.0,checkMobileNumber.1)
        } else if (!checkEmail.0){
            return (checkEmail.0,checkEmail.1)
        }else if(!checkPassword.0){
            return (checkPassword.0,checkPassword.1)
        }else if(!checkConfirmPassword.0){
            return (checkConfirmPassword.0,"Error_EnterConfirmPass".localized)
        }else if TextFieldPassword.text != TextFieldConfirmPassword.text{
            return (false,"Error_PassMatch".localized)
        } else if !BtnVerifyPhoneNumber.isSelected {
            return (false,"Error_VerifyMobile".localized)
        } else if !BtnVerifyEmail.isSelected {
            return (false,"Error_VerifyEmail".localized)
        }
        return (true,"")
    }
    
    //MARK: - IBAction Methods
    @IBAction func btnActionEmailVerify(_ sender: UIButton) {
        if sender.isSelected == false {
            let checkEmail = TextFieldEmail.validatedText(validationType: ValidatorType.email)
            if (!checkEmail.0){
                Utilities.ShowAlertOfInfo(OfMessage: checkEmail.1)
            } else {
                emailVerify()
            }
        }
    }
    
    @IBAction func btnActionMobileVerify(_ sender: UIButton) {
        if sender.isSelected == false {
            let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 10))
            if (!checkMobileNumber.0){
                Utilities.ShowAlertOfInfo(OfMessage: checkMobileNumber.1)
            } else {
                phoneVerify()
            }
        }
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        appDel.NavigateToLogin()
    }
    
    @IBAction func btnJoinForFreeAction(_ sender: Any) {
        let CheckValidation = validate()
        if CheckValidation.0 {
            SingletonClass.sharedInstance.RegisterData.Reg_fullname = TextFieldFullName.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_country_code = TextFieldCountryCode.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_mobile_number = TextFieldMobileNumber.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_email = TextFieldEmail.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_password = TextFieldPassword.text ?? ""
            UserDefault.SetRegiterData()
            UserDefault.setValue(0, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.setUserData()
            UserDefault.synchronize()
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 1
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            RegisterMainVC.viewDidLayoutSubviews()
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
}

//MARK: - UITextFieldDelegate Methods
extension FreelancerDriverSignupVC3: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            if textField == TextFieldEmail {
                if textField.text == VerifiedEmail {
                    BtnVerifyEmail.isSelected = true
                } else {
                    BtnVerifyEmail.isSelected = false
                }
            } else if textField == TextFieldMobileNumber {
                if textField.text == verifiedPhone {
                    BtnVerifyPhoneNumber.isSelected = true
                } else {
                    BtnVerifyPhoneNumber.isSelected = false
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TextFieldCountryCode {
            TextFieldCountryCode.inputView = GeneralPicker
            TextFieldCountryCode.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = CountryCodeArray.first(where: {$0 == TextFieldCountryCode.text ?? ""}) {
                let indexOfA = CountryCodeArray.firstIndex(of: DummyFirst) ?? 0
                GeneralPicker.selectRow(indexOfA, inComponent: 0, animated: false)
                self.GeneralPicker.reloadAllComponents()
            }
        }
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
        } else if textField == TextFieldConfirmPassword {
            if textField.text == "" {
                if (string == " ") {
                    return false
                }
                return true
            } else {
                return true
            }
        } else if textField == TextFieldMobileNumber {
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 10, range: range, string: string)
            return CheckWritting
        }  else if textField == TextFieldPassword {
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 20, range: range, string: string)
            return CheckWritting
        } else if textField == TextFieldConfirmPassword {
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 20, range: range, string: string)
            return CheckWritting
        }else if textField == TextFieldFullName{
            if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
                return false
            } else {
                return true
            }
        }else if textField == TextFieldEmail{
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 256, range: range, string: string)
            return CheckWritting
        }
        return true
    }
}

//MARK: - GeneralPickerViewDelegate Methods
extension FreelancerDriverSignupVC3: GeneralPickerViewDelegate {
    
    func didTapDone() {
        let item = CountryCodeArray[GeneralPicker.selectedRow(inComponent: 0)]
        self.TextFieldCountryCode.text = item
        self.TextFieldCountryCode.resignFirstResponder()
    }
    
    func didTapCancel() {}
}

//MARK: - UIPickerViewDelegate Methods
extension FreelancerDriverSignupVC3 : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryCodeArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountryCodeArray[row]
    }
}
