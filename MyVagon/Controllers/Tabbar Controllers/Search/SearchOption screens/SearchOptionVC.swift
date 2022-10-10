//
//  SearchOptionViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit
import FittedSheets

class SearchOptionVC: BaseViewController, GeneralPickerViewDelegate {
    
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
    @IBOutlet weak var lblPickUpDate: themeLabel!
    @IBOutlet weak var lblPickUpLocation: themeLabel!
    @IBOutlet weak var lblDeliveryLocation: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblWeight: themeLabel!
    @IBOutlet weak var btnCancel: themeButton!
    
    var searchLoadModel = SearchLoadModel()
    var selectedTextField : UITextField?
    let GeneralPicker = GeneralPickerView()
    var customTabBarController: CustomTabBarVC?
    var isPickUpLocationSelected : Bool = false
    var isDropOffLocationSelected : Bool = false
    var searchClick : (()->())?
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        self.setLocalization()
    }
    
    //MARK: - Custom methods
    @objc func changeLanguage(){
        setLocalization()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func setUpUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search Options".localized, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.reset.value], isTranslucent: true, ShowShadow: true)
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.setValueInField()
        self.setupDelegateForPickerView()
        self.addObserver()
    }
    
    func setData(){
        self.textFieldMinPrice?.delegate = self
        self.textFieldMaxPrice?.delegate = self
        self.textFieldMinUnit?.delegate = self
        self.textFieldMaxUnit?.delegate = self
        self.textFieldMinWeight?.delegate = self
        self.textFieldMaxWeight?.delegate = self
        SearchResetClosour = {
            SingletonClass.sharedInstance.searchReqModel = SearchSaveReqModel()
            self.navigationController?.popViewController(animated: true)
            if let click = self.searchClick{
                click()
            }
        }
    }
    
    func setLocalization() {
        self.lblPickUpDate.text = "Pickup Date".localized
        self.lblWeight.text = "Weight".localized
        self.lblPrice.text = "Price".localized
        self.lblPickUpLocation.text = "Pickup Location".localized
        self.lblDeliveryLocation.text = "Delivery Location".localized
        self.textFieldMaxUnit?.placeholder = "Unit".localized
        self.textFieldMinUnit?.placeholder = "Unit".localized
        self.textFieldMaxWeight?.placeholder = "Max".localized
        self.textFieldMinWeight?.placeholder = "Min".localized
        self.textFieldMaxPrice?.placeholder = "Max".localized
        self.textFieldMinPrice?.placeholder = "Min".localized
        self.btnSearchLoad.setTitle("Search Loads".localized, for: .normal)
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
    }
    
    func setValueInField() {
        if SingletonClass.sharedInstance.searchReqModel.date == "" {
            self.lblSelectedDate.attributedText = GetAttributedString(Location: "Select pickup Date".localized, selectedType: "")
        } else {
            self.lblSelectedDate.text = SingletonClass.sharedInstance.searchReqModel.date.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
        }
        if SingletonClass.sharedInstance.searchReqModel.pickup_address_string == "" {
            self.LblPickupLocation.attributedText = GetAttributedString(Location: "Select pickup location".localized, selectedType: "Select Haul".localized)
            self.LblPickupLocation.isHidden = true
        } else {
            self.LblPickupLocation.isHidden = false
            self.LblPickupLocation.attributedText = GetAttributedString(Location: SingletonClass.sharedInstance.searchReqModel.pickup_address_string, selectedType: Utilities.getJurnyType(type: (SingletonClass.sharedInstance.searchReqModel.pickUpType)))
            searchLoadModel.journey_type = SingletonClass.sharedInstance.searchReqModel.pickUpType
            searchLoadModel.pickup_lat = SingletonClass.sharedInstance.searchReqModel.pickup_lat
            searchLoadModel.pickup_lng = SingletonClass.sharedInstance.searchReqModel.pickup_lng
            searchLoadModel.pickupAddressString = SingletonClass.sharedInstance.searchReqModel.pickup_address_string
            isPickUpLocationSelected = true
        }
        if SingletonClass.sharedInstance.searchReqModel.dropoff_address_string == "" {
            self.LblDropOffLocation.attributedText = GetAttributedString(Location: "Select dropoff location".localized, selectedType: "Select Haul".localized)
            self.LblDropOffLocation.isHidden = true
        } else {
            self.LblDropOffLocation.isHidden = false
            self.LblDropOffLocation.text = SingletonClass.sharedInstance.searchReqModel.dropoff_address_string
            searchLoadModel.delivery_lat = SingletonClass.sharedInstance.searchReqModel.delivery_lat
            searchLoadModel.delivery_lng = SingletonClass.sharedInstance.searchReqModel.delivery_lng
            searchLoadModel.dropoffAddressString = SingletonClass.sharedInstance.searchReqModel.dropoff_address_string
            isDropOffLocationSelected = true
        }
        self.textFieldMinPrice?.text = SingletonClass.sharedInstance.searchReqModel.price_min
        self.textFieldMaxPrice?.text = SingletonClass.sharedInstance.searchReqModel.price_max
        self.textFieldMinWeight?.text = SingletonClass.sharedInstance.searchReqModel.weight_min
        self.textFieldMaxWeight?.text = SingletonClass.sharedInstance.searchReqModel.weight_max
        if SingletonClass.sharedInstance.searchReqModel.min_weight_unit == ""{
            self.textFieldMinUnit?.text = ""
            self.searchLoadModel.weight_min_unit = ""
        }
        if SingletonClass.sharedInstance.searchReqModel.max_weight_unit == ""{
            self.textFieldMaxUnit?.text = ""
            self.searchLoadModel.weight_max_unit = ""
        }
        for unit in SingletonClass.sharedInstance.TruckunitList ?? [] {
            if Int(SingletonClass.sharedInstance.searchReqModel.min_weight_unit) ?? 0 == unit.id{
                self.textFieldMinUnit?.text = unit.getName()
                self.searchLoadModel.weight_min_unit = "\(unit.id ?? 0)"
            }
            if Int(SingletonClass.sharedInstance.searchReqModel.max_weight_unit) ?? 0 == unit.id{
                self.textFieldMaxUnit?.text = unit.getName()
                self.searchLoadModel.weight_max_unit = "\(unit.id ?? 0)"
            }
        }
    }
    
    func GetAttributedString(Location:String,selectedType:String) -> NSMutableAttributedString {
        var text = "\(Location) | \(selectedType)"
        if selectedType == ""{
            text = "\(Location)"
        }
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
    
    func Validate() -> (Bool,String){
        if self.textFieldMinPrice?.text != "" && self.textFieldMaxPrice?.text != ""{
            if((self.textFieldMinPrice?.text ?? "").toDoubleWithAutoLocale()) > ((self.textFieldMaxPrice?.text ?? "").toDoubleWithAutoLocale()){
                return (false,"Minimum price cannot be greater than maximum price".localized)
            }else if((self.textFieldMinPrice?.text ?? "").toDoubleWithAutoLocale()) == ((self.textFieldMaxPrice?.text ?? "").toDoubleWithAutoLocale()){
                return (false,"Minimum price and maximum price cannot be same".localized)
            }
        }
        if self.textFieldMaxWeight?.text != "" && self.textFieldMinWeight?.text != ""{
            if(self.textFieldMinWeight?.text?.toDouble() ?? 0.0) > (self.textFieldMaxWeight?.text?.toDouble() ?? 0.0){
                return (false,"Minimum weight cannot be greater than maximum weight".localized)
            }else if(self.textFieldMinWeight?.text?.toDouble() ?? 0.0) == (self.textFieldMaxWeight?.text?.toDouble() ?? 0.0){
                return (false,"Minimum weight and maximum weight cannot be same".localized)
            }
        }
        self.searchLoadModel.price_min = self.textFieldMinPrice?.text ?? ""
        self.searchLoadModel.price_max = self.textFieldMaxPrice?.text ?? ""
        self.searchLoadModel.weight_min = self.textFieldMinWeight?.text ?? ""
        self.searchLoadModel.weight_max = self.textFieldMaxWeight?.text ?? ""
        self.searchLoadModel.date = self.lblSelectedDate.text ?? ""
        return (true,"")
    }
    
    func saveData(){
        var date = ""
        if searchLoadModel.date != "Select pickup Date".localized{
            date = searchLoadModel.date.ConvertDateFormat(FromFormat: DateFormatForDisplay, ToFormat: "yyyy-MM-dd")
        }
        SingletonClass.sharedInstance.searchReqModel.pickUpType = searchLoadModel.journey_type
        SingletonClass.sharedInstance.searchReqModel.date = date
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
    }
    
    //MARK: - IBAction methods
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearchLoadsAction(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            self.saveData()
            self.navigationController?.popViewController(animated: true)
            if let click = searchClick{
                click()
            }
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
    
    @IBAction func BtnSelectDateAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: PickupDatePopupVC.storyboardID) as! PickupDatePopupVC
        controller.hidesBottomBarWhenPushed = true
        controller.selectDateClosour = { (selectedDate) in
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .medium
            formatter1.dateFormat = DateFormatForDisplay
            formatter1.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
            let DateinString = formatter1.string(from: selectedDate)
            self.lblSelectedDate.text = DateinString
            self.searchLoadModel.date = selectedDate.convertToString(format: "EEEE, dd/MM/yyyy")
        }
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(408 + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func BtnPickupLocationAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: PickupLocationPopupVC.storyboardID) as! PickupLocationPopupVC
        controller.SelectedLocationClosour = { (coordinates,Address,selectedHaul) in
            self.isPickUpLocationSelected = true
            self.LblPickupLocation.isHidden = false
            self.searchLoadModel.journey_type = Utilities.setJurnyType(type: selectedHaul)
            self.searchLoadModel.pickupAddressString = Address
            self.searchLoadModel.pickup_lat = "\(coordinates.latitude)"
            self.searchLoadModel.pickup_lng = "\(coordinates.longitude)"
            self.LblPickupLocation.attributedText = self.GetAttributedString(Location: Address, selectedType: selectedHaul)
        }
        controller.isForPickUp = true
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func BtnDropOffLocationAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: PickupLocationPopupVC.storyboardID) as! PickupLocationPopupVC
        controller.SelectedLocationClosour = { (coordinates,Address,selectedHaul) in
            self.isDropOffLocationSelected = true
            self.LblDropOffLocation.isHidden = false
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
extension SearchOptionVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.textFieldMaxPrice){
            return true
        }
        if(textField == self.textFieldMinPrice){
            return true
        }
        if textField == textFieldMinWeight || textField == textFieldMaxWeight{
         return true
        }
        return false
    }
}

//MARK: - Picker View delegate and dataSource
extension SearchOptionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func didTapDone() {
        if selectedTextField == textFieldMinUnit {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.textFieldMinUnit?.text = item?.getName()
            textFieldMinUnit?.resignFirstResponder()
            searchLoadModel.weight_min_unit = "\(item?.id ?? 0)"
        } else if selectedTextField == textFieldMaxUnit {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.textFieldMaxUnit?.text = item?.getName()
            textFieldMaxUnit?.resignFirstResponder()
            searchLoadModel.weight_max_unit = "\(item?.id ?? 0)"
        }
    }
    
    func didTapCancel() {}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SingletonClass.sharedInstance.TruckunitList?[row].getName()
    }
}

//MARK: - textfield delegate
extension SearchOptionVC {
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if textField == textFieldMinWeight || textField == textFieldMaxWeight{
             if let weight:Int = Int(textField.text ?? ""){
                 if weight <= 0{
                     textField.text = ""
                     return
                 }
                 if textField.text?.count ?? 0 > 5{
                     var text = textField.text ?? ""
                     text.removeLast()
                     textField.text = text
                 }
             }else{
                 textField.text = ""
             }
         }else if textField == textFieldMaxPrice || textField == textFieldMinPrice{
                 if textField.text?.count ?? 0 > 9{
                     var text = textField.text ?? ""
                     text.removeLast()
                     textField.text = text
                 }
         }
    }
}
