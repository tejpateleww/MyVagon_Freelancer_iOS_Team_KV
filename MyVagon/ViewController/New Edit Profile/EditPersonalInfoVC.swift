//
//  EditPersonalInfoVC.swift
//  MyVagon
//
//  Created by Harshit K on 15/03/22.
//

import UIKit
import SDWebImage

class EditPersonalInfoVC: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var ImageViewProfile: UIImageView!
    @IBOutlet weak var TextFieldFullName: themeTextfield!
    @IBOutlet weak var TextFieldMobileNumber: themeTextfield!
    @IBOutlet weak var TextFieldCountryCode: themeTextfield!
    @IBOutlet weak var btnProfieImage: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgAddIcon: UIImageView!
    @IBOutlet weak var txtEmail: themeTextfield!
    
    var CountryCodeArray: [String] = ["+30"]
    let GeneralPicker = GeneralPickerView()
    var editPersonalInfoModel = EditPersonalInfoModel()
    var profileImage : [String] = []
    var Iseditable = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TextFieldCountryCode.delegate = self
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "EditPersonalInfo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "EditPersonalInfo"), object: nil)
        
        //setUpUI()
        SetValue()
        setupDelegateForPickerView()
    }
    
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        GeneralPicker.generalPickerDelegate = self
    }
    
//    func setUpUI(){
//        self.view.isUserInteractionEnabled = false
//
//    }
    @objc func ProfileEdit(){
        Iseditable = true
        SetValue()
       }
    func SetValue() {
        if Iseditable {
            self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Edit Personal Info", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true)
        } else {
            self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Edit Personal Info", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.editPersonalInfo.value], isTranslucent: true)
        }
        if Iseditable{
            isProfileEdit(allow: true)
            btnSave.isHidden = false
            imgAddIcon.isHidden = false
        }else{
            isProfileEdit(allow: false)
            btnSave.isHidden = true
            imgAddIcon.isHidden = true
        }
        let StringURLForProfile = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.profile ?? "")"
        
        ImageViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        ImageViewProfile.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
        TextFieldFullName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
        
        TextFieldMobileNumber.text = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
        txtEmail.text = SingletonClass.sharedInstance.UserProfileData?.email ?? ""
        if SingletonClass.sharedInstance.RegisterData.Reg_country_code != "" {
            self.TextFieldCountryCode.text = SingletonClass.sharedInstance.RegisterData.Reg_country_code
        } else {
            self.TextFieldCountryCode.text = self.CountryCodeArray.first
        }
    }
    
    func isProfileEdit(allow:Bool) {
        let arrayOfDisableElement = (TextFieldFullName,TextFieldMobileNumber,TextFieldCountryCode,ImageViewProfile,btnProfieImage,btnSave)
        arrayOfDisableElement.0?.isUserInteractionEnabled = allow
        arrayOfDisableElement.1?.isUserInteractionEnabled = allow
        arrayOfDisableElement.2?.isUserInteractionEnabled = allow
        arrayOfDisableElement.3?.isUserInteractionEnabled = allow
        arrayOfDisableElement.4?.isUserInteractionEnabled = allow
        arrayOfDisableElement.5?.isUserInteractionEnabled = allow

    }
    
    
    @IBAction func btnProfileClick(_ sender: UIButton)
    {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.ImageViewProfile.image = image
            print(image)
            self.ImageUploadAPI(arrImages: [image], documentType: .Profile)
        }
    }
    @IBAction func btnUpdateClick(_ sender: UIButton)
    {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            callEditPersonalInfoUpdateAPI()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
    }
    
    func Validate() -> (Bool,String) {
        let checkFullName = TextFieldFullName.validatedText(validationType: ValidatorType.username(field: "full name",MaxChar: 70))
        let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 15))
        
        if (!checkFullName.0){
            return (checkFullName.0,checkFullName.1)
        }else if (!checkMobileNumber.0){
            return (checkMobileNumber.0,checkMobileNumber.1)
        }else if ImageViewProfile.image == nil {
            return (false,"Please attach profile image")
        }
        
        return (true,"")
    }
    
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func ImageUploadAPI(arrImages:[UIImage],documentType:DocumentType) {
        self.editPersonalInfoModel.VC = self
        
        self.editPersonalInfoModel.WebServiceImageUpload(images: arrImages, uploadFor: documentType)
      
    }
    
}

extension EditPersonalInfoVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TextFieldCountryCode {
            TextFieldCountryCode.inputView = GeneralPicker
            TextFieldCountryCode.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = CountryCodeArray.first(where: {$0 == TextFieldCountryCode.text ?? ""}) {
                let indexOfA = CountryCodeArray.firstIndex(of: DummyFirst) ?? 0
                GeneralPicker.selectRow(indexOfA, inComponent: 0, animated: false)
                self.GeneralPicker.reloadAllComponents()
            }
        }
    }
}

//MARK: - GeneralPickerViewDelegate Methods
extension EditPersonalInfoVC: GeneralPickerViewDelegate {
    
    func didTapDone() {
        let item = CountryCodeArray[GeneralPicker.selectedRow(inComponent: 0)]
        self.TextFieldCountryCode.text = item
        self.TextFieldCountryCode.resignFirstResponder()
    }
    
    func didTapCancel() {
    }
}

//MARK: - UIPickerViewDelegate Methods
extension EditPersonalInfoVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryCodeArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountryCodeArray[row]
    }
}

//MARK: - API callskk
extension EditPersonalInfoVC{
    func callPaymentDeatilAPI() {
//        self.paymentViewModel.VC =  self
//        self.paymentViewModel.WebServiceForPaymentDeatilList()
    }
    
    func callEditPersonalInfoUpdateAPI() {
        self.editPersonalInfoModel.VC =  self
        let reqModel = EditPersonalInfoReqModel()
        reqModel.full_name = TextFieldFullName.text
        reqModel.country_code = TextFieldCountryCode.text
        reqModel.mobile_number = TextFieldMobileNumber.text
        reqModel.profile_image = profileImage.first
        
        self.editPersonalInfoModel.WebServiceForPersonalInfoUpdate(ReqModel: reqModel)
    }
}
