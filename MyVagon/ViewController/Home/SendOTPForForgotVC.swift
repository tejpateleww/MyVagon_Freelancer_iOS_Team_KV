//
//  SendOTPForForgotVC.swift
//  MyVagon
//
//  Created by Apple on 30/07/21.
//

import UIKit

class SendOTPForForgotVC: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldEmail: themeTextfield!
    
    @IBOutlet weak var BtnSendOTP: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func BtnSendOTPAction(_ sender: themeButton) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: EnterOTPViewController.storyboardID) as! EnterOTPViewController
        controller.EnteredText = "Enter an otp send to \n+30 11122233344"
        controller.ClosourVerify = {
            controller.dismiss(animated: true, completion: nil)
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SetNewPasswordViewController.storyboardID) as! SetNewPasswordViewController
            controller.isFromForgot = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
