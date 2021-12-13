//
//  ChooseTruckCategoryViewController.swift
//  MyVagon
//
//  Created by Apple on 26/07/21.
//

import UIKit

class ChooseTruckCategoryViewController: BaseViewController,UITextFieldDelegate {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
 //  var SelectedIndexOfCategory = -1
    let GeneralPicker = GeneralPickerView()
    var SelectedTextField = 0
    
    var SelectedCategoryIndex = 0
    var SelectedSubCategoryIndex = 0
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldCategory: themeTextfield!
    @IBOutlet weak var TextFieldSubCategory: themeTextfield!
    @IBOutlet weak var TextFieldTruckPlatNumber: themeTextfield!
    @IBOutlet weak var TextFieldTrailerPlatNumber: themeTextfield!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: NavTitles.TruckType.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        TextFieldCategory.delegate = self
        TextFieldSubCategory.delegate = self
        setupDelegateForPickerView()
        
        if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_type) ?? 0}) {

            self.SelectedCategoryIndex = IndexForTruckType
            TextFieldCategory.text = "\(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].name ?? "")"
            if (SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].isTrailer == 1) {
                self.TextFieldTrailerPlatNumber.superview?.isHidden = false
            } else {
                self.TextFieldTrailerPlatNumber.superview?.isHidden = true
            }
            if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category) ?? 0}) {

                TextFieldSubCategory.text =  "\(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?[IndexForSubTruckType].name ?? "")"
                
            }
        }
        TextFieldTruckPlatNumber.text = SingletonClass.sharedInstance.RegisterData.Reg_truck_plat_number
        TextFieldTrailerPlatNumber.text =    SingletonClass.sharedInstance.RegisterData.Reg_trailer_plat_number
        
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
        if textField == TextFieldCategory {
            SelectedTextField = 0
            TextFieldCategory.inputView = GeneralPicker
            TextFieldCategory.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.name == TextFieldCategory.text ?? ""}) {

                
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
                
                self.GeneralPicker.reloadAllComponents()
            }
            
        } else if textField == TextFieldSubCategory {
            if TextFieldCategory.text != "" {
                if TextFieldCategory.text?.lowercased() == "other" {
                    self.TextFieldSubCategory.inputView = nil
                    self.TextFieldSubCategory.becomeFirstResponder()
                    print("Keyboard open here")
                } else {
                    SelectedTextField = 1
                    TextFieldSubCategory.inputView = GeneralPicker
                    TextFieldSubCategory.inputAccessoryView = GeneralPicker.toolbar
                    if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_type) ?? 0}) {
                        if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category) ?? 0}) {
                            
                            GeneralPicker.selectRow(IndexForSubTruckType, inComponent: 0, animated: false)
                        }
                    }
                        self.GeneralPicker.reloadAllComponents()
                    
                }
            } else {
                
            }
            
        }
        
    }
    
    func Validate() -> (Bool,String) {
        let CheckTruckCategory = TextFieldCategory.validatedText(validationType: ValidatorType.Select(field: "truck category"))
        let CheckTruckSubCategory = TextFieldSubCategory.validatedText(validationType: ValidatorType.Select(field: "truck sub category"))
        let checkTruckPlateNumber = TextFieldTruckPlatNumber.validatedText(validationType: ValidatorType.requiredField(field: "truck plat number"))
        let checkTrailerNumber = TextFieldTrailerPlatNumber.validatedText(validationType: ValidatorType.requiredField(field: "trailer plat number"))
        
        if (!CheckTruckCategory.0){
            return (CheckTruckCategory.0,CheckTruckCategory.1)
        } else if (!CheckTruckSubCategory.0){
            return (CheckTruckSubCategory.0,CheckTruckSubCategory.1)
        } else if (!checkTruckPlateNumber.0){
            return (checkTruckPlateNumber.0,checkTruckPlateNumber.1)
        } else if (SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].isTrailer == 1){
            if (!checkTrailerNumber.0){
                return (checkTrailerNumber.0,checkTrailerNumber.1)
                
            }
        }
        return (true,"")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func BtnSaveAction(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            
            SingletonClass.sharedInstance.RegisterData.Reg_truck_type = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].id ?? 0)"
            SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[SelectedSubCategoryIndex].id ?? 0)"
            SingletonClass.sharedInstance.RegisterData.Reg_truck_plat_number = TextFieldTruckPlatNumber.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_trailer_plat_number = TextFieldTrailerPlatNumber.text ?? ""
           
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TruckType"), object: nil, userInfo: nil)
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
      
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
}
extension ChooseTruckCategoryViewController: GeneralPickerViewDelegate {
    
    func didTapDone() {
        
        if SelectedTextField == 0 {
            
            SelectedCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
            let item = SingletonClass.sharedInstance.TruckTypeList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldCategory.text = item?.name
            self.TextFieldSubCategory.text = ""
            self.TextFieldTruckPlatNumber.text = ""
            self.TextFieldTrailerPlatNumber.text = ""
            
            if item?.isTrailer == 1 {
                self.TextFieldTrailerPlatNumber.superview?.isHidden = false
            } else {
                self.TextFieldTrailerPlatNumber.superview?.isHidden = true
            }
            
            
            SelectedSubCategoryIndex = 0
            if item?.name?.lowercased() == "other" {
                TextFieldSubCategory.rightView?.isHidden = true
                print("Keyboard open here")
            } else {
                TextFieldSubCategory.rightView?.isHidden = false
            }
            
            
        } else if SelectedTextField == 1 {
         
            if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count != 0 {
                SelectedSubCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
                let item =
                SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[GeneralPicker.selectedRow(inComponent: 0)]
                
                self.TextFieldSubCategory.text = item?.name
    
            }
        }
        
        
        self.TextFieldCategory.resignFirstResponder()
        self.TextFieldSubCategory.resignFirstResponder()
        
    }
    
    func didTapCancel() {
        //self.endEditing(true)
    }
}
extension ChooseTruckCategoryViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectedTextField == 0 {
            return SingletonClass.sharedInstance.TruckTypeList?.count ?? 0
        } else if SelectedTextField == 1 {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0
        }
        return 0
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectedTextField == 0 {
            return SingletonClass.sharedInstance.TruckTypeList?[row].name
        } else if SelectedTextField == 1 {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[row].name
        }
        return ""
        
        
        
    }
    
}
