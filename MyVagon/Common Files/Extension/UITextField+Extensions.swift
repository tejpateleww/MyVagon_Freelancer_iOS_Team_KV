//
//  UITextField+Extension.swift
//  ValidatorsMediumPost
//
//  Created by Arlind on 8/5/18.
//  Copyright © 2018 Arlind Aliu. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    
    
    func validatedText(validationType: ValidatorType) -> (Bool,String) {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return validator.validated(self.text!)
    }
    
  
    func addInputViewDatePicker(target: Any, selector: Selector ,PickerMode : UIDatePicker.Mode, MinDate : Bool? = false , MaxDate : Bool? = false, date: Date? = Date()) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker()//UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                
                // Fallback on earlier versions
            }
        if date != nil{
            datePicker.minimumDate = date
        }
         
        datePicker.datePickerMode = PickerMode
        if PickerMode == .date{
            if MinDate == true{
                datePicker.minimumDate = date
            }
            if MaxDate == true{
                datePicker.maximumDate = Date()
            }
        }
       
        self.inputView = datePicker
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: target, action: selector)
        self.inputAccessoryView = nil
        self.inputAccessoryView = toolBar
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
    }
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}

//extension UITextField{
//  //MARK:- Placeholder Color
// 
//  func setBoarderColor(bcolor:colors){
//      self.layer.borderColor  = bcolor.value.cgColor
//      self.layer.borderWidth = 1
//  }
//  
//  func validatedText(validationType: ValidatorType) -> (Bool,String) {
//        let validator = VaildatorFactory.validatorFor(type: validationType)
//        return validator.validated(self.text!)
//    }
//  
//  
//
//      func setupTextFieldRightViewUI() {
//          self.layoutIfNeeded()
//          let imgSearch = UIImageView(image: UIImage(named: "iconDropDown"))
//          imgSearch.frame = CGRect(x: self.frame.maxX - 70 , y: 5, width: 22, height: 22)
//          self.rightView = imgSearch
//          self.rightViewMode = .always
//      }
//      
//      func addInputViewDatePicker(target: Any, selector: Selector , MinDate : Bool , MaxDate : Bool) {
//          
//          let screenWidth = UIScreen.main.bounds.width
//          
//          //Add DatePicker as inputView
//          let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
//          if #available(iOS 13.4, *) {
//              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
//          } else {
//              // Fallback on earlier versions
//          }
//          datePicker.datePickerMode = .date
//          
//          
//          if MinDate == true{
//              datePicker.minimumDate = Date()
//          }
//          if MaxDate == true{
//              datePicker.maximumDate = Date()
//          }
//          
//          self.inputView = datePicker
//          //Add Tool Bar as input AccessoryView
//          let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
//          toolBar.sizeToFit()
//          let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//          let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
//          let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
//
//          self.inputAccessoryView = toolBar
//          toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
//
//      }
//      
//      
//      @objc func cancelPressed() {
//          self.resignFirstResponder()
//      }
//  }

extension UITextField {
    func StopWrittingAtCharactorLimit(CharLimit:Int,range:NSRange,string:String) -> Bool {
      

           let startingLength = self.text?.count ?? 0
           let lengthToAdd = string.count
           let lengthToReplace =  range.length
           let newLength = startingLength + lengthToAdd - lengthToReplace

           return newLength <= CharLimit
    }
}
