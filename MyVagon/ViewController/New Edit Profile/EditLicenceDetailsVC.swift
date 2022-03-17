//
//  EditLicenceDetailsVC.swift
//  MyVagon
//
//  Created by Harshit K on 16/03/22.
//

import UIKit
import SDWebImage
import MobileCoreServices

class EditLicenceDetailsVC: BaseViewController, UITextFieldDelegate,UIDocumentPickerDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   var SelectedDocumentRow = 0
    var editLicenceDetailViewModel = EditLicenceDetailViewModel()
    var idProofImage = ""
    var licenceImage = ""
    var Iseditable = false
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var personIV: UIImageView!
    @IBOutlet weak var loremLabel: themeLabel!
  
  
    @IBOutlet weak var SaveButton: themeButton!
    @IBOutlet weak var btnIdentityProof: UIButton!
    @IBOutlet weak var btnLicence: UIButton!
    
    @IBOutlet weak var ImageViewIdentity: UIImageView!
    @IBOutlet weak var ImageViewLicence: UIImageView!
    
    @IBOutlet weak var TextFieldLicenseNumber: themeTextfield!
    @IBOutlet weak var TextFieldLicenseExpiryDate: themeTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextFieldLicenseExpiryDate.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .date, MinDate: true, MaxDate: false)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "EditLicenceDetails"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "EditLicenceDetails"), object: nil)
        prepareView()
        // Do any additional setup after loading the view.
    }
    
    func prepareView() {
        setValue()
        
        if Iseditable {
            self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Licence Details", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true)
        } else {
            self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Licence Details", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.editLicenceDetails.value], isTranslucent: true)
        }
        if Iseditable{
            isProfileEdit(allow: true)
            SaveButton.isHidden = false
        }else{
            isProfileEdit(allow: false)
            SaveButton.isHidden = true
        }
    }
    
    func setValue() {
        if SingletonClass.sharedInstance.UserProfileData?.vehicle?.license != "" {
            let strUrl = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? "")"
            print(strUrl)
            licenceImage = SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? ""
            ImageViewLicence.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewLicence.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        if SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof != "" {
            let strUrl = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? "")"
            idProofImage = SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? ""
            ImageViewIdentity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewIdentity.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        TextFieldLicenseNumber.text = SingletonClass.sharedInstance.UserProfileData?.licenceNumber
        TextFieldLicenseExpiryDate.text = SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        
    }
    @objc func btnDoneDatePickerClicked() {
        if let datePicker = self.TextFieldLicenseExpiryDate.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatterString.onlyDate.rawValue
            TextFieldLicenseExpiryDate.text = formatter.string(from: datePicker.date)
        }
        self.TextFieldLicenseExpiryDate.resignFirstResponder() // 2-5
    }
    
    @objc func ProfileEdit(){
        Iseditable = true
        prepareView()
       }
    func isProfileEdit(allow:Bool) {
        let arrayOfDisableElement = (btnIdentityProof,btnLicence,TextFieldLicenseNumber,TextFieldLicenseExpiryDate)
        arrayOfDisableElement.0?.isUserInteractionEnabled = allow
        arrayOfDisableElement.1?.isUserInteractionEnabled = allow
        arrayOfDisableElement.2?.isUserInteractionEnabled = allow
        arrayOfDisableElement.3?.isUserInteractionEnabled = allow

    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    @IBAction func btnIdentityClick(_ sender: themeButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.ImageViewIdentity.image = image
            print(image)
            self.ImageUploadAPI(arrImages: [image], documentType: .IdentityProof)
        }
    }
    
    @IBAction func btnLicenceClick(_ sender: themeButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.ImageViewLicence.image = image
            self.ImageUploadAPI(arrImages: [image], documentType: .Licence)
        }
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Validation ---------
    // ----------------------------------------------------
    func Validate() -> (Bool,String) {
        
        let checkLicenseNumber = TextFieldLicenseNumber.validatedText(validationType: ValidatorType.requiredField(field: "license number"))
        let checkLicenseExpiryDate = TextFieldLicenseExpiryDate.validatedText(validationType: ValidatorType.requiredField(field: "license expiry date"))
        
        if idProofImage == "" {
            return (false,"Please attach id proof document")
        } else if licenceImage == "" {
            return (false,"Please attach license")
        } else if (!checkLicenseNumber.0){
            return (checkLicenseNumber.0,checkLicenseNumber.1)
        }
        else if (!checkLicenseExpiryDate.0){
            return (checkLicenseExpiryDate.0,checkLicenseExpiryDate.1)
        }

        return (true,"")
        
    }
    
    
    @IBAction func SaveButtonPress(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            callLicenceDetailUpdateAPI()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    func UploadDocument(PathURL:URL,DocType:DocumentType) {
        var UploadFiles : [UploadMediaModel] = []
        
        UploadFiles.append(UploadMediaModel(mediaType: .File, forKey: "images[]", withImage: nil, fileUrl: PathURL)!)
        
        self.editLicenceDetailViewModel.editLicenceDetailsVC = self
        
        
    }
    
    func ImageUploadAPI(arrImages:[UIImage],documentType:DocumentType) {
        
        self.editLicenceDetailViewModel.editLicenceDetailsVC = self
        
        self.editLicenceDetailViewModel.WebServiceImageUpload(images: arrImages, uploadFor: documentType)
    }
    
}

//MARK: - API callskk
extension EditLicenceDetailsVC{
    
    func callLicenceDetailUpdateAPI() {
        self.editLicenceDetailViewModel.editLicenceDetailsVC =  self
        let reqModel = EditLicenceDetailsReqModel()
        reqModel.eu_registration_document = idProofImage
        reqModel.license_image = licenceImage
        reqModel.license_expiry_date = TextFieldLicenseExpiryDate.text
        reqModel.license_number = TextFieldLicenseNumber.text
        self.editLicenceDetailViewModel.WebServiceForLicenceDeatilUpdate(ReqModel: reqModel)
    }
}
