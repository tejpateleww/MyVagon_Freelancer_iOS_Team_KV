//
//  Payments.swift
//  MyVagon
//
//  Created by Dhanajay  on 21/02/22.
//

import UIKit

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
    
    var selectedPaymentMode = "0"
    var paymentViewModel = PaymentViewModel()
    var paymentDetailData : PaymentDetailData?
    var isFromEdit = false
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    // MARK: - Custome methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Payments", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.redioBtnBank.setTitle("", for: .normal)
        self.redioBtnCash.setTitle("", for: .normal)
        self.detailStackView.isHidden = true
        txtCountry.text = "Greece"
        txtCountry.isUserInteractionEnabled = false
    }
    
    func setupData(){
        self.callPaymentDeatilAPI()
    }
    
    func setupDataAfterAPI(){
        let paymentMode = self.paymentDetailData?.paymentType
        self.selectedPaymentMode = "\(self.paymentDetailData?.paymentType ?? 0)"
        if(paymentMode == 0){
            self.selecCash()
        }else if(paymentMode == 1){
            self.selecBank()
        }else{
            self.selecBoth()
        }
        self.txtIBAN.text = self.paymentDetailData?.paymentDetail?.iban ?? ""
        self.txtAccountNumber.text = self.paymentDetailData?.paymentDetail?.accountNumber ?? ""
        self.txtBankName.text = self.paymentDetailData?.paymentDetail?.bankName ?? ""
    }
    
    func selecCash() {
        self.selectedPaymentMode = "0"
        self.redioBtnCash.isSelected = true
        self.redioBtnBank.isSelected = false
        self.redioBtnBoth.isSelected = false
        self.setView(view: detailStackView, hidden: true)
        self.setupImage()
    }
    
    func selecBank() {
        self.selectedPaymentMode = "1"
        self.redioBtnCash.isSelected = false
        self.redioBtnBank.isSelected = true
        self.redioBtnBoth.isSelected = false
        self.setView(view: detailStackView, hidden: false)
        self.setupImage()
    }
    
    func selecBoth() {
        self.selectedPaymentMode = "2"
        self.redioBtnCash.isSelected = false
        self.redioBtnBank.isSelected = false
        self.redioBtnBoth.isSelected = true
        self.setView(view: detailStackView, hidden: false)
        self.setupImage()
    }
    
    func setView(view: UIView, hidden: Bool) {
        view.alpha = hidden ? 0 : 1
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: { _ in
            view.alpha = 1
        })
    }
    
    func setupImage() {
        if(self.redioBtnCash.isSelected){
            self.imgCash.image = UIImage(named: "ic_radio_selected")
        }else{
            self.imgCash.image = UIImage(named: "ic_radio_unselected")
        }
        
        if(self.redioBtnBank.isSelected){
            self.imgBank.image = UIImage(named: "ic_radio_selected")
        }else{
            self.imgBank.image = UIImage(named: "ic_radio_unselected")
        }
        
        if(self.redioBtnBoth.isSelected){
            self.imgBoth.image = UIImage(named: "ic_radio_selected")
        }else{
            self.imgBoth.image = UIImage(named: "ic_radio_unselected")
        }
    }
    
    func Validate() -> (Bool,String) {
        
        if(self.selectedPaymentMode != "0"){
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

    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIButton action methods
    @IBAction func btnCashAction(_ sender: Any) {
        self.selecCash()
    }
    
    @IBAction func btnBnakAction(_ sender: Any) {
        self.selecBank()
    }
    
    @IBAction func btnBothAction(_ sender: Any) {
        self.selecBoth()
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            if isFromEdit {
                self.callPaymentDetailUpdateAPI()
            }else{
                SingletonClass.sharedInstance.RegisterData.Reg_payment_type = self.selectedPaymentMode
                SingletonClass.sharedInstance.RegisterData.Reg_payment_iban = self.txtIBAN.text ?? ""
                SingletonClass.sharedInstance.RegisterData.Reg_payment_account_number = self.txtAccountNumber.text ?? ""
                SingletonClass.sharedInstance.RegisterData.Reg_payment_bank_name = self.txtBankName.text ?? ""
                SingletonClass.sharedInstance.RegisterData.Reg_payment_country = self.txtCountry.text ?? ""
                
                UserDefault.SetRegiterData()
                UserDefault.setValue(4, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
                UserDefault.synchronize()
                
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 5
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            }
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
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
        reqModel.iban = txtIBAN.text
        reqModel.account_number = txtAccountNumber.text
        reqModel.bank_name = txtBankName.text
        reqModel.country = txtCountry.text
        self.paymentViewModel.WebServiceForPaymentDeatilUpdate(ReqModel: reqModel)
    }
}
