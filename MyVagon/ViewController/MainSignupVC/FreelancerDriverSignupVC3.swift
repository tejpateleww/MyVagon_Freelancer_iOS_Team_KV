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
    var CountryCodeArray: [String] = ["+30"]
    let GeneralPicker = GeneralPickerView()
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldFullName: themeTextfield!
    @IBOutlet weak var TextFieldCountryCode: themeTextfield!
    @IBOutlet weak var TextFieldMobileNumber: themeTextfield!
    @IBOutlet weak var TextFieldEmail: themeTextfield!
    @IBOutlet weak var TextFieldPassword: themeTextfield!
    @IBOutlet weak var TextFieldConfirmPassword: themeTextfield!
    
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
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setValue() {
        TextFieldFullName.text = SingletonClass.sharedInstance.Reg_FullName
        
        TextFieldMobileNumber.text = SingletonClass.sharedInstance.Reg_PhoneNumber
        TextFieldEmail.text = SingletonClass.sharedInstance.Reg_Email
        TextFieldPassword.text = SingletonClass.sharedInstance.Reg_Password
        TextFieldConfirmPassword.text = SingletonClass.sharedInstance.Reg_Password
        
        if SingletonClass.sharedInstance.Reg_CountryCode == "" {
            TextFieldCountryCode.text = CountryCodeArray[0]
        } else {
            TextFieldCountryCode.text = SingletonClass.sharedInstance.Reg_CountryCode
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
        }
        return true
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnActionEmailVerify(_ sender: UIButton) {
        if sender.isSelected == false {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
           
            controller.ClosourVerify = {
                controller.dismiss(animated: true, completion: nil)
                sender.isSelected = true
            }
            controller.EnteredText = "Enter an otp send to \nabc@yopmail.com"
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnActionMobileVerify(_ sender: UIButton) {
        if sender.isSelected == false {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
            controller.EnteredText = "Enter an otp send to \n+30 11122233344"
            controller.ClosourVerify = {
                controller.dismiss(animated: true, completion: nil)
                sender.isSelected = true
            }
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func BtnSignInAction(_ sender: Any) {
        appDel.NavigateToLogin()
        
    }
    
    @IBAction func BtnJoinForFreeAction(_ sender: Any) {
       
        let CheckValidation = Validate()
        if CheckValidation.0 {
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 1
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
           
            
            RegisterMainVC.viewDidLayoutSubviews()
            
            SingletonClass.sharedInstance.Reg_FullName = TextFieldFullName.text ?? ""
            SingletonClass.sharedInstance.Reg_CountryCode = TextFieldCountryCode.text ?? ""
            SingletonClass.sharedInstance.Reg_PhoneNumber = TextFieldMobileNumber.text ?? ""
            SingletonClass.sharedInstance.Reg_Email = TextFieldEmail.text ?? ""
            SingletonClass.sharedInstance.Reg_Password = TextFieldPassword.text ?? ""
            
            SingletonClass.sharedInstance.SaveRegisterDataToUserDefault()
            
            UserDefault.setValue(0, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validations ---------
    // ----------------------------------------------------
    
    func Validate() -> (Bool,String) {
        let checkFullName = TextFieldFullName.validatedText(validationType: ValidatorType.username(field: "full name"))
        let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo)
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
            return (false,"Password and confirm password must be same")
        }
        return (true,"")
    }
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
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
