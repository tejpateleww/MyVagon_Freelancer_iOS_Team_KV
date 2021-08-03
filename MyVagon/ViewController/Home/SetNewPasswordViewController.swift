//
//  SetNewPasswordViewController.swift
//  MyVagon
//
//  Created by Apple on 30/07/21.
//

import UIKit

class SetNewPasswordViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var isFromForgot : Bool = false
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var ViewCurrentPassword: UIView!
    
    @IBOutlet weak var TextFieldCurrentPassword: themeTextfield!
    @IBOutlet weak var TextFieldNewPassword: themeTextfield!
    @IBOutlet weak var TextFieldConfirmPassword: themeTextfield!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Set new password", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        if isFromForgot {
            ViewCurrentPassword.isHidden = true
        } else {
            ViewCurrentPassword.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnSetNewPassword(_ sender: themeButton) {
        appDel.NavigateToLogin()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
