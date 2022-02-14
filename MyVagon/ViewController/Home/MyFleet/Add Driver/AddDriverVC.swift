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
     var isProfile = false
     var isidentity = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: true)
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Driver", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)

    }
    
    //MARK ===== btn Action Add Driver =====
    @IBAction func btnActionAddDriver(_ sender: UIButton) {
        
    }
    
    //MARK ===== btn Action Licenece =====
    @IBAction func btnActionLicence(_ sender: UIButton) {
        isidentity = false
        isProfile = false
        self.imagePicker.present(from: imgLicense, viewPresented: self.view, isRemove: false)
    }
    
    //MARK ===== btn Action Profile =====
    @IBAction func btnActionProfile(_ sender: UIButton) {
        isidentity = false
        isProfile = true
        self.imagePicker.present(from: imgDriver, viewPresented: self.view, isRemove: false)
    }
    
    //MARK ===== btn Action Identity Proof =====
    @IBAction func BtnActionIdentityProof(_ sender: UIButton) {
        isidentity = true
        isProfile = false
        self.imagePicker.present(from: imgIdentityProof, viewPresented: self.view, isRemove: false)
    }
}

extension AddDriverVC : ImagePickerDelegate {
    func didSelect(image: UIImage?, SelectedTag: Int) {
        if image != nil {
            if isProfile == true {
               imgDriver.image = image
            }
            else if isidentity == true {
                imgIdentityProof.image = image
            }
            else {
                imgLicense.image = image
            }
        }
    }
    
    
}
