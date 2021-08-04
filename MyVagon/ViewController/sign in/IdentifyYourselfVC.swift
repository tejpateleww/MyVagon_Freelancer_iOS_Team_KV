//
//  IdentifyYourselfVC.swift
//  MyVagon
//
//  Created by MacMini on 26/07/21.
//

import UIKit
import MobileCoreServices

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
    @IBOutlet weak var identifyLabel: themeLabel!
    @IBOutlet weak var loremLabel: themeLabel!
    @IBOutlet weak var identityProofTF: themeTextfield!
    @IBOutlet weak var licenceTF: themeTextfield!
    @IBOutlet weak var uploadVehicleLabel: UILabel!
    @IBOutlet weak var iAcceptLabel: themeLabel!
    @IBOutlet weak var termsButton: themeButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var saveButton: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        identityProofTF.delegate = self
        licenceTF.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == identityProofTF {
            
            SelectedDocumentRow = 0
            let options = [kUTTypeJPEG as String]
            
            let documentPicker =  UIDocumentPickerViewController(documentTypes: options, in: .import)
            documentPicker.delegate = self
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        } else if textField == licenceTF {
            SelectedDocumentRow = 1
            let options = [kUTTypeJPEG as String]
           
            let documentPicker =  UIDocumentPickerViewController(documentTypes: options, in: .import)
            documentPicker.delegate = self
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
      
        
        print("ATDebug :: \(url.absoluteURL)")
       
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        
        
        if SelectedDocumentRow == 0 {
            self.UploadDocument(PathURL: url.absoluteURL, DocType: .IdentityProof)
            identityProofTF.text = url.lastPathComponent
            
        } else {
            self.UploadDocument(PathURL: url.absoluteURL, DocType: .Licence)
            licenceTF.text = url.lastPathComponent
            
        }
        
    }
    
    private func handleFileSelection(inUrl:URL) -> Data {
        var data = Data()
        do {
            // inUrl is the document's URL
            data = try Data(contentsOf: inUrl)
            // Getting file data here
        } catch {
           
        }
        return data
    }
    
    func Validate() -> (Bool,String) {
        
        
        let CheckIdentityProof = identityProofTF.validatedText(validationType: ValidatorType.Attach(field: "identity proof"))
        let CheckLicence = licenceTF.validatedText(validationType: ValidatorType.Attach(field: "licence"))
        
        
        if (!CheckIdentityProof.0){
            return (CheckIdentityProof.0,CheckIdentityProof.1)
        }  else if (!CheckLicence.0){
            return (CheckLicence.0,CheckLicence.1)
        } else if !checkBoxButton.isSelected {
            return (false,"Please accept terms & condition")
        }
        return (true,"")
        
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
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CommonWebviewVC.storyboardID) as! CommonWebviewVC
        controller.strNavTitle = "Terms & Conditions"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            appDel.NavigateToHome()
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
        
        self.identifyYourselfViewModel.WebServiceForUploadDocument(Docs: UploadFiles, DocumentType: DocType)
    }
}
