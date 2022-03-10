//
//  IdentifyYourselfVC.swift
//  MyVagon
//
//  Created by MacMini on 26/07/21.
//

import UIKit
import MobileCoreServices
import SDWebImage
class IdentifyYourselfVC: BaseViewController, UITextFieldDelegate,UIDocumentPickerDelegate {

    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   var SelectedDocumentRow = 0
    var identifyYourselfViewModel = IdentifyYourselfViewModel()
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var personIV: UIImageView!
    @IBOutlet weak var loremLabel: themeLabel!
  
  
    @IBOutlet weak var NextButton: themeButton!
    
    @IBOutlet weak var ImageViewIdentity: UIImageView!
    @IBOutlet weak var ImageViewLicence: UIImageView!
    
    @IBOutlet weak var TextFieldLicenseNumber: themeTextfield!
    @IBOutlet weak var TextFieldLicenseExpiryDate: themeTextfield!
    
   
    

    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextFieldLicenseExpiryDate.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .date, MinDate: true, MaxDate: false)
        setValue()
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func setValue() {
        if SingletonClass.sharedInstance.RegisterData.Reg_license.count != 0 {
            let strUrl = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.RegisterData.Reg_license[0])"
            print(strUrl)
            ImageViewLicence.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewLicence.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        if SingletonClass.sharedInstance.RegisterData.Reg_id_proof.count != 0 {
            let strUrl = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.RegisterData.Reg_id_proof[0])"
            ImageViewIdentity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewIdentity.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
         TextFieldLicenseNumber.text = SingletonClass.sharedInstance.RegisterData.Reg_license_number
        TextFieldLicenseExpiryDate.text = SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date
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
    @IBAction func termsButtonPressed(_ sender: themeButton) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: TermsConditionVC.storyboardID) as! TermsConditionVC
        controller.isTerms = true
        controller.strNavTitle = "Terms & Conditions"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
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
        
        if SingletonClass.sharedInstance.RegisterData.Reg_id_proof.count == 0 {
            return (false,"Please attach id proof document")
        } else if SingletonClass.sharedInstance.RegisterData.Reg_license.count == 0 {
            return (false,"Please attach license")
        } else if (!checkLicenseNumber.0){
            return (checkLicenseNumber.0,checkLicenseNumber.1)
        }
        else if (!checkLicenseExpiryDate.0){
            return (checkLicenseExpiryDate.0,checkLicenseExpiryDate.1)
        }

        return (true,"")
        
    }
    
    
    @IBAction func NextButtonPress(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {

            SingletonClass.sharedInstance.RegisterData.Reg_license_number = TextFieldLicenseNumber.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_license_expiry_date = TextFieldLicenseExpiryDate.text ?? ""
            
            UserDefault.SetRegiterData()
            UserDefault.setValue(3, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
            
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 4
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            RegisterMainVC.viewDidLayoutSubviews()
           
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
        
        self.identifyYourselfViewModel.identifyYourselfVC = self
        
        
    }
    
    func ImageUploadAPI(arrImages:[UIImage],documentType:DocumentType) {
        
        self.identifyYourselfViewModel.identifyYourselfVC = self
        
        self.identifyYourselfViewModel.WebServiceImageUpload(images: arrImages, uploadFor: documentType)
    }
}
