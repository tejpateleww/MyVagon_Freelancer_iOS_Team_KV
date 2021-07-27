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
    var CountryCodeArray: [String] = ["+1","+91","+92","+93","+94","+188"]
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
        TextFieldCountryCode.text = CountryCodeArray[0]
        TextFieldPassword.delegate = self
        TextFieldConfirmPassword.delegate = self
        TextFieldCountryCode.delegate = self
        setupDelegateForPickerView()
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
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
        sender.isSelected = !sender.isSelected
       
    }
    
    @IBAction func btnActionMobileVerify(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
      
    }
    
    @IBAction func BtnSignInAction(_ sender: Any) {
        appDel.NavigateToLogin()
        
    }
    
    @IBAction func BtnJoinForFreeAction(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: EnterTruckDetailsVC.storyboardID) as! EnterTruckDetailsVC
        self.navigationController?.pushViewController(controller, animated: true)
//        let CheckValidation = Validate()
//        if CheckValidation.0 {
//           
//        } else {
//            Utilities.ShowAlert(OfMessage: CheckValidation.1)
//        }
        
        
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
