//
//  AddDriverVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 26/01/22.
//

import UIKit

class AddDriverVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var imgDriver: RoundedImageView!
    @IBOutlet weak var txtFullName: MyProfileTextField!
    @IBOutlet weak var txtMobileNumber: MyProfileTextField!
    @IBOutlet weak var txtEmail: MyProfileTextField!
    @IBOutlet weak var imgLicense: UIImageView!
    @IBOutlet weak var imgIdentityProof: UIImageView!
    
    var imagePicker : ImagePicker!
    var imagselection = 0
    var isProfileUpLoded = false
    var isLicenseUpLoded = false
    var isIdentityUpLoded = false
    var mobileNumber = ""
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    //MARK: - Custom methods
    func setupUI(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: true)
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Driver", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
    }
    
    func setupData(){
        self.txtMobileNumber.delegate = self
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
    
    //MARK: - UIButton Action methods
    @IBAction func btnActionAddDriver(_ sender: UIButton) {
        let validation = self.validation()
        if validation.0{
            Utilities.ShowAlertOfSuccess(OfMessage: validation.1)
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: validation.1)
        }
    }
    
    @IBAction func btnActionLicense(_ sender: UIButton){
        self.imagselection = 2
        self.imagePicker.present(from: imgLicense, viewPresented: self.view, isRemove: isLicenseUpLoded)
    }
    
    @IBAction func btnActionProfile(_ sender: UIButton){
        self.imagselection = 0
        self.imagePicker.present(from: imgDriver, viewPresented: self.view, isRemove: isProfileUpLoded)
    }
    
    @IBAction func BtnActionIdentityProof(_ sender: UIButton){
        self.imagselection = 1
        self.imagePicker.present(from: imgIdentityProof, viewPresented: self.view, isRemove: isIdentityUpLoded)
    }
    
}

//MARK: - ImagePickerDelegate methods
extension AddDriverVC : ImagePickerDelegate {
    func didSelect(image: UIImage?, SelectedTag: Int) {
        switch imagselection{
        case 0:
            if image == nil{
                self.imgDriver.image = UIImage(named: "ic_userIcon")
                self.isProfileUpLoded = false
            }else{
                self.imgDriver.image = image
                self.isProfileUpLoded = true
            }
        case 1:
            if image == nil{
                self.imgIdentityProof.image = UIImage(named: "ic_gallary")
                self.isIdentityUpLoded = false
            }else{
                self.imgIdentityProof.image = image
                self.isIdentityUpLoded = true
            }
        case 2:
            if image == nil{
                self.imgLicense.image = UIImage(named: "ic_gallary")
                self.isLicenseUpLoded = false
            }else{
                self.imgLicense.image = image
                self.isLicenseUpLoded = true
            }
        default:
            break
        }
    }
    
}

//MARK: - UITextFieldDelegate methods
extension AddDriverVC: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count ?? 0 <= 10{
            self.mobileNumber = textField.text ?? ""
        }else{
            textField.text = self.mobileNumber
        }
    }
}
