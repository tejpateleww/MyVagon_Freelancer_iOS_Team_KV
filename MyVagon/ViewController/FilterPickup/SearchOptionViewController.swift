//
//  SearchOptionViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit
import FittedSheets
class SearchOptionViewController: BaseViewController, GeneralPickerViewDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var lblSelectedDate: themeLabel!
    @IBOutlet weak var LblPickupLocation: UILabel!
    @IBOutlet weak var LblDropOffLocation: UILabel!
    @IBOutlet weak var textFieldMinPrice: themeTextfield?
    @IBOutlet weak var textFieldMaxPrice: themeTextfield?
    @IBOutlet weak var textFieldMinWeight: themeTextfield?
    @IBOutlet weak var textFieldMaxWeight: themeTextfield?
    @IBOutlet weak var textFieldMinUnit: themeTextfield?
    @IBOutlet weak var textFieldMaxUnit: themeTextfield?
    @IBOutlet weak var btnSearchLoad: themeButton!
    
    var searchLoadModel = SearchLoadModel()
    var selectedTextField : UITextField?
    let GeneralPicker = GeneralPickerView()
    var customTabBarController: CustomTabBarVC?
    
    var isPickUpLocationSelected : Bool = false
    var isDropOffLocationSelected : Bool = false
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search Options", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.reset.value], isTranslucent: true, ShowShadow: true)
        self.textFieldMinPrice?.delegate = self
        self.textFieldMaxPrice?.delegate = self
        self.textFieldMinUnit?.delegate = self
        self.textFieldMaxUnit?.delegate = self
        self.textFieldMinWeight?.delegate = self
        self.textFieldMaxWeight?.delegate = self
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        
        self.setValueInField()
        self.setupDelegateForPickerView()
        
        SearchResetClosour = {
            SingletonClass.sharedInstance.searchReqModel = SearchSaveReqModel()
            self.setValueInField()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    //MARK: - Custom methods
    func setValueInField() {
        if SingletonClass.sharedInstance.searchReqModel.date == "" {
            self.lblSelectedDate.text = Date().convertToString(format: "EEEE, dd/MM/yyyy")
        } else {
            self.lblSelectedDate.text = SingletonClass.sharedInstance.searchReqModel.date.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
        }
        
        if SingletonClass.sharedInstance.searchReqModel.pickup_address_string == "" {
            self.LblPickupLocation.attributedText = GetAttributedString(Location: "Select pickup location", selectedType: "Select Haul")
        } else {
            self.LblPickupLocation.text =  SingletonClass.sharedInstance.searchReqModel.pickup_address_string
        }
        
        if SingletonClass.sharedInstance.searchReqModel.dropoff_address_string == "" {
            self.LblDropOffLocation.attributedText = GetAttributedString(Location: "Select dropoff location", selectedType: "Select Haul")
        } else {
            self.LblDropOffLocation.text = SingletonClass.sharedInstance.searchReqModel.dropoff_address_string
        }
        
        self.textFieldMinPrice?.text = SingletonClass.sharedInstance.searchReqModel.price_min
        self.textFieldMaxPrice?.text = SingletonClass.sharedInstance.searchReqModel.price_max
        self.textFieldMinWeight?.text = SingletonClass.sharedInstance.searchReqModel.weight_min
        self.textFieldMaxWeight?.text = SingletonClass.sharedInstance.searchReqModel.weight_max
        
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
        self.GeneralPicker.dataSource = self
        self.GeneralPicker.delegate = self
        self.GeneralPicker.generalPickerDelegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textFieldMinUnit {
            self.selectedTextField = self.textFieldMinUnit
            self.textFieldMinUnit?.inputView = self.GeneralPicker
            self.textFieldMinUnit?.inputAccessoryView = self.GeneralPicker.toolbar
        } else if textField == self.textFieldMaxUnit {
            self.selectedTextField = self.textFieldMaxUnit
            self.textFieldMaxUnit?.inputView = GeneralPicker
            self.textFieldMaxUnit?.inputAccessoryView = self.GeneralPicker.toolbar
        }
    }
    
    func Validate() -> (Bool,String) {
        
        if(!isPickUpLocationSelected){
            return (false,"Please select pickup location")
        }
        
        if(self.textFieldMinPrice?.text == "" || self.textFieldMaxPrice?.text == ""){
            if(self.textFieldMinPrice?.text == ""){
                return (false,"Please enter minimum price")
            }else if(self.textFieldMaxPrice?.text == ""){
                return (false,"Please enter maximum price")
            }
        }else{
            if((self.textFieldMinPrice?.text ?? "").removeFormatAmount().1) > ((self.textFieldMaxPrice?.text ?? "").removeFormatAmount().1){
                return (false,"Minimum price cannot be greater than maximum price")
            }else if((self.textFieldMinPrice?.text ?? "").removeFormatAmount().1) == ((self.textFieldMaxPrice?.text ?? "").removeFormatAmount().1){
                return (false,"Minimum price and maximum price cannot be same")
            }
        }
        
        if(self.textFieldMinWeight?.text == ""){
            return (false,"Please enter minimum weight")
        }else{
            if(self.textFieldMinUnit?.text == ""){
                return (false,"Please enter minimum weight unit")
            }
        }
        
        if(self.textFieldMaxWeight?.text == ""){
            return (false,"Please enter maximum weight")
        }else{
            if(self.textFieldMaxUnit?.text == ""){
                return (false,"Please enter maximum weight unit")
            }
        }
        
        if(self.textFieldMinWeight?.text?.toDouble() ?? 0.0) > (self.textFieldMaxWeight?.text?.toDouble() ?? 0.0){
            return (false,"Minimum weight cannot be greater than maximum weight")
        }else if(self.textFieldMinWeight?.text?.toDouble() ?? 0.0) == (self.textFieldMaxWeight?.text?.toDouble() ?? 0.0){
            return (false,"Minimum weight and maximum weight cannot be same")
        }
        
        self.searchLoadModel.price_min = self.textFieldMinPrice?.text ?? ""
        self.searchLoadModel.price_max = self.textFieldMaxPrice?.text ?? ""
        self.searchLoadModel.weight_min = self.textFieldMinWeight?.text ?? ""
        self.searchLoadModel.weight_max = self.textFieldMaxWeight?.text ?? ""
        self.searchLoadModel.date = self.lblSelectedDate.text ?? ""
        
        return (true,"")
    }
    
    //MARK: - UIButton Action methods
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearchLoadsAction(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            SingletonClass.sharedInstance.searchReqModel.date = searchLoadModel.date.ConvertDateFormat(FromFormat: DateFormatForDisplay, ToFormat: "yyyy-MM-dd")
            SingletonClass.sharedInstance.searchReqModel.price_min = searchLoadModel.price_min.replacingOccurrences(of: "€ ", with: "", options: .literal, range: nil)
            SingletonClass.sharedInstance.searchReqModel.price_max = searchLoadModel.price_max.replacingOccurrences(of: "€ ", with: "", options: .literal, range: nil)
            SingletonClass.sharedInstance.searchReqModel.pickup_lat = searchLoadModel.pickup_lat
            SingletonClass.sharedInstance.searchReqModel.pickup_lng = searchLoadModel.pickup_lng
            SingletonClass.sharedInstance.searchReqModel.delivery_lat = searchLoadModel.delivery_lat
            SingletonClass.sharedInstance.searchReqModel.delivery_lng = searchLoadModel.delivery_lng
            SingletonClass.sharedInstance.searchReqModel.weight_min = searchLoadModel.weight_min
            SingletonClass.sharedInstance.searchReqModel.weight_max = searchLoadModel.weight_max
            SingletonClass.sharedInstance.searchReqModel.min_weight_unit = searchLoadModel.weight_min_unit
            SingletonClass.sharedInstance.searchReqModel.max_weight_unit = searchLoadModel.weight_max_unit
            SingletonClass.sharedInstance.searchReqModel.pickup_address_string = searchLoadModel.pickupAddressString
            SingletonClass.sharedInstance.searchReqModel.dropoff_address_string = searchLoadModel.dropoffAddressString
            
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: .reloadDataForSearch, object: nil)
            }
            
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
    
    @IBAction func BtnSelectDateAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterPickupDatePopupViewController.storyboardID) as! FilterPickupDatePopupViewController
        controller.hidesBottomBarWhenPushed = true
        controller.selectDateClosour = { (selectedDate) in
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .medium
            formatter1.dateFormat = DateFormatForDisplay
            let DateinString = formatter1.string(from: selectedDate)
            self.lblSelectedDate.text = DateinString
            self.searchLoadModel.date = selectedDate.convertToString(format: "EEEE, dd/MM/yyyy")
        }
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(408 + appDel.GetSafeAreaHeightFromBottom())])
        self.present(sheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func BtnPickupLocationAction(_ sender: themeButton) {
        
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
        controller.SelectedLocationClosour = { (coordinates,Address,selectedHaul) in
            //self.LblPickupLocation.text = Address
            self.isPickUpLocationSelected = true
            self.LblPickupLocation.attributedText = self.GetAttributedString(Location: Address, selectedType: selectedHaul)
            self.searchLoadModel.pickupAddressString = Address
            self.searchLoadModel.pickup_lat = "\(coordinates.latitude)"
            self.searchLoadModel.pickup_lng = "\(coordinates.longitude)"
            
        }
        controller.isForPickUp = true
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func BtnDropOffLocationAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
        controller.SelectedLocationClosour = { (coordinates,Address,selectedHaul) in
            //self.LblDropOffLocation.text = Address
            self.isDropOffLocationSelected = true
            self.LblDropOffLocation.attributedText = self.GetAttributedString(Location: Address, selectedType: selectedHaul)
            self.searchLoadModel.dropoffAddressString = Address
            self.searchLoadModel.delivery_lat = "\(coordinates.latitude)"
            self.searchLoadModel.delivery_lng = "\(coordinates.longitude)"
        }
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
}

//MARK: - UITextFieldDelegate methods
extension SearchOptionViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == self.textFieldMaxPrice){
            let text: NSString = (textField.text ?? "") as NSString
            let finalString = text.replacingCharacters(in: range, with: string)
            self.textFieldMaxPrice?.text = finalString.currency
        }
        if(textField == self.textFieldMinPrice){
            let text: NSString = (textField.text ?? "") as NSString
            let finalString = text.replacingCharacters(in: range, with: string)
            self.textFieldMinPrice?.text = finalString.currency
        }
        if textField == textFieldMinWeight || textField == textFieldMaxWeight{
         return true
        }
        return false
    }
}

extension SearchOptionViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func didTapDone() {
        if selectedTextField == textFieldMinUnit {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.textFieldMinUnit?.text = item?.name
            textFieldMinUnit?.resignFirstResponder()
            searchLoadModel.weight_min_unit = "\(item?.id ?? 0)"
        } else if selectedTextField == textFieldMaxUnit {
            
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.textFieldMaxUnit?.text = item?.name
            textFieldMaxUnit?.resignFirstResponder()
            searchLoadModel.weight_max_unit = "\(item?.id ?? 0)"
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

//MARK: - textfield delegate
extension SearchOptionViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if textField == textFieldMinWeight || textField == textFieldMaxWeight{
             if let weight:Int = Int(textField.text ?? ""){
                 if weight <= 0{
                     textField.text = ""
                 }
                 if textField.text?.count ?? 0 > 5{
                     var text = textField.text ?? ""
                     text.removeLast()
                     textField.text = text
                 }
             }else{
                 textField.text = ""
             }
         }
    }
}

class SearchLoadModel : Codable {
    var date = ""
    var truck_type_id = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.id ?? 0)"
    var pickup_lat = ""
    var pickup_lng = ""
    var delivery_lat = ""
    var delivery_lng = ""
    var price_min = ""
    var price_max = ""
    var weight_min = ""
    var weight_max = ""
    var weight_min_unit = ""
    var weight_max_unit = ""
    var pickupAddressString = ""
    var dropoffAddressString = ""
}

