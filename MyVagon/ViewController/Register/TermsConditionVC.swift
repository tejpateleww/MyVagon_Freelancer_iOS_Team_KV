//
//  TermsConditionVC.swift
//  MyVagon
//
//  Created by Apple on 28/09/21.
//

import UIKit
import WebKit
class TermsConditionVC: BaseViewController,WKNavigationDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var registerViewModel = RegisterViewModel()
    var isTerms : Bool = true
    var customTabBarController: CustomTabBarVC?
    var strUrl = "http://13.36.112.48/"
    private let webView = WKWebView(frame: .zero)
    var strNavTitle = ""
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var vwWebMain: UIView!
    @IBOutlet weak var ViewForAcceptTermsCondition: UIView!
    @IBOutlet weak var btnRegister: themeButton!
   
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        setUp()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUp() {
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        webView.backgroundColor = .clear
     
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.vwWebMain.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.vwWebMain.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.vwWebMain.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.vwWebMain.topAnchor),
        ])
        self.webView.backgroundColor = .clear
        self.view.setNeedsLayout()
        let request = URLRequest(url: URL.init(string: "\(strUrl)")!)
        self.webView.navigationDelegate = self
     //   webView.scrollView.isScrollEnabled = false
//        webView.scrollView.bounces = false
       // webView.isUserInteractionEnabled = false
        self.webView.load(request)
       
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //Utilities.showHud()
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)

//
       
     
        if isTerms {
            self.ViewForAcceptTermsCondition.isHidden = false
        } else {
            self.ViewForAcceptTermsCondition.isHidden = true
        }
        self.view.layoutSubviews()
        
       // Utilities.hideHud()
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       // Utilities.hideHud()
    }

    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnAcceptTermsAction(_ sender: themeButton) {
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
        
        let productsDict = TruckCapacityType.ConvetToDictonary(arrayDataCart: SingletonClass.sharedInstance.RegisterData.Reg_pallets);
        
        let jsonData = try! JSONSerialization.data(withJSONObject: productsDict, options: [])
        let jsonString:String = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
//
        
        
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
        
        registerReqModel.truck_type  = SingletonClass.sharedInstance.RegisterData.Reg_truck_type
        registerReqModel.truck_sub_category = SingletonClass.sharedInstance.RegisterData.Reg_truck_sub_category
        registerReqModel.truck_weight  = SingletonClass.sharedInstance.RegisterData.Reg_truck_weight
        
        if let TruckUnitIndex = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.RegisterData.Reg_weight_unit}) {
            registerReqModel.weight_unit  = "\(SingletonClass.sharedInstance.TruckunitList?[TruckUnitIndex].id ?? 0)"
        }
        
       
        registerReqModel.truck_capacity  = SingletonClass.sharedInstance.RegisterData.Reg_truck_capacity
        
        if let CapacityUnitIndex = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.RegisterData.Reg_capacity_unit}) {
            registerReqModel.capacity_unit  = "\(SingletonClass.sharedInstance.TruckunitList?[CapacityUnitIndex].id ?? 0)"
        }
//            registerReqModel.capacity_unit  = SingletonClass.sharedInstance.RegisterData.Reg_TruckLoadCapacityUnit
        
        if let TruckBrandIndex = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.RegisterData.Reg_brand}) {
            registerReqModel.brand  = "\(SingletonClass.sharedInstance.TruckBrandList?[TruckBrandIndex].id ?? 0)"
        }
        
//            registerReqModel.brand  = SingletonClass.sharedInstance.RegisterData.Reg_TruckBrand
        registerReqModel.pallets = jsonString
        registerReqModel.fuel_type  = SingletonClass.sharedInstance.RegisterData.Reg_fuel_type
        registerReqModel.load_capacity  = ""
        registerReqModel.registration_no  = SingletonClass.sharedInstance.RegisterData.Reg_registration_no
        registerReqModel.vehicle_images  = SingletonClass.sharedInstance.RegisterData.Reg_vehicle_images.map({$0}).joined(separator: ",")

        registerReqModel.id_proof  = SingletonClass.sharedInstance.RegisterData.Reg_id_proof.map({$0}).joined(separator: ",")
        
        registerReqModel.truck_features = SingletonClass.sharedInstance.RegisterData.Reg_truck_features.map({$0}).joined(separator: ",")
        registerReqModel.license  = SingletonClass.sharedInstance.RegisterData.Reg_license.map({$0}).joined(separator: ",")
        registerReqModel.license_number  = SingletonClass.sharedInstance.RegisterData.Reg_license_number
        registerReqModel.license_expiry_date  = SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date.ConvertDateFormat(FromFormat: "dd-MM-yyyy", ToFormat: "yyyy-MM-dd")
       
        self.registerViewModel.WebServiceForRegister(ReqModel: registerReqModel)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}



