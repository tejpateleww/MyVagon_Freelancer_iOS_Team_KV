//
//  TermsConditionVC.swift
//  MyVagon
//
//  Created by Apple on 28/09/21.
//

import UIKit
import WebKit

class TermsConditionVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewWeb: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var btnRegister: themeButton!
    @IBOutlet weak var lbltermsandCondition: UILabel!
    
    var registerViewModel = RegisterViewModel()
    var isTerms : Bool = true
    var customTabBarController: CustomTabBarVC?
    var strUrl = SingletonClass.sharedInstance.initResModel?.termsAndCondition ?? "https://www.google.com/"
    var strNavTitle = ""

    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        self.setLocalization()
    }
    
    //MARK: - Custom method
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.lbltermsandCondition.text = "I accept Terms and Conditions".localized
        self.btnRegister.setTitle("Register".localized, for: .normal)
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

    func Register() {
//        self.registerViewModel.termsConditionVC = self
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let jsonString = try! encoder.encode(SingletonClass.sharedInstance.RegisterData.Reg_truck_data)
//        let finalJson = String(data: jsonString, encoding: .utf8)!
//        let registerReqModel = RegisterReqModel()
//        registerReqModel.app_version = SingletonClass.sharedInstance.AppVersion
//        registerReqModel.device_name = SingletonClass.sharedInstance.DeviceName
//        registerReqModel.device_type = SingletonClass.sharedInstance.DeviceType
//        registerReqModel.device_token = SingletonClass.sharedInstance.DeviceToken
//        registerReqModel.fullname  = SingletonClass.sharedInstance.RegisterData.Reg_fullname
//        registerReqModel.country_code  = SingletonClass.sharedInstance.RegisterData.Reg_country_code
//        registerReqModel.mobile_number  = SingletonClass.sharedInstance.RegisterData.Reg_mobile_number
//        registerReqModel.email  = SingletonClass.sharedInstance.RegisterData.Reg_email
//        registerReqModel.password  = SingletonClass.sharedInstance.RegisterData.Reg_password
//        registerReqModel.tractor_fual_type  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_fual_type
//        registerReqModel.tractor_brand  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_brand
//        registerReqModel.tractor_plate_number  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_plate_number
//        registerReqModel.tractor_images  = SingletonClass.sharedInstance.RegisterData.Reg_tractor_images.map({$0}).joined(separator: ",")
//        registerReqModel.payment_type  = SingletonClass.sharedInstance.RegisterData.Reg_payment_type
//        registerReqModel.iban  = SingletonClass.sharedInstance.RegisterData.Reg_payment_iban
//        registerReqModel.account_number  = SingletonClass.sharedInstance.RegisterData.Reg_payment_account_number
//        registerReqModel.bank_name  = SingletonClass.sharedInstance.RegisterData.Reg_payment_bank_name
//        registerReqModel.country  = SingletonClass.sharedInstance.RegisterData.Reg_payment_country
//        registerReqModel.id_proof  = SingletonClass.sharedInstance.RegisterData.Reg_id_proof.map({$0}).joined(separator: ",")
//        registerReqModel.license  = SingletonClass.sharedInstance.RegisterData.Reg_license.map({$0}).joined(separator: ",")
//        registerReqModel.licenseBack  = SingletonClass.sharedInstance.RegisterData.Reg_licenseBack.map({$0}).joined(separator: ",")
//        registerReqModel.license_number  = SingletonClass.sharedInstance.RegisterData.Reg_license_number
//        registerReqModel.license_expiry_date  = SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date.ConvertDateFormat(FromFormat: "dd-MM-yyyy", ToFormat: "yyyy-MM-dd")
//        registerReqModel.truck_details = finalJson
//        self.registerViewModel.WebServiceForRegister(ReqModel: registerReqModel)
    }
    
    //MARK: - IBAction method
    @IBAction func btnCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
 
    @IBAction func btnRegisterClick(_ sender: themeButton) {
        if btnAccept.isSelected {
            Register()
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: "Please accept Terms & Conditions".localized)
        }
    }
}

//MARK: - WKNavigationDelegate data source
extension TermsConditionVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.Activity.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.Activity.stopAnimating()
    }
    
}
