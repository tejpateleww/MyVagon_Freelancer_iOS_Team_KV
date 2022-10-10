//
//  IdentifyYourselfVC.swift
//  MyVagon
//
//  Created by MacMini on 26/07/21.
//

import UIKit
import MobileCoreServices
import SDWebImage
class IdentifyYourselfVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var personIV: UIImageView!
    @IBOutlet weak var loremLabel: themeLabel!
    @IBOutlet weak var lblidentify: themeLabel!
    @IBOutlet weak var lblIdentifyProof: themeLabel!
    @IBOutlet weak var lblLicense: themeLabel!
    @IBOutlet weak var lblLicenseBAck: themeLabel!
    @IBOutlet weak var widthConstrantIdentify: NSLayoutConstraint!
    @IBOutlet weak var NextButton: themeButton!
    @IBOutlet weak var ImageViewIdentity: UIImageView!
    @IBOutlet weak var ImageViewLicence: UIImageView!
    @IBOutlet weak var imageLicenceBack: UIImageView!
    @IBOutlet weak var stackIdentify: UIStackView!
    @IBOutlet weak var TextFieldLicenseNumber: themeTextfield!
    @IBOutlet weak var TextFieldLicenseExpiryDate: themeTextfield!
    @IBOutlet weak var btnLicenceFront: UIButton!
    @IBOutlet weak var btnIdProof: UIButton!
    @IBOutlet weak var btnLicenseBack: UIButton!
    @IBOutlet weak var heightConstrintNextBtn: NSLayoutConstraint!
    
    var SelectedDocumentRow = 0
    var identifyYourselfViewModel = IdentifyYourselfViewModel()
    var isFromEdit = false
    var isEditEnable = true
    var idProofImage = ""
    var licenceImage = ""
    var licenceBackImag = ""
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue()
        self.isEditEnable = !isFromEdit
        self.setUpNevigetionBar()
        self.enableEdit()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "editprofile"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.widthConstrantIdentify.constant = (stackIdentify.frame.width / 2) - 17
    }
    
    // MARK: - Custom methods
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    @objc func ProfileEdit(){
        self.isEditEnable = true
        self.enableEdit()
        self.setUpNevigetionBar()
    }
    
    func setLocalization(){
        TextFieldLicenseExpiryDate.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .date, MinDate: true, MaxDate: false)
        self.lblIdentifyProof.text = "Identity Proof Document".localized
        self.lblLicense.text = "License Front".localized
        self.lblLicenseBAck.text = "License Back".localized
        self.TextFieldLicenseNumber.placeholder = "Enter license number".localized
        self.TextFieldLicenseExpiryDate.placeholder = "Enter license expiry date".localized
        NextButton.setTitle("Next".localized, for: .normal)
        self.NextButton.setTitle((isFromEdit) ? "Save".localized : "Next".localized, for: .normal)
        self.lblidentify.text = isEditEnable ? "Identify Yourself".localized : "Identity".localized
    }
    
    func setUpNevigetionBar(){
        if isFromEdit{
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: isEditEnable ? "Edit License Detail".localized : "Licence Details".localized, leftImage: NavItemsLeft.back.value, rightImages: isEditEnable ? [] :  [NavItemsRight.editProfile.value], isTranslucent: true, ShowShadow: true)
        }else{
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Licence Details".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        }
    }
    
    func setValue() {
        if isFromEdit ? (SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? "") != "" : SingletonClass.sharedInstance.RegisterData.Reg_license.count != 0 {
            self.licenceImage = isFromEdit ? SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? "" : SingletonClass.sharedInstance.RegisterData.Reg_license[0]
            let strUrl = isFromEdit ? "\(APIEnvironment.DriverImageURL)\(licenceImage)" : "\(APIEnvironment.tempURL)\(licenceImage)"
            ImageViewLicence.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewLicence.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        if isFromEdit ? (SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? "") != "" : SingletonClass.sharedInstance.RegisterData.Reg_id_proof.count != 0 {
            self.idProofImage = isFromEdit ? SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? "" : SingletonClass.sharedInstance.RegisterData.Reg_id_proof[0]
            let strUrl = isFromEdit ? "\(APIEnvironment.DriverImageURL)\(idProofImage)" : "\(APIEnvironment.tempURL)\(idProofImage)"
            ImageViewIdentity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewIdentity.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        if isFromEdit ? (SingletonClass.sharedInstance.UserProfileData?.vehicle?.licenseBack ?? "") != "" : SingletonClass.sharedInstance.RegisterData.Reg_licenseBack.count != 0 {
            self.licenceBackImag = isFromEdit ? SingletonClass.sharedInstance.UserProfileData?.vehicle?.licenseBack ?? "" : SingletonClass.sharedInstance.RegisterData.Reg_licenseBack[0]
            let strUrl = isFromEdit ? "\(APIEnvironment.DriverImageURL)\(licenceBackImag)" : "\(APIEnvironment.tempURL)\(licenceBackImag)"
            imageLicenceBack.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageLicenceBack.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        TextFieldLicenseNumber.text = isFromEdit ? SingletonClass.sharedInstance.UserProfileData?.licenceNumber : SingletonClass.sharedInstance.RegisterData.Reg_license_number
        TextFieldLicenseExpiryDate.text = isFromEdit ? SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate : SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date
    }
    
    func enableEdit(){
        self.btnIdProof.isUserInteractionEnabled = isEditEnable
        self.btnLicenceFront.isUserInteractionEnabled = isEditEnable
        self.btnLicenseBack.isUserInteractionEnabled = isEditEnable
        self.TextFieldLicenseNumber.isUserInteractionEnabled = isEditEnable
        self.TextFieldLicenseExpiryDate.isUserInteractionEnabled = isEditEnable
        self.heightConstrintNextBtn.constant = isEditEnable ? 50 : 0
    }
    
    @objc func btnDoneDatePickerClicked() {
        if let datePicker = self.TextFieldLicenseExpiryDate.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatterString.onlyDate.rawValue
            TextFieldLicenseExpiryDate.text = formatter.string(from: datePicker.date)
        }
        self.TextFieldLicenseExpiryDate.resignFirstResponder() // 2-5
    }
    
    func Validate() -> (Bool,String) {
        self.TextFieldLicenseNumber.text = self.TextFieldLicenseNumber.text?.trimmedString
        let checkLicenseNumber = TextFieldLicenseNumber.validatedText(validationType: ValidatorType.requiredField(field: "license number".localized))
        let checkLicenseExpiryDate = TextFieldLicenseExpiryDate.validatedText(validationType: ValidatorType.requiredField(field: "license expiry date"))
        if (!checkLicenseNumber.0){
            return (checkLicenseNumber.0,checkLicenseNumber.1)
        }else if (!checkLicenseExpiryDate.0){
            return (checkLicenseExpiryDate.0,"Please_select_license_expiry_date".localized)
        }else if licenceImage == "" {
            return (false,"Please_attach_license_front_image".localized)
        }else if licenceBackImag == ""{
            return (false,"Please_upload_drivers_license_back".localized)
        }else if idProofImage == "" {
            return (false,"Please attach id proof document".localized)
        }
        return (true,"")
    }
    
    func checkChange() -> Bool{
        if self.licenceImage != SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? "" {
            return true
        }else if self.idProofImage != SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? ""{
            return true
        }else if self.licenceBackImag != SingletonClass.sharedInstance.UserProfileData?.vehicle?.licenseBack ?? ""{
            return true
        }else if TextFieldLicenseNumber.text != SingletonClass.sharedInstance.UserProfileData?.licenceNumber{
            return true
        }else if TextFieldLicenseExpiryDate.text != SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate{
            return true
        }else{
            return false
        }
    }
    
    func saveData(){
        SingletonClass.sharedInstance.RegisterData.Reg_license_number = TextFieldLicenseNumber.text ?? ""
        SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date = TextFieldLicenseExpiryDate.text ?? ""
        SingletonClass.sharedInstance.RegisterData.Reg_id_proof = [idProofImage]
        SingletonClass.sharedInstance.RegisterData.Reg_license = [licenceImage]
        SingletonClass.sharedInstance.RegisterData.Reg_licenseBack = [licenceBackImag]
        UserDefault.SetRegiterData()
        UserDefault.setValue(3, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
        UserDefault.synchronize()
        let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
        let x = self.view.frame.size.width * 4
        RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        RegisterMainVC.viewDidLayoutSubviews()
    }
    
    private func popBack(){
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            Utilities.ShowAlertOfSuccess(OfMessage: "profileUpdateSucces".localized)
        })
    }
    
    func setImage(_ documentType: DocumentType){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            switch documentType{
            case .IdentityProof:
                self.ImageViewIdentity.image = image
            case .Licence:
                self.ImageViewLicence.image = image
            case .LicenceBack:
                self.imageLicenceBack.image = image
            default:
                break
            }
            self.ImageUploadAPI(arrImages: [image], documentType: documentType)
        }
    }
    
    // MARK: - IBAction methods
    
    @IBAction func btnIdentityClick(_ sender: UIButton) {
        self.setImage(.IdentityProof)
    }
    
    @IBAction func btnLicenceClick(_ sender: UIButton) {
        self.setImage(.Licence)
    }
    
    @IBAction func btnLicenceBackClick(_ sender: UIButton) {
        self.setImage(.LicenceBack)
    }
    
    @IBAction func NextButtonPress(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            if isFromEdit{
                if checkChange(){
                    callLicenceDetailUpdateAPI()
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
    
}

//MARK: - TextField delegate
extension IdentifyYourselfVC: UITextFieldDelegate,UIDocumentPickerDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

//MARK: - web servise
extension IdentifyYourselfVC{
    func UploadDocument(PathURL:URL,DocType:DocumentType) {
        var UploadFiles : [UploadMediaModel] = []
        UploadFiles.append(UploadMediaModel(mediaType: .File, forKey: "images[]", withImage: nil, fileUrl: PathURL)!)
        self.identifyYourselfViewModel.identifyYourselfVC = self
    }
    
    func ImageUploadAPI(arrImages:[UIImage],documentType:DocumentType) {
        self.identifyYourselfViewModel.identifyYourselfVC = self
        self.identifyYourselfViewModel.WebServiceImageUpload(images: arrImages, uploadFor: documentType)
    }
    
    func callLicenceDetailUpdateAPI() {
        self.identifyYourselfViewModel.identifyYourselfVC = self
        let reqModel = EditLicenceDetailsReqModel()
        reqModel.eu_registration_document = idProofImage
        reqModel.license_image = licenceImage
        reqModel.license_expiry_date = TextFieldLicenseExpiryDate.text
        reqModel.license_number = TextFieldLicenseNumber.text
        reqModel.licenseBack = licenceBackImag
        self.identifyYourselfViewModel.WebServiceForLicenceDeatilUpdate(ReqModel: reqModel)
    }
}
