//
//  TermsConditionVC.swift
//  MyVagon
//
//  Created by Apple on 28/09/21.
//

import UIKit
import WebKit
class TermsConditionVC: BaseViewController {

    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewWeb: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var btnRegister: themeButton!
    
    var registerViewModel = RegisterViewModel()
    var isTerms : Bool = true
    var customTabBarController: CustomTabBarVC?
    var strUrl = SingletonClass.sharedInstance.initResModel?.termsAndCondition ?? "https://www.google.com/"
    var strNavTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    func setUp() {
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.viewWeb.navigationDelegate = self
        self.Activity.color = UIColor.black
        self.Activity.hidesWhenStopped = true
        self.viewWeb.addSubview(self.Activity)
        self.LoadFromURL(strUrl: strUrl)
    }
    
    func LoadFromURL(strUrl : String){
        let url = URL(string: self.strUrl)
        let requestObj = URLRequest(url: url! as URL)
        viewWeb.load(requestObj)
    }    

    @IBAction func btnCheckAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
 
    @IBAction func btnRegisterClick(_ sender: themeButton) {
        if btnAccept.isSelected {
            Register()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: "Please accept terms & conditions")
        }
    }
    
    func Register() {
        
        self.registerViewModel.termsConditionVC = self
        
//        let productsDict = TruckCapacityType.ConvetToDictonary(arrayDataCart: SingletonClass.sharedInstance.RegisterData.Reg_pallets);
//        let jsonData = try! JSONSerialization.data(withJSONObject: productsDict, options: [])
//        let jsonString:String = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonString = try! encoder.encode(SingletonClass.sharedInstance.RegisterData.Reg_truck_data)
        print(String(data: jsonString, encoding: .utf8)!)
        let finalJson = String(data: jsonString, encoding: .utf8)!
        
        let registerReqModel = RegisterReqModel()
        registerReqModel.app_version = SingletonClass.sharedInstance.AppVersion
        registerReqModel.device_name = SingletonClass.sharedInstance.DeviceName
        registerReqModel.device_type = SingletonClass.sharedInstance.DeviceType
        registerReqModel.device_token = SingletonClass.sharedInstance.DeviceToken
        
        registerReqModel.fullname  = SingletonClass.sharedInstance.RegisterData.Reg_fullname
        registerReqModel.country_code  = SingletonClass.sharedInstance.RegisterData.Reg_country_code
        registerReqModel.mobile_number  = SingletonClass.sharedInstance.RegisterData.Reg_mobile_number
        registerReqModel.email  = SingletonClass.sharedInstance.RegisterData.Reg_email
        registerReqModel.password  = SingletonClass.sharedInstance.RegisterData.Reg_password
        
        registerReqModel.tractor_fual_type  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_fual_type
        registerReqModel.tractor_brand  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_brand
        registerReqModel.tractor_plate_number  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_plate_number
        registerReqModel.tractor_images  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_images.map({$0}).joined(separator: ",")
        
        registerReqModel.payment_type  = SingletonClass.sharedInstance.RegisterData.Reg_payment_type
        registerReqModel.iban  = SingletonClass.sharedInstance.RegisterData.Reg_payment_iban
        registerReqModel.account_number  = SingletonClass.sharedInstance.RegisterData.Reg_payment_account_number
        registerReqModel.bank_name  = SingletonClass.sharedInstance.RegisterData.Reg_payment_bank_name
        registerReqModel.country  = SingletonClass.sharedInstance.RegisterData.Reg_payment_country
        
        registerReqModel.id_proof  = SingletonClass.sharedInstance.RegisterData.Reg_id_proof.map({$0}).joined(separator: ",")
        registerReqModel.license  = SingletonClass.sharedInstance.RegisterData.Reg_license.map({$0}).joined(separator: ",")
        registerReqModel.license_number  = SingletonClass.sharedInstance.RegisterData.Reg_license_number
        registerReqModel.license_expiry_date  = SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date.ConvertDateFormat(FromFormat: "dd-MM-yyyy", ToFormat: "yyyy-MM-dd")

        registerReqModel.truck_details = finalJson
        
        
        
//        registerReqModel.truck_type  = SingletonClass.sharedInstance.RegisterData.Reg_truck_type
//        registerReqModel.truck_sub_category = SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category
//        registerReqModel.truck_weight  = SingletonClass.sharedInstance.RegisterData.Reg_truck_weight
//        registerReqModel.truck_capacity  = SingletonClass.sharedInstance.RegisterData.Reg_truck_capacity
//        registerReqModel.plate_number_truck = SingletonClass.sharedInstance.RegisterData.Reg_truck_plat_number
//        registerReqModel.plate_number_trailer = SingletonClass.sharedInstance.RegisterData.Reg_trailer_plat_number
//        registerReqModel.pallets = jsonString
//        registerReqModel.fuel_type  = SingletonClass.sharedInstance.RegisterData.Reg_fuel_type
//        registerReqModel.vehicle_images  = SingletonClass.sharedInstance.RegisterData.Reg_vehicle_images.map({$0}).joined(separator: ",")
//        registerReqModel.truck_features = SingletonClass.sharedInstance.RegisterData.Reg_truck_features.map({$0}).joined(separator: ",")
//
//        if let TruckUnitIndex = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.RegisterData.Reg_weight_unit}) {
//            registerReqModel.weight_unit  = "\(SingletonClass.sharedInstance.TruckunitList?[TruckUnitIndex].id ?? 0)"
//        }
//
//        if let CapacityUnitIndex = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.RegisterData.Reg_capacity_unit}) {
//            registerReqModel.capacity_unit  = "\(SingletonClass.sharedInstance.TruckunitList?[CapacityUnitIndex].id ?? 0)"
//        }
//
//        if let TruckBrandIndex = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.RegisterData.Reg_brand}) {
//            registerReqModel.brand  = "\(SingletonClass.sharedInstance.TruckBrandList?[TruckBrandIndex].id ?? 0)"
//        }
        
       
       
        

        
        
        
        
        
       
        self.registerViewModel.WebServiceForRegister(ReqModel: registerReqModel)
    }

}




extension TermsConditionVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //Utility.showHUD()
        self.Activity.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Utility.hideHUD()
        self.Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //Utility.hideHUD()
        self.Activity.stopAnimating()
    }
    
}
