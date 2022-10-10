//
//  Payments.swift
//  MyVagon
//
//  Created by Dhanajay  on 21/02/22.
//

import UIKit
import SafariServices

class PaymentsVC: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var redioBtnCash: UIButton!
    @IBOutlet weak var redioBtnBank: UIButton!
    @IBOutlet weak var redioBtnBoth: UIButton!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var imgCash: UIImageView!
    @IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var imgBoth: UIImageView!
    @IBOutlet weak var btnSave: themeButton!
    @IBOutlet weak var txtIBAN: themeTextfield!
    @IBOutlet weak var txtAccountNumber: themeTextfield!
    @IBOutlet weak var txtBankName: themeTextfield!
    @IBOutlet weak var txtCountry: themeTextfield!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var lblBoth: UILabel!
    @IBOutlet weak var lblContrect: UILabel!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var viewBottum: UIView!
    
    var selectedPaymentMode = "0"
    var paymentViewModel = PaymentViewModel()
    var paymentDetailData : PaymentDetailData?
    var isFromEdit = false
    var registerViewModel = RegisterViewModel()
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    // MARK: - Custom methods
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.lblBank.text = "Bank".localized
        self.lblCash.text = "Cash".localized
        self.lblBoth.text = "Both".localized
        self.txtIBAN.placeholder = "IBAN".localized
        self.txtBankName.placeholder = "Bank Name".localized
        self.txtAccountNumber.placeholder = "acccount number".localized
        self.txtCountry.placeholder = "Country".localized
        if isFromEdit{
            self.btnSave.setTitle("Save".localized, for: .normal)
        }else{
            self.btnSave.setTitle("Register".localized, for: .normal)
        }
        txtCountry.text = "Greece".localized
        self.lblContrect.text = "I accept Terms and Conditions".localized
        self.btnTermsAndCondition.setTitle("Terms and Conditions".localized, for: .normal)
    }
    func prepareView(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Payments".localized, leftImage: NavItemsLeft.back.value, rightImages: isFromEdit ? [NavItemsRight.editPaymentDetails.value] : [NavItemsRight.none.value], isTranslucent: true)
        isProfileEdit(allow: !isFromEdit)
        btnSave.isHidden = isFromEdit
        self.setupUI()
        isFromEdit ? self.callPaymentDeatilAPI() : self.setRegData()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "EditPaymentsDetails"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "EditPaymentsDetails"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func ProfileEdit(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Payments".localized, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true)
        isProfileEdit(allow: true)
        btnSave.isHidden = false
    }
    
    func isProfileEdit(allow:Bool) {
        let arrayOfDisableElement = (redioBtnCash,redioBtnBank,redioBtnBoth,txtIBAN,txtAccountNumber,txtBankName)
        arrayOfDisableElement.0?.isUserInteractionEnabled = allow
        arrayOfDisableElement.1?.isUserInteractionEnabled = allow
        arrayOfDisableElement.2?.isUserInteractionEnabled = allow
        arrayOfDisableElement.3?.isUserInteractionEnabled = allow
        arrayOfDisableElement.4?.isUserInteractionEnabled = allow
        arrayOfDisableElement.5?.isUserInteractionEnabled = allow
    }
    
    func setupUI(){
        self.redioBtnBank.setTitle("", for: .normal)
        self.redioBtnCash.setTitle("", for: .normal)
        self.detailStackView.isHidden = true
        txtCountry.isUserInteractionEnabled = false
        // hide terms and condition
        self.viewBottum.isHidden = true
    }
    
    func setRegData(){
        self.selectedPaymentMode = SingletonClass.sharedInstance.RegisterData.Reg_payment_type
        if selectedPaymentMode != "0"{
            self.txtIBAN.text = SingletonClass.sharedInstance.RegisterData.Reg_payment_iban
            self.txtAccountNumber.text = SingletonClass.sharedInstance.RegisterData.Reg_payment_account_number
            self.txtBankName.text = SingletonClass.sharedInstance.RegisterData.Reg_payment_bank_name
//            self.txtCountry.text = SingletonClass.sharedInstance.RegisterData.Reg_payment_country
        }
        self.setRedioBtn(selectedPaymentMode)
    }
    
    func setRedioBtn(_ mode: String){
        ///o = case 1 = Bank 2 = Both
        self.selectedPaymentMode = mode
        self.redioBtnCash.isSelected = false
        self.redioBtnBank.isSelected = false
        self.redioBtnBoth.isSelected = false
        self.imgCash.image = UIImage(named: "ic_radio_unselected")
        self.imgBank.image = UIImage(named: "ic_radio_unselected")
        self.imgBoth.image = UIImage(named: "ic_radio_unselected")
        switch selectedPaymentMode{
        case "0":
            self.redioBtnCash.isSelected = true
            self.imgCash.image = UIImage(named: "ic_radio_selected")
            break
        case "1":
            self.redioBtnBank.isSelected = true
            self.imgBank.image = UIImage(named: "ic_radio_selected")
            break
        case "2":
            self.redioBtnBoth.isSelected = true
            self.imgBoth.image = UIImage(named: "ic_radio_selected")
            break
        default:
            self.redioBtnCash.isSelected = true
            self.imgCash.image = UIImage(named: "ic_radio_selected")
        }
        self.setView(view: detailStackView, hidden: self.redioBtnCash.isSelected)
    }
    
    func setupDataAfterAPI(){
        let paymentMode = self.paymentDetailData?.paymentType
        self.selectedPaymentMode = "\(self.paymentDetailData?.paymentType ?? 0)"
        setRedioBtn(self.selectedPaymentMode)
        self.txtIBAN.text = self.paymentDetailData?.paymentDetail?.iban ?? ""
        self.txtAccountNumber.text = self.paymentDetailData?.paymentDetail?.accountNumber ?? ""
        self.txtBankName.text = self.paymentDetailData?.paymentDetail?.bankName ?? ""
    }
    
    func setView(view: UIView, hidden: Bool) {
        view.alpha = hidden ? 0 : 1
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: { _ in
            view.alpha = 1
        })
    }
    
    func Validate() -> (Bool,String) {
//        if !btnCheckBox.isSelected && !isFromEdit{
//            return(false,"Accept Terms and Condition".localized)
//        }
        if(self.selectedPaymentMode != "0"){
            self.txtIBAN.text = self.txtIBAN.text?.trimmedString
            self.txtAccountNumber.text = self.txtAccountNumber.text?.trimmedString
            self.txtBankName.text = self.txtBankName.text?.trimmedString
            self.txtCountry.text = self.txtCountry.text?.trimmedString
            let checkIBAN = self.txtIBAN.validatedText(validationType: ValidatorType.requiredField(field: "IBAN"))
            let checkAccount = self.txtAccountNumber.validatedText(validationType: ValidatorType.requiredField(field: "acccount number"))
            let checkBank = self.txtBankName.validatedText(validationType: ValidatorType.requiredField(field: "bank name"))
            let checkCountry = self.txtCountry.validatedText(validationType: ValidatorType.requiredField(field: "country"))
            if (!checkIBAN.0){
                return (checkIBAN.0,checkIBAN.1)
            }else if (!checkAccount.0){
                return (checkAccount.0,checkAccount.1)
            }else if (!checkBank.0){
                return (checkBank.0,checkBank.1)
            }else if (!checkCountry.0){
                return (checkCountry.0,checkCountry.1)
            }
        }
        return (true,"")
    }
    
    func checkChanges() -> Bool{
        if self.selectedPaymentMode != "\(self.paymentDetailData?.paymentType ?? 0)" {
            return true
        }
        if selectedPaymentMode != "0"{
            if self.txtIBAN.text != self.paymentDetailData?.paymentDetail?.iban ?? ""{
                return true
            }else if self.txtAccountNumber.text != self.paymentDetailData?.paymentDetail?.accountNumber ?? ""{
                return true
            }else if self.txtBankName.text != self.paymentDetailData?.paymentDetail?.bankName ?? ""{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    private func popBack(){
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            Utilities.ShowAlertOfSuccess(OfMessage: "profileUpdateSucces".localized)
        })
    }
    
    func saveData(){
        SingletonClass.sharedInstance.RegisterData.Reg_payment_type = self.selectedPaymentMode
        SingletonClass.sharedInstance.RegisterData.Reg_payment_iban = self.txtIBAN.text ?? ""
        SingletonClass.sharedInstance.RegisterData.Reg_payment_account_number = self.txtAccountNumber.text ?? ""
        SingletonClass.sharedInstance.RegisterData.Reg_payment_bank_name = self.txtBankName.text ?? ""
        SingletonClass.sharedInstance.RegisterData.Reg_payment_country = self.txtCountry.text ?? ""
        UserDefault.SetRegiterData()
        UserDefault.setValue(4, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
        UserDefault.synchronize()
        self.Register()
    }
    
    func previewDocument(strURL : String){
        guard let url = URL(string: strURL) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    func Register() {
        self.registerViewModel.paymentsVC = self
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonString = try! encoder.encode(SingletonClass.sharedInstance.RegisterData.Reg_truck_data)
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
        registerReqModel.licenseBack  = SingletonClass.sharedInstance.RegisterData.Reg_licenseBack.map({$0}).joined(separator: ",")
        registerReqModel.license_number  = SingletonClass.sharedInstance.RegisterData.Reg_license_number
        registerReqModel.license_expiry_date  = SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date.ConvertDateFormat(FromFormat: "dd-MM-yyyy", ToFormat: "yyyy-MM-dd")
        registerReqModel.truck_details = finalJson
        self.registerViewModel.WebServiceForRegister(ReqModel: registerReqModel)
    }
    
    @IBAction func btnTermsAndConditionClicked(_ sender: Any) {
        btnCheckBox.isSelected = !btnCheckBox.isSelected
    }
    
    // MARK: - IBaAtion methods
    @IBAction func btnCashAction(_ sender: Any) {
        self.setRedioBtn("0")
    }
    
    @IBAction func btnBnakAction(_ sender: Any) {
        self.setRedioBtn("1")
    }
    
    @IBAction func btnBothAction(_ sender: Any) {
        self.setRedioBtn("2")
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            if isFromEdit {
                if checkChanges(){
                    self.callPaymentDetailUpdateAPI()
                }else{
                    self.popBack()
                }
            }else{
                self.saveData()
            }
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
    
    @IBAction func btnViewTermsAdnConditionClick(_ sender: Any) {
        let Link = SingletonClass.sharedInstance.initResModel?.termsAndCondition ?? ""
        self.previewDocument(strURL: Link)
    }
}

//MARK: - API callskk
extension PaymentsVC{
    func callPaymentDeatilAPI() {
        self.paymentViewModel.VC =  self
        self.paymentViewModel.WebServiceForPaymentDeatilList()
    }
    
    func callPaymentDetailUpdateAPI() {
        self.paymentViewModel.VC =  self
        let reqModel = PaymentDetailUpdateReqModel()
        reqModel.payment_type = selectedPaymentMode
        if selectedPaymentMode != "0"{
            reqModel.iban = txtIBAN.text
            reqModel.account_number = txtAccountNumber.text
            reqModel.bank_name = txtBankName.text
        }else{
            reqModel.iban = ""
            reqModel.account_number = ""
            reqModel.bank_name = ""
        }
        reqModel.country = txtCountry.text
        self.paymentViewModel.WebServiceForPaymentDeatilUpdate(ReqModel: reqModel)
    }
}
