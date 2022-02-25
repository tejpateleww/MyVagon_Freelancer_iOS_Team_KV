//
//  FreelancerDriverSignupVC3.swift
//  MyVagon
//
//  Created by Admin on 26/07/21.
//

import UIKit

class FreelancerDriverSignupVC3: UIViewController, UITextFieldDelegate {

   
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var signUpViewModel = SignUpViewModel()
    var CountryCodeArray: [String] = ["+30"]
    let GeneralPicker = GeneralPickerView()
    
    var IsPhoneVerify : Bool = false
    var IsEmailVerify : Bool = false
    
    var VerifiedEmail = ""
    var verifiedPhone = ""
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldFullName: themeTextfield!
    @IBOutlet weak var TextFieldCountryCode: themeTextfield!
    @IBOutlet weak var TextFieldMobileNumber: themeTextfield!
    @IBOutlet weak var TextFieldEmail: themeTextfield!
    @IBOutlet weak var TextFieldPassword: themeTextfield!
    @IBOutlet weak var TextFieldConfirmPassword: themeTextfield!
    @IBOutlet weak var BtnVerifyEmail: ThemeButtonVerify!
    @IBOutlet weak var BtnVerifyPhoneNumber: ThemeButtonVerify!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextFieldPassword.delegate = self
        TextFieldConfirmPassword.delegate = self
        TextFieldCountryCode.delegate = self
        setupDelegateForPickerView()
        
        setValue()
        
        TextFieldEmail.delegate = self
        TextFieldMobileNumber.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setValue() {
        
        TextFieldFullName.text = SingletonClass.sharedInstance.RegisterData.Reg_fullname
        
        TextFieldMobileNumber.text = SingletonClass.sharedInstance.RegisterData.Reg_mobile_number
        TextFieldEmail.text = SingletonClass.sharedInstance.RegisterData.Reg_email
        TextFieldPassword.text = SingletonClass.sharedInstance.RegisterData.Reg_password
        TextFieldConfirmPassword.text = SingletonClass.sharedInstance.RegisterData.Reg_password
        
        if SingletonClass.sharedInstance.RegisterData.Reg_mobile_number != "" {
            BtnVerifyPhoneNumber.isSelected = true
            verifiedPhone = SingletonClass.sharedInstance.RegisterData.Reg_mobile_number
            
        }
        if SingletonClass.sharedInstance.RegisterData.Reg_email != "" {
            BtnVerifyEmail.isSelected = true
            VerifiedEmail = SingletonClass.sharedInstance.RegisterData.Reg_email
            
        }
        
        if SingletonClass.sharedInstance.RegisterData.Reg_country_code != "" {
            TextFieldCountryCode.text = SingletonClass.sharedInstance.RegisterData.Reg_country_code
            
        } else {
            TextFieldCountryCode.text = CountryCodeArray.first
        }
        
        
        
    }
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
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        
        GeneralPicker.generalPickerDelegate = self
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
            
           
        }
        return true
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnActionEmailVerify(_ sender: UIButton) {
        if sender.isSelected == false {
           
            let checkEmail = TextFieldEmail.validatedText(validationType: ValidatorType.email)
            
            if (!checkEmail.0){
                Utilities.ShowAlertOfValidation(OfMessage: checkEmail.1)
               
            } else {
                EmailVerify()
            }
        }
    }
    
    @IBAction func btnActionMobileVerify(_ sender: UIButton) {
        if sender.isSelected == false {
            let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 10))
            if (!checkMobileNumber.0){
                Utilities.ShowAlertOfValidation(OfMessage: checkMobileNumber.1)
            } else {
                PhoneVerify()
            }
        }
    }
    
    @IBAction func BtnSignInAction(_ sender: Any) {
        appDel.NavigateToLogin()
    }
    
    @IBAction func BtnJoinForFreeAction(_ sender: Any) {
       
        let CheckValidation = Validate()
        if CheckValidation.0 {
            
            SingletonClass.sharedInstance.RegisterData.Reg_fullname = TextFieldFullName.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_country_code = TextFieldCountryCode.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_mobile_number = TextFieldMobileNumber.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_email = TextFieldEmail.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_password = TextFieldPassword.text ?? ""
            
            UserDefault.SetRegiterData()
            UserDefault.setValue(0, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
            
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 1
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            RegisterMainVC.viewDidLayoutSubviews()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validations ---------
    // ----------------------------------------------------
    
    func Validate() -> (Bool,String) {
        let checkFullName = TextFieldFullName.validatedText(validationType: ValidatorType.username(field: "full name",MaxChar: 70))
        let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 15))
        let checkEmail = TextFieldEmail.validatedText(validationType: ValidatorType.email)
        let checkPassword = TextFieldPassword.validatedText(validationType: ValidatorType.password(field: "password"))
        let checkConfirmPassword = TextFieldConfirmPassword.validatedText(validationType: ValidatorType.password(field: "confirm password"))
        
        if (!checkFullName.0){
            return (checkFullName.0,checkFullName.1)
        } else if (!checkMobileNumber.0){
            return (checkMobileNumber.0,checkMobileNumber.1)
        } else if (!checkEmail.0){
            return (checkEmail.0,checkEmail.1)
        }else if(!checkPassword.0){
            return (checkPassword.0,checkPassword.1)
        }else if(!checkConfirmPassword.0){
            return (checkConfirmPassword.0,checkConfirmPassword.1)
        }else if TextFieldPassword.text != TextFieldConfirmPassword.text{
            return (false,"Password and confirm password does not match")
        } else if !BtnVerifyPhoneNumber.isSelected {
            return (false,"Please verify phone number")
        } else if !BtnVerifyEmail.isSelected {
            return (false,"Please verify email")
        }
        return (true,"")
    }
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func PhoneVerify() {
        self.signUpViewModel.freelancerDriverSignupVC3 = self
        let ReqModelForMobileVerify = MobileVerifyReqModel()
        ReqModelForMobileVerify.mobile_number = "\(TextFieldCountryCode.text ?? "")\(TextFieldMobileNumber.text ?? "")"
        self.signUpViewModel.VerifyPhone(ReqModel: ReqModelForMobileVerify)
    }
    func EmailVerify() {
        self.signUpViewModel.freelancerDriverSignupVC3 = self
        let ReqModelForEmailVerify = EmailVerifyReqModel()
        ReqModelForEmailVerify.email = TextFieldEmail.text ?? ""
        self.signUpViewModel.VerifyEmail(ReqModel: ReqModelForEmailVerify)
    }
    
}


extension FreelancerDriverSignupVC3: GeneralPickerViewDelegate {
    
    func didTapDone() {
        let item = CountryCodeArray[GeneralPicker.selectedRow(inComponent: 0)]
        self.TextFieldCountryCode.text = item
        self.TextFieldCountryCode.resignFirstResponder()
    }
    
    func didTapCancel() {
        //self.endEditing(true)
    }
}
extension FreelancerDriverSignupVC3 : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
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
