//
//  BidNowPopupViewController.swift
//  MyVagon
//
//  Created by Apple on 30/09/21.
//

import UIKit

class ConfirmBidPopupVC: UIViewController {
  
    //MARK: - Propertise
    @IBOutlet weak var MainView: ViewCustomClass!
    @IBOutlet weak var LblTitle: themeLabel!
    @IBOutlet weak var LblDescripiton: themeLabel!
    @IBOutlet weak var BtnLeft: themeButton!
    @IBOutlet weak var BtnRight: themeButton!
    @IBOutlet weak var bidTextField: themeTextfield!
    
    var bidNowViewModel = BidNowViewModel()
    var MinimumBidAmount = ""
    var BookingId = ""
    var AvailabilityId = ""
    var LeftbtnTitle : String?
    var RightBtnTitle : String?
    var IsHideImage : Bool = true
    var ShownImage : UIImage?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetValue()
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    // MARK: - Custom methods
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.LblDescripiton.text = "Bidding starting price".localized
        self.bidTextField.placeholder = "Enter your bid".localized
    }
    
    func setUI(){
        self.bidTextField?.delegate = self
        bidTextField.layer.cornerRadius = 13
        bidTextField.layer.borderColor = UIColor(hexString: "#9B51E0").cgColor
        if (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0) == 1{
            LblTitle.isHidden = false
            LblDescripiton.isHidden = false
        }else{
            LblTitle.isHidden = true
            LblDescripiton.isHidden = true
        }
    }
    
    func SetValue() {
        LblTitle.text = Currency + MinimumBidAmount
        UIView.performWithoutAnimation {
            BtnLeft.setTitle("Cancel".localized, for: .normal)
            BtnRight.setTitle("Bid".localized, for: .normal)
            self.BtnLeft.layoutIfNeeded()
            self.BtnRight.layoutIfNeeded()
        }
    }
   
    // MARK: - IBAction methods
    @IBAction func btnCancle(_ sender: themeButton) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBidPost(_ sender: themeButton) {
        if bidTextField.text != ""{
            BidPost()
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: "Please enter bid".localized)
        }
    }
}

// MARK: - Webservice methods
extension ConfirmBidPopupVC{
    func BidPost() {
        self.bidNowViewModel.bidNowPopupViewController = self
        let reqModel = BidReqModel()
        reqModel.booking_id = BookingId
        reqModel.amount = (bidTextField.text ?? "")
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.availability_id = AvailabilityId
        self.bidNowViewModel.WebServiceBidPost(ReqModel: reqModel)
    }
}

extension ConfirmBidPopupVC : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if textField == bidTextField{
                 if textField.text?.count ?? 0 > 10{
                     var text = textField.text ?? ""
                     text.removeLast()
                     textField.text = text
                 }
         }
    }
}
