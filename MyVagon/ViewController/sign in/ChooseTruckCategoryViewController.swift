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
    
    var CategoryArray : [String] = ["Semi-trailer Truck","Truck With Trailer","Truck","Van/Transporter","Other"]
    var SubCategoryArray : [String] = ["AA","BB","CC","DD"]
    let GeneralPicker = GeneralPickerView()
    var SelectedTextField = 0
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldCategory: themeTextfield!
    @IBOutlet weak var TextFieldSubCategory: themeTextfield!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: NavTitles.TruckType.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        TextFieldCategory.delegate = self
        TextFieldSubCategory.delegate = self
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
        if textField == TextFieldCategory {
            SelectedTextField = 0
            TextFieldCategory.inputView = GeneralPicker
            TextFieldCategory.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = CategoryArray.first(where: {$0 == TextFieldCategory.text ?? ""}) {
                
                let indexOfA = CategoryArray.firstIndex(of: DummyFirst) ?? 0
                GeneralPicker.selectRow(indexOfA, inComponent: 0, animated: false)
                
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
                    
                    if let DummyFirst = CategoryArray.first {
                        
                        let indexOfA = CategoryArray.firstIndex(of: DummyFirst) ?? 0
                        GeneralPicker.selectRow(indexOfA, inComponent: 0, animated: false)
                        
                        self.GeneralPicker.reloadAllComponents()
                    }
                    
                    
                }
            } else {
                
            }
            
        }
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func BtnSaveAction(_ sender: themeButton) {
        self.navigationController?.popViewController(animated: true)
      
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
}
extension ChooseTruckCategoryViewController: GeneralPickerViewDelegate {
    
    func didTapDone() {
        
        if SelectedTextField == 0 {
            let item = CategoryArray[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldCategory.text = item
            self.TextFieldSubCategory.text = ""
            if item.lowercased() == "other" {
                TextFieldSubCategory.rightView?.isHidden = true
                print("Keyboard open here")
            } else {
                TextFieldSubCategory.rightView?.isHidden = false
            }
            
            
        } else if SelectedTextField == 1 {
            let item = SubCategoryArray[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldSubCategory.text = item
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
            return CategoryArray.count
        } else if SelectedTextField == 1 {
            return SubCategoryArray.count
        }
        return 0
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectedTextField == 0 {
            return CategoryArray[row]
        } else if SelectedTextField == 1 {
            return SubCategoryArray[row]
        }
        return ""
        
        
        
    }
    
}
