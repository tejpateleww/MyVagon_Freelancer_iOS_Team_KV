//
//  SearchOptionViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit
import FittedSheets
class SearchOptionViewController: BaseViewController, GeneralPickerViewDelegate, UITextFieldDelegate {
    
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var searchLoadModel = SearchLoadModel()
    var selectedTextField : UITextField?
    let GeneralPicker = GeneralPickerView()
    var customTabBarController: CustomTabBarVC?
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
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
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldMinPrice?.delegate = self
        self.textFieldMaxPrice?.delegate = self
        
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search Options", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.reset.value], isTranslucent: true, ShowShadow: true)
        
        SetValue()
        setupDelegateForPickerView()
        SearchResetClosour = {
            SingletonClass.sharedInstance.searchReqModel = SearchSaveReqModel()
            self.setValueInField()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func setValueInField() {
   
        if SingletonClass.sharedInstance.searchReqModel.pickup_date == "" {
            lblSelectedDate.text = Date().convertToString(format: "EEEE, dd/MM/yyyy") //"Select Date"
        } else {
            lblSelectedDate.text = SingletonClass.sharedInstance.searchReqModel.pickup_date.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
        }
        
        if SingletonClass.sharedInstance.searchReqModel.pickup_address_string == "" {
            LblPickupLocation.attributedText = GetAttributedString(Location: "Select pickup location", selectedType: "Select Haul")
        } else {
            LblPickupLocation.text =  SingletonClass.sharedInstance.searchReqModel.pickup_address_string
        }
        
        if SingletonClass.sharedInstance.searchReqModel.dropoff_address_string == "" {
            LblDropOffLocation.attributedText = GetAttributedString(Location: "Select dropoff location", selectedType: "Select Haul")
        } else {
            LblDropOffLocation.text = SingletonClass.sharedInstance.searchReqModel.dropoff_address_string
        }
      
        
        textFieldMinPrice?.text = SingletonClass.sharedInstance.searchReqModel.min_price
        textFieldMaxPrice?.text = SingletonClass.sharedInstance.searchReqModel.max_price
        
        textFieldMinWeight?.text = SingletonClass.sharedInstance.searchReqModel.min_weight
        textFieldMaxWeight?.text = SingletonClass.sharedInstance.searchReqModel.max_weight
        
        

//
//
//
//        SingletonClass.sharedInstance.searchReqModel.min_weight_unit = searchLoadModel.weight_min_unit
//        SingletonClass.sharedInstance.searchReqModel.max_weight_unit = searchLoadModel.weight_max_unit
    }
    func SetValue() {
       
        
        
        
        textFieldMinUnit?.delegate = self
        textFieldMaxUnit?.delegate = self
        
        setValueInField()
        
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
            textFieldMinUnit?.inputView = GeneralPicker
            textFieldMinUnit?.inputAccessoryView = GeneralPicker.toolbar
        } else if textField == textFieldMaxUnit {
            selectedTextField = textFieldMaxUnit
            textFieldMaxUnit?.inputView = GeneralPicker
            textFieldMaxUnit?.inputAccessoryView = GeneralPicker.toolbar
        }
    }
    
    
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
        return false
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearchLoadsAction(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            SingletonClass.sharedInstance.searchReqModel.pickup_date = searchLoadModel.date
            SingletonClass.sharedInstance.searchReqModel.min_price = searchLoadModel.price_min
            SingletonClass.sharedInstance.searchReqModel.max_price = searchLoadModel.price_max
            SingletonClass.sharedInstance.searchReqModel.pickup_lat = searchLoadModel.pickup_lat
            SingletonClass.sharedInstance.searchReqModel.pickup_lng = searchLoadModel.pickup_lng
            SingletonClass.sharedInstance.searchReqModel.dropoff_lat = searchLoadModel.delivery_lat
            SingletonClass.sharedInstance.searchReqModel.dropoff_lng = searchLoadModel.delivery_lng
            
            SingletonClass.sharedInstance.searchReqModel.min_weight = searchLoadModel.weight_min
            SingletonClass.sharedInstance.searchReqModel.max_weight = searchLoadModel.weight_max
            SingletonClass.sharedInstance.searchReqModel.min_weight_unit = searchLoadModel.weight_min_unit
            SingletonClass.sharedInstance.searchReqModel.max_weight_unit = searchLoadModel.weight_max_unit
            SingletonClass.sharedInstance.searchReqModel.pickup_address_string = searchLoadModel.pickupAddressString
            
            SingletonClass.sharedInstance.searchReqModel.dropoff_address_string = searchLoadModel.dropoffAddressString
            
            
            CallWebSerive()
            
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
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
            
            self.LblPickupLocation.text = Address
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
            self.LblDropOffLocation.text = Address
            self.searchLoadModel.dropoffAddressString = Address
            self.searchLoadModel.delivery_lat = "\(coordinates.latitude)"
            self.searchLoadModel.delivery_lng = "\(coordinates.longitude)"
        }
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validation ---------
    // ----------------------------------------------------
    func Validate() -> (Bool,String) {
        
        if textFieldMinPrice?.text != "" && textFieldMaxPrice?.text != "" {
            if ((textFieldMinPrice?.text ?? "").removeFormatAmount().1) > ((textFieldMaxPrice?.text ?? "").removeFormatAmount().1) {
                return (false,"Minimum price cannot be greater than maximum price")
            }else if ((textFieldMinPrice?.text ?? "").removeFormatAmount().1) == ((textFieldMinPrice?.text ?? "").removeFormatAmount().1) {
                return (false,"Minimum price and maximum price cannot be same")
            }
        } else if textFieldMinUnit?.text != "" {
            if searchLoadModel.weight_min_unit.isEmpty {
               return (false,"Please select minimum weight unit")
           }
        } else if textFieldMinUnit?.text != "" {
            if searchLoadModel.weight_max_unit.isEmpty {
                return (false,"Please select maximum weight unit")
            }
        } else  if textFieldMinUnit?.text != "" && textFieldMinUnit?.text != "" {
            if (textFieldMinWeight?.text?.toDouble() ?? 0.0) > (textFieldMaxWeight?.text?.toDouble() ?? 0.0) {
                return (false,"Minimum weight cannot be greater than maximum weight")
            }else if (textFieldMinWeight?.text?.toDouble() ?? 0.0) > (textFieldMaxWeight?.text?.toDouble() ?? 0.0) {
                return (false,"Minimum weight and maximum weight cannot be same")
            }
        }
        
        
//        if searchLoadModel.date.isEmpty {
//            return (false,"Please select date")
//        } else if searchLoadModel.pickup_lat.isEmpty || searchLoadModel.pickup_lng.isEmpty {
//            return (false,"Please select pickup location")
//        } else if searchLoadModel.delivery_lat.isEmpty || searchLoadModel.delivery_lng.isEmpty {
//            return (false,"Please select dropoff location")
//        } else if textFieldMinPrice?.text == "" {
//            return (false,"Please enter an minimum price")
//        } else if textFieldMaxPrice?.text == "" {
//            return (false,"Please enter an maximum price")
//        }else if (textFieldMinPrice?.text?.removeFormatAmount() ?? 0.0) > (textFieldMaxPrice?.text?.removeFormatAmount() ?? 0.0) {
//            return (false,"Minimum price cannot be greater than maximum price")
//        }else if (textFieldMinPrice?.text?.removeFormatAmount() ?? 0.0) == (textFieldMaxPrice?.text?.removeFormatAmount() ?? 0.0) {
//            return (false,"Minimum price and maximum price cannot be same")
//        }else if textFieldMinWeight?.text == "" {
//            return (false,"Please enter a minimum weight")
//        }else if searchLoadModel.weight_min_unit.isEmpty {
//            return (false,"Please select minimum weight unit")
//        }else if textFieldMaxWeight?.text == "" {
//            return (false,"Please enter a maximum weight")
//        }else if searchLoadModel.weight_max_unit.isEmpty {
//            return (false,"Please select maximum weight unit")
//        } else if (textFieldMinWeight?.text?.toDouble() ?? 0.0) > (textFieldMaxWeight?.text?.toDouble() ?? 0.0) {
//            return (false,"Minimum weight cannot be greater than maximum weight")
//        }else if (textFieldMinWeight?.text?.toDouble() ?? 0.0) > (textFieldMaxWeight?.text?.toDouble() ?? 0.0) {
//            return (false,"Minimum weight and maximum weight cannot be same")
//        }
        
        searchLoadModel.price_min = textFieldMinPrice?.text ?? ""
        searchLoadModel.price_max = textFieldMaxPrice?.text ?? ""
        searchLoadModel.weight_min = textFieldMinWeight?.text ?? ""
        searchLoadModel.weight_max = textFieldMaxWeight?.text ?? ""
        
        return (true,"")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    func CallWebSerive() {
        Utilities.showHud()
        
        if let viewControllers = self.navigationController?.viewControllers
        {
            for vc in viewControllers {
                if vc.isKind(of: HomeViewController.self) {
                    let homeVC = vc as! HomeViewController
                    homeVC.PageNumber = 0
                    homeVC.CallWebSerive()
                    self.navigationController?.popViewController(animated: true)
                    break
                }
            }
        }
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

