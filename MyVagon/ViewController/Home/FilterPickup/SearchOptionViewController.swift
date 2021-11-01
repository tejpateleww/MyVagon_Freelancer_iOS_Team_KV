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
    
    var searchViewModel = SearchViewModel()
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
        
        textFieldMinUnit?.delegate = self
        textFieldMaxUnit?.delegate = self
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
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearchLoadsAction(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            
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
             formatter1.dateFormat = "dd MMMM, yyyy"
             
             let DateinString = formatter1.string(from: selectedDate)
            
            
            self.lblSelectedDate.text = DateinString
            self.searchLoadModel.date = selectedDate.convertToString(format: "yyyy-MM-dd")
            
        }
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(408)])
        
                self.present(sheetController, animated: true, completion: nil)
        
      

        
    }
    
    @IBAction func BtnPickupLocationAction(_ sender: themeButton) {
        
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
        controller.SelectedLocationClosour = { (coordinates,Address) in
            self.LblPickupLocation.text = Address
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
        controller.SelectedLocationClosour = { (coordinates,Address) in
            self.LblDropOffLocation.text = Address
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
        
        if searchLoadModel.date.isEmpty {
            return (false,"Please select date")
        } else if searchLoadModel.pickup_lat.isEmpty || searchLoadModel.pickup_lng.isEmpty {
            return (false,"Please select pickup location")
        } else if searchLoadModel.delivery_lat.isEmpty || searchLoadModel.delivery_lng.isEmpty {
            return (false,"Please select dropoff location")
        } else if textFieldMinPrice?.text == "" {
            return (false,"Please enter an minimum price")
        } else if textFieldMaxPrice?.text == "" {
            return (false,"Please enter an maximum price")
        }else if (textFieldMinPrice?.text?.removeFormatAmount() ?? 0.0) > (textFieldMaxPrice?.text?.removeFormatAmount() ?? 0.0) {
            return (false,"Minimum price cannot be greater than maximum price")
        }else if (textFieldMinPrice?.text?.removeFormatAmount() ?? 0.0) == (textFieldMaxPrice?.text?.removeFormatAmount() ?? 0.0) {
            return (false,"Minimum price and maximum price cannot be same")
        }else if textFieldMinWeight?.text == "" {
            return (false,"Please enter a minimum weight")
        }else if searchLoadModel.weight_min_unit.isEmpty {
            return (false,"Please select minimum weight unit")
        }else if textFieldMaxWeight?.text == "" {
            return (false,"Please enter a maximum weight")
        }else if searchLoadModel.weight_max_unit.isEmpty {
            return (false,"Please select maximum weight unit")
        } else if (textFieldMinWeight?.text?.toDouble() ?? 0.0) > (textFieldMaxWeight?.text?.toDouble() ?? 0.0) {
            return (false,"Minimum weight cannot be greater than maximum weight")
        }else if (textFieldMinWeight?.text?.toDouble() ?? 0.0) > (textFieldMaxWeight?.text?.toDouble() ?? 0.0) {
            return (false,"Minimum weight and maximum weight cannot be same")
        }
        
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
    
        self.searchViewModel.searchOptionViewController =  self
        
        if let viewControllers = self.navigationController?.viewControllers
        {
            for vc in viewControllers {
                if vc.isKind(of: HomeViewController.self) {
                    let homeVC = vc as! HomeViewController
                    self.searchViewModel.homeViewController =  homeVC
                }
            }
            
        }
        
        let ReqModelForSearchLoad = SearchLoadReqModel()
        ReqModelForSearchLoad.date = searchLoadModel.date
        ReqModelForSearchLoad.truck_type_id = searchLoadModel.truck_type_id
        ReqModelForSearchLoad.pickup_lng = searchLoadModel.pickup_lat
        ReqModelForSearchLoad.pickup_lat = searchLoadModel.pickup_lat
        ReqModelForSearchLoad.delivery_lng = searchLoadModel.delivery_lng
        ReqModelForSearchLoad.delivery_lat = searchLoadModel.delivery_lat
        ReqModelForSearchLoad.price_max = searchLoadModel.price_max
        ReqModelForSearchLoad.price_min = searchLoadModel.price_min
        ReqModelForSearchLoad.weight_max = searchLoadModel.weight_max
        ReqModelForSearchLoad.weight_min = searchLoadModel.weight_min
        ReqModelForSearchLoad.weight_min_unit = searchLoadModel.weight_min_unit
        ReqModelForSearchLoad.weight_max_unit = searchLoadModel.weight_max_unit
        
//        let ReqModelForSearchLoad = SearchLoadReqModel()
//        ReqModelForSearchLoad.date = "2021-10-05"
//        ReqModelForSearchLoad.truck_type_id = "5"
//        ReqModelForSearchLoad.pickup_lat =  "23.1012966"
//        ReqModelForSearchLoad.pickup_lng = "72.54070519999999"
//        ReqModelForSearchLoad.delivery_lat = "23.0249607"
//        ReqModelForSearchLoad.delivery_lng = "72.50710959999999"
//        ReqModelForSearchLoad.price_max = ""
//        ReqModelForSearchLoad.price_min = ""
//        ReqModelForSearchLoad.weight_max = ""
//        ReqModelForSearchLoad.weight_min = ""
//        ReqModelForSearchLoad.weight_min_unit = ""
//        ReqModelForSearchLoad.weight_max_unit = ""
        
        self.searchViewModel.SearchShipment(ReqModel: ReqModelForSearchLoad)
        
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
    
    
    
}

