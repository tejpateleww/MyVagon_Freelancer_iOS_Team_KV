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
    
    var UnitArray : [String] = ["Pallet","Skid","Flat Sheets"]
    let GeneralPicker = GeneralPickerView()
    var SelectedTextField = 0
    
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
        
        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        truckTypeTF.delegate = self
        truckWeightUnitTF.delegate = self
        cargoLoadUnitTF.delegate = self
        
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
        
        if textField == truckTypeTF {
            self.truckTypeTF.resignFirstResponder()
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: ChooseTruckCategoryViewController.storyboardID) as! ChooseTruckCategoryViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
            
        } else if textField == truckWeightUnitTF {
            truckWeightUnitTF.inputView = GeneralPicker
            truckWeightUnitTF.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = UnitArray.first(where: {$0 == truckWeightUnitTF.text ?? ""}) {
                
                let indexOfA = UnitArray.firstIndex(of: DummyFirst) ?? 0
                GeneralPicker.selectRow(indexOfA, inComponent: 0, animated: false)
                
                self.GeneralPicker.reloadAllComponents()
            }
            SelectedTextField = 0
        } else if textField == cargoLoadUnitTF {
            cargoLoadUnitTF.inputView = GeneralPicker
            cargoLoadUnitTF.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = UnitArray.first(where: {$0 == cargoLoadUnitTF.text ?? ""}) {
                
                let indexOfA = UnitArray.firstIndex(of: DummyFirst) ?? 0
                GeneralPicker.selectRow(indexOfA, inComponent: 0, animated: false)
                
                self.GeneralPicker.reloadAllComponents()
            }
            SelectedTextField = 1
        }
        
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func continueButtonPressed(_ sender: themeButton) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: TruckDetailVC.storyboardID) as! TruckDetailVC
        self.navigationController?.pushViewController(controller, animated: true)
      
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

    
    
    
   

}
extension EnterTruckDetailsVC: GeneralPickerViewDelegate {
    
    func didTapDone() {
        
        if SelectedTextField == 0 {
            let item = UnitArray[GeneralPicker.selectedRow(inComponent: 0)]
            self.truckWeightUnitTF.text = item
            
        } else if SelectedTextField == 1 {
            let item = UnitArray[GeneralPicker.selectedRow(inComponent: 0)]
            self.cargoLoadUnitTF.text = item
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
            return UnitArray.count
        } else if SelectedTextField == 1 {
            return UnitArray.count
        }
        return 0
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectedTextField == 0 {
            return UnitArray[row]
        } else if SelectedTextField == 1 {
            return UnitArray[row]
        }
        return ""
    }
    
}
