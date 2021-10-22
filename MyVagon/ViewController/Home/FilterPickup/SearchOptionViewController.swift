//
//  SearchOptionViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit

class SearchOptionViewController: BaseViewController, GeneralPickerViewDelegate, UITextFieldDelegate {
    

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var selectedTextField : UITextField?
    let GeneralPicker = GeneralPickerView()
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var lblSelectedDate: themeLabel!
    @IBOutlet weak var LblPickupLocation: UILabel!
    @IBOutlet weak var LblDropOffLocation: UILabel!
    
    @IBOutlet weak var textFieldMinUnit: themeTextfield!
    @IBOutlet weak var textFieldMaxUnit: themeTextfield!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search Options", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        
        SetValue()
        setupDelegateForPickerView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        lblSelectedDate.text = "Select Date"
        LblPickupLocation.attributedText = GetAttributedString(Location: "Select pickup location", selectedType: "Select Haul")
        LblDropOffLocation.attributedText = GetAttributedString(Location: "Select dropoff location", selectedType: "Select Haul")
        
        textFieldMinUnit.delegate = self
        textFieldMaxUnit.delegate = self
    }
    
    func GetAttributedString(Location:String,selectedType:String) -> NSMutableAttributedString {
        let text = "\(Location) | \(selectedType)"

        let rangeLocation = (text as NSString).range(of: Location)
        let rangePipe = (text as NSString).range(of: " | ")
        let rangeSelectedtype = (text as NSString).range(of: selectedType)

        let LocationAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#9B51E0"), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(14)]
        
        let PipeAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1F1F41").withAlphaComponent(0.2), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(14)]
        
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1F1F41"), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(14)]
        
        
         let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttributes(LocationAttribute, range: rangeLocation)
        
        attributedString.addAttributes(PipeAttribute, range: rangePipe)
        
        attributedString.addAttributes(yourOtherAttributes, range: rangeSelectedtype)
        
        return attributedString
    }
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        
        GeneralPicker.generalPickerDelegate = self
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldMinUnit {
            selectedTextField = textFieldMinUnit
            textFieldMinUnit.inputView = GeneralPicker
            textFieldMinUnit.inputAccessoryView = GeneralPicker.toolbar
        } else if textField == textFieldMaxUnit {
            selectedTextField = textFieldMaxUnit
            textFieldMaxUnit.inputView = GeneralPicker
            textFieldMaxUnit.inputAccessoryView = GeneralPicker.toolbar
        }
           
          
            
           
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearchLoadsAction(_ sender: themeButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSelectDateAction(_ sender: themeButton) {
        
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterPickupDatePopupViewController.storyboardID) as! FilterPickupDatePopupViewController
        controller.selectDateClosour = { (selectedDate) in
            let formatter1 = DateFormatter()
             formatter1.dateStyle = .medium
             formatter1.dateFormat = "dd MMMM, yyyy"
             
             let DateinString = formatter1.string(from: selectedDate)
            
            
            self.lblSelectedDate.text = DateinString
        }
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func BtnPickupLocationAction(_ sender: themeButton) {
        
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
        controller.isForPickUp = true
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func BtnDropOffLocationAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
extension SearchOptionViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func didTapDone() {
        if selectedTextField == textFieldMinUnit {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.textFieldMinUnit.text = item?.name
            textFieldMinUnit.resignFirstResponder()
        } else if selectedTextField == textFieldMaxUnit {
           
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.textFieldMaxUnit.text = item?.name
            textFieldMaxUnit.resignFirstResponder()
            
        }
    }
    
    func didTapCancel() {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        
        
        
        
    }
    
}
