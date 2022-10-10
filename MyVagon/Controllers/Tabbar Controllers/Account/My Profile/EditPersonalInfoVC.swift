//
//  EditPersonalInfoVC.swift
//  MyVagon
//
//  Created by Harshit K on 15/03/22.
//

import UIKit
import SDWebImage

class EditPersonalInfoVC: BaseViewController {

    //MARK: - Propertise
    @IBOutlet weak var ImageViewProfile: UIImageView!
    @IBOutlet weak var TextFieldFullName: themeTextfield!
    @IBOutlet weak var TextFieldMobileNumber: themeTextfield!
    @IBOutlet weak var TextFieldCountryCode: themeTextfield!
    @IBOutlet weak var btnProfieImage: UIButton!
    @IBOutlet weak var btnSave: themeButton!
    @IBOutlet weak var imgAddIcon: UIImageView!
    @IBOutlet weak var txtEmail: themeTextfield!
    @IBOutlet weak var lblTitle: themeLabel!
    @IBOutlet weak var btnVarifyNumber: UIButton!
    
    var CountryCodeArray: [String] = ["+30"]
    let GeneralPicker = GeneralPickerView()
    var editPersonalInfoModel = EditPersonalInfoModel()
    var profileImage = ""
    var Iseditable = false
    var IsPhoneVerify = true
    var verifiedPhone = ""
    var editPersonViewModel = EditPersonViewModel()
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom method
    func setUI(){
        self.TextFieldCountryCode.delegate = self
        self.addObserver()
        self.SetValue()
        self.setupDelegateForPickerView()
    }
    
    func addObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "EditPersonalInfo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "EditPersonalInfo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.txtEmail.placeholder = "Email".localized
        self.TextFieldFullName.placeholder = "FullName".localized
        self.TextFieldMobileNumber.placeholder = "MobileNumber".localized
        self.btnSave.setTitle("Save".localized, for: .normal)
        self.btnVarifyNumber.setImage(UIImage(named: "Verified"), for: .selected)
        self.btnVarifyNumber.setImage(UIImage(named: "Verify"), for: .normal)
    }
    
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        GeneralPicker.generalPickerDelegate = self
    }
    
    @objc func ProfileEdit(){
        Iseditable = true
        SetValue()
       }
    
    func SetValue() {
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: Iseditable ? "Edit Personal Info".localized : "Personal Info".localized, leftImage: NavItemsLeft.back.value, rightImages: Iseditable ? [NavItemsRight.none.value] : [NavItemsRight.editPersonalInfo.value], isTranslucent: true)
        self.isProfileEdit(allow: Iseditable)
        self.btnSave.isHidden = !Iseditable
        self.imgAddIcon.isHidden = !Iseditable
        self.lblTitle.text = Iseditable ? "Upload Profile Picture".localized : "Profile Picture".localized
        if (SingletonClass.sharedInstance.UserProfileData?.profile ?? "") == ""{
            let char = SingletonClass.sharedInstance.UserProfileData?.name?.first?.description
            if char != ""{
                self.ImageViewProfile.addInitials(first: char ?? "")
            }
        }else{
            self.profileImage = (SingletonClass.sharedInstance.UserProfileData?.profile ?? "")
            let StringURLForProfile = "\(APIEnvironment.DriverImageURL)\(SingletonClass.sharedInstance.UserProfileData?.profile ?? "")"
            self.ImageViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.ImageViewProfile.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
        }
        self.TextFieldFullName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
        self.TextFieldMobileNumber.text = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
        self.verifiedPhone = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
        self.btnVarifyNumber.isSelected = true
        self.TextFieldMobileNumber.delegate = self
        self.txtEmail.text = SingletonClass.sharedInstance.UserProfileData?.email ?? ""
        if SingletonClass.sharedInstance.RegisterData.Reg_country_code != "" {
            self.TextFieldCountryCode.text = SingletonClass.sharedInstance.RegisterData.Reg_country_code
        } else {
            self.TextFieldCountryCode.text = self.CountryCodeArray.first
        }
    }
    
    func isProfileEdit(allow:Bool) {
        self.TextFieldFullName.isUserInteractionEnabled = allow
        self.TextFieldMobileNumber.isUserInteractionEnabled = allow
        self.TextFieldCountryCode.isUserInteractionEnabled = allow
        self.ImageViewProfile.isUserInteractionEnabled = allow
        self.btnProfieImage.isUserInteractionEnabled = allow
        self.btnSave.isUserInteractionEnabled = allow
    }
    
    func PhoneVerify() {
        self.editPersonViewModel.editPersonalInfoVC = self
        let ReqModelForMobileVerify = MobileVerifyReqModel()
        ReqModelForMobileVerify.mobile_number = "\(TextFieldCountryCode.text ?? "")\(TextFieldMobileNumber.text ?? "")"
        self.editPersonViewModel.VerifyPhone(ReqModel: ReqModelForMobileVerify)
    }
    
    func checkChanges() -> Bool{
        if (SingletonClass.sharedInstance.UserProfileData?.profile ?? "") != profileImage{
            return true
        }else if TextFieldFullName.text != SingletonClass.sharedInstance.UserProfileData?.name ?? ""{
            return true
        }else if TextFieldMobileNumber.text != SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""{
            return true
        }else if txtEmail.text != SingletonClass.sharedInstance.UserProfileData?.email ?? ""{
            return true
        }else{
            return false
        }
    }
    
    func Validate() -> (Bool,String) {
        let checkFullName = TextFieldFullName.validatedText(validationType: ValidatorType.username(field: "FullName",MaxChar: 70))
        let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 15))
        if (!checkFullName.0){
            return (checkFullName.0,checkFullName.1)
        }else if (!checkMobileNumber.0){
            return (checkMobileNumber.0,checkMobileNumber.1)
        }else if ImageViewProfile.image == nil {
            return (false,"Please attach profile image".localized)
        }else if !btnVarifyNumber.isSelected{
            return (false,"Error_VerifyMobile".localized)
        }
        return (true,"")
    }
    
    private func popBack(){
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            Utilities.ShowAlertOfSuccess(OfMessage: "profileUpdateSucces".localized)
        })
    }
    
    //MARK: - IBAction method
    @IBAction func btnVarifyClick(_ sender: UIButton) {
        if !sender.isSelected {
            let checkMobileNumber = TextFieldMobileNumber.validatedText(validationType: ValidatorType.phoneNo(MinDigit: 10, MaxDigit: 10))
            if (!checkMobileNumber.0){
                Utilities.ShowAlertOfInfo(OfMessage: checkMobileNumber.1)
            } else {
                PhoneVerify()
            }
        }
    }
    
    @IBAction func btnProfileClick(_ sender: UIButton){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            for i in self.ImageViewProfile.subviews{
                i.removeFromSuperview()
            }
            self.ImageViewProfile.contentMode = .scaleAspectFill
            self.ImageUploadAPI(arrImages: [image], documentType: .Profile)
        }
    }
    
    @IBAction func btnUpdateClick(_ sender: UIButton){
        let CheckValidation = Validate()
        if CheckValidation.0 {
            if checkChanges(){
                callEditPersonalInfoUpdateAPI()
            }else{
                self.popBack()
            }
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
    }
}

//MARK: - TextField delegate
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == TextFieldMobileNumber{
            if textField.text == verifiedPhone{
                btnVarifyNumber.isSelected = true
            }else{
                btnVarifyNumber.isSelected = false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.TextFieldMobileNumber{
            let CheckWritting =  textField.StopWrittingAtCharactorLimit(CharLimit: 10, range: range, string: string)
            return CheckWritting
        }
        return true
    }
}

//MARK: - GeneralPickerViewDelegate Methods
extension EditPersonalInfoVC: GeneralPickerViewDelegate {
    
    func didTapDone() {
        let item = CountryCodeArray[GeneralPicker.selectedRow(inComponent: 0)]
        self.TextFieldCountryCode.text = item
        self.TextFieldCountryCode.resignFirstResponder()
    }
    
    func didTapCancel() {}
}

//MARK: - UIPickerViewDelegate Methods
extension EditPersonalInfoVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
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

//MARK: - WebService method
extension EditPersonalInfoVC{
    
    func callEditPersonalInfoUpdateAPI() {
        self.editPersonalInfoModel.VC =  self
        let reqModel = EditPersonalInfoReqModel()
        reqModel.full_name = TextFieldFullName.text
        reqModel.country_code = TextFieldCountryCode.text
        reqModel.mobile_number = TextFieldMobileNumber.text
        reqModel.profile_image = profileImage
        self.editPersonalInfoModel.WebServiceForPersonalInfoUpdate(ReqModel: reqModel)
    }
    
    func ImageUploadAPI(arrImages:[UIImage],documentType:DocumentType) {
        self.editPersonalInfoModel.VC = self
        self.editPersonalInfoModel.WebServiceImageUpload(images: arrImages, uploadFor: documentType)
    }
}

