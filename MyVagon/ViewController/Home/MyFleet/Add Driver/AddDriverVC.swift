//
//  AddDriverVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 26/01/22.
//

import UIKit

class AddDriverVC: BaseViewController {

    //MARK: ======= Outlts =======
    @IBOutlet weak var imgDriver: RoundedImageView!
    @IBOutlet weak var txtFullName: MyProfileTextField!
    @IBOutlet weak var txtMobileNumber: MyProfileTextField!
    @IBOutlet weak var txtEmail: MyProfileTextField!
    @IBOutlet weak var imgLicense: UIImageView!
    @IBOutlet weak var imgIdentityProof: UIImageView!
    
    //MARK: ===== Variables ======
     var imagePicker : ImagePicker!
     var imagselection = 0
     var isProfileUpLoded = false
     var isLicenseUpLoded = false
     var isIdentityUpLoded = false
     var mobileNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: true)
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Driver", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
    }
    
    func setupData(){
        txtMobileNumber.delegate = self
    }
    
    //MARK ===== btn Action Add Driver =====
    @IBAction func btnActionAddDriver(_ sender: UIButton) {
        let validation = self.validation()
        if validation.0{
            Utilities.ShowAlertOfSuccess(OfMessage: validation.1)
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: validation.1)
        }
    }
    
    //MARK ===== btn Action Licenece =====
    @IBAction func btnActionLicense(_ sender: UIButton){
        imagselection = 2
        self.imagePicker.present(from: imgLicense, viewPresented: self.view, isRemove: isLicenseUpLoded)
    }
    
    //MARK ===== btn Action Profile =====
    @IBAction func btnActionProfile(_ sender: UIButton){
        imagselection = 0
        self.imagePicker.present(from: imgDriver, viewPresented: self.view, isRemove: isProfileUpLoded)
    }
    
    //MARK ===== btn Action Identity Proof =====
    @IBAction func BtnActionIdentityProof(_ sender: UIButton){
        imagselection = 1
        self.imagePicker.present(from: imgIdentityProof, viewPresented: self.view, isRemove: isIdentityUpLoded)
    }
    
    func validation() -> (Bool,String){
        let name = txtFullName.validatedText(validationType: .requiredField(field: "full name"))
        let number = txtMobileNumber.validatedText(validationType: .phoneNo(MinDigit: 10, MaxDigit: 15))
        let email = txtEmail.validatedText(validationType: .email)
        if !name.0{
            return name
        }else if !number.0{
            return number
        }else if !email.0{
            return email
        }else if !isProfileUpLoded{
            return (false,"Select profile image")
        }else if !isIdentityUpLoded{
            return (false,"Select identity proof image")
        }else if !isLicenseUpLoded{
            return (false,"Select license image")
        }else{
            return (true,"Succesfull")
        }
    }
}

extension AddDriverVC : ImagePickerDelegate {
    func didSelect(image: UIImage?, SelectedTag: Int) {
            switch imagselection{
            case 0:
                if image == nil{
                    imgDriver.image = UIImage(named: "ic_userIcon")
                    isProfileUpLoded = false
                }else{
                    imgDriver.image = image
                    isProfileUpLoded = true
                }
            case 1:
                if image == nil{
                    imgIdentityProof.image = UIImage(named: "ic_gallary")
                    isIdentityUpLoded = false
                }else{
                    imgIdentityProof.image = image
                    isIdentityUpLoded = true
                }
            case 2:
                if image == nil{
                    imgLicense.image = UIImage(named: "ic_gallary")
                    isLicenseUpLoded = false
                }else{
                    imgLicense.image = image
                    isLicenseUpLoded = true
                }
            default:
                break
            }
    }

}
extension AddDriverVC: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count ?? 0 <= 10{
            mobileNumber = textField.text ?? ""
        }else{
            textField.text = mobileNumber
        }
    }
}
