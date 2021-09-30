//
//  EnterTruckDetailsVC.swift
//  MyVagon
//
//  Created by MacMini on 26/07/21.
//

import UIKit

class EnterTruckDetailsVC: BaseViewController,UITextFieldDelegate {
    
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    //var UnitArray : [String] = SingletonClass.sharedInstance.TruckunitList
    let GeneralPicker = GeneralPickerView()
    var SelectedTextField = 0
    var IsMoveToChooseTruck = false
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var truckLogoIV: UIImageView!
    @IBOutlet weak var enterTruckLabel: themeLabel!
    @IBOutlet weak var loremLabel: themeLabel!
    @IBOutlet weak var truckTypeTF: themeTextfield!
    @IBOutlet weak var truckWeightTF: themeTextfield!
    @IBOutlet weak var cargoLoadCapTF: themeTextfield!
    @IBOutlet weak var truckWeightUnitTF: themeTextfield!
    @IBOutlet weak var cargoLoadUnitTF: themeTextfield!
    @IBOutlet weak var continueButton: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "TruckType"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TruckType), name: NSNotification.Name(rawValue: "TruckType"), object: nil)
        
        truckTypeTF.delegate = self
        truckWeightUnitTF.delegate = self
        cargoLoadUnitTF.delegate = self
        
        setupDelegateForPickerView()
        
        self.SetValue()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        IsMoveToChooseTruck = false
        
        DispatchQueue.main.async {
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    @objc func TruckType(){
        if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_type) ?? 0}) {
            
            if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category) ?? 0}) {
                
                truckTypeTF.text = "\(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].name ?? ""), \(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?[IndexForSubTruckType].name ?? "")"
            }
        }
    }
    
    func SetValue() {
        if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_type) ?? 0}) {
            
            if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == Int(SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category) ?? 0}) {
                
                truckTypeTF.text = "\(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].name ?? ""), \(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?[IndexForSubTruckType].name ?? "")"
            }
        }
        truckWeightTF.text = SingletonClass.sharedInstance.RegisterData.Reg_truck_weight
        cargoLoadCapTF.text = SingletonClass.sharedInstance.RegisterData.Reg_truck_capacity
        truckWeightUnitTF.text = SingletonClass.sharedInstance.RegisterData.Reg_weight_unit
        cargoLoadUnitTF.text = SingletonClass.sharedInstance.RegisterData.Reg_capacity_unit
       
    }
    
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        
        GeneralPicker.generalPickerDelegate = self
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == truckTypeTF {
            self.truckTypeTF.resignFirstResponder()
            if !IsMoveToChooseTruck {
                IsMoveToChooseTruck = true
                let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: ChooseTruckCategoryViewController.storyboardID) as! ChooseTruckCategoryViewController
                self.navigationController?.pushViewController(controller, animated: true)
            }
         
        } else if textField == truckWeightUnitTF {
            truckWeightUnitTF.inputView = GeneralPicker
            truckWeightUnitTF.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == truckWeightUnitTF.text ?? ""}) {
                
              
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
                
                self.GeneralPicker.reloadAllComponents()
            }
            SelectedTextField = 0
        } else if textField == cargoLoadUnitTF {
            cargoLoadUnitTF.inputView = GeneralPicker
            cargoLoadUnitTF.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where:{$0.name == cargoLoadUnitTF.text ?? ""}) {
                
               
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
                
                self.GeneralPicker.reloadAllComponents()
            }
            SelectedTextField = 1
        }
        
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func continueButtonPressed(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            SingletonClass.sharedInstance.RegisterData.Reg_truck_weight = truckWeightTF.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_weight_unit = truckWeightUnitTF.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_truck_capacity = cargoLoadCapTF.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_capacity_unit = cargoLoadUnitTF.text ?? ""
            
            
            UserDefault.SetRegiterData()
            
            
           
            
            UserDefault.setValue(1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
            
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 2
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            
         //   UserDefault.setValue(1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
          //  UserDefault.synchronize()
            RegisterMainVC.viewDidLayoutSubviews()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
      
        
    }
    
    func Validate() -> (Bool,String) {
        let CheckTruckType = truckTypeTF.validatedText(validationType: ValidatorType.Select(field: "truck type"))
        let CheckTruckWeight = truckWeightTF.validatedText(validationType: ValidatorType.requiredField(field: "truck weight"))
    
        let UnitTruckWeight = truckWeightUnitTF.validatedText(validationType: ValidatorType.Select(field: "unit of truck weight"))
        let CheckLoadCapacity = cargoLoadCapTF.validatedText(validationType: ValidatorType.requiredField(field: "truck load capacity"))
        
        let UnitLoadCapacity = cargoLoadUnitTF.validatedText(validationType: ValidatorType.Select(field: "unit of truck load capacity"))
        if (!CheckTruckType.0){
            return (CheckTruckType.0,CheckTruckType.1)
        } else if (!CheckTruckWeight.0){
            return (CheckTruckWeight.0,CheckTruckWeight.1)
        } else if (!UnitTruckWeight.0){
            return (UnitTruckWeight.0,UnitTruckWeight.1)
        }else if(!CheckLoadCapacity.0){
            return (CheckLoadCapacity.0,CheckLoadCapacity.1)
        }else if(!UnitLoadCapacity.0){
            return (UnitLoadCapacity.0,UnitLoadCapacity.1)
        }
        return (true,"")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

    
    
    
   

}
extension EnterTruckDetailsVC: GeneralPickerViewDelegate {
    
    func didTapDone() {
        
        if SelectedTextField == 0 {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.truckWeightUnitTF.text = item?.name
            
        } else if SelectedTextField == 1 {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.cargoLoadUnitTF.text = item?.name
        }
        
        
        self.truckWeightUnitTF.resignFirstResponder()
        self.cargoLoadUnitTF.resignFirstResponder()
        
    }
    
    func didTapCancel() {
        //self.endEditing(true)
    }
}
extension EnterTruckDetailsVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectedTextField == 0 {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        } else if SelectedTextField == 1 {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        }
        return 0
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectedTextField == 0 {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        } else if SelectedTextField == 1 {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        }
        return ""
    }
    
}
