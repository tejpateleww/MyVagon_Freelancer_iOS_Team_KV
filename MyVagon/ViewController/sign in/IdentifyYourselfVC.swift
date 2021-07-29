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
        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
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
            let options = [kUTTypePDF as String, kUTTypeZipArchive  as String, kUTTypePNG as String, kUTTypeJPEG as String, kUTTypeText  as String, kUTTypePlainText as String]
            
            let documentPicker =  UIDocumentPickerViewController(documentTypes: options, in: .import)
            documentPicker.delegate = self
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        } else if textField == licenceTF {
            SelectedDocumentRow = 1
            let options = [kUTTypePDF as String, kUTTypeZipArchive  as String, kUTTypePNG as String, kUTTypeJPEG as String, kUTTypeText  as String, kUTTypePlainText as String]
           
           
            let documentPicker =  UIDocumentPickerViewController(documentTypes: options, in: .import)
            documentPicker.delegate = self
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
      
        let cico = url as URL
        print(cico)
        print(url)
        
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        
        
        if SelectedDocumentRow == 0 {
         
            identityProofTF.text = url.lastPathComponent
            
        } else {
           
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
    }
    
    
    @IBAction func saveButtonPressed(_ sender: themeButton) {
        appDel.NavigateToHome()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
}
