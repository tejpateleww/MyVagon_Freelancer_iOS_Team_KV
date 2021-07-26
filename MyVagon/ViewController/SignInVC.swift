//
//  SignInVC.swift
//  MyVagon
//
//  Created by iMac on 16/07/21.
//

import UIKit

class SignInVC: UIViewController {
    
    
    //MARK:- Outlet
    
    
    @IBOutlet weak var lbl_myvagon: UILabel!
    
    @IBOutlet weak var lbl_subTitle: UILabel!
    
    
    @IBOutlet weak var BtnSignIn: themButtonNext!
    
    @IBOutlet weak var BtnJoinForFree: UIButton!
    
    
    var isFreelancerSelected :Bool = false
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func initView() {
        
        navigationController?.isNavigationBarHidden = true
        var myString:NSString = "MYVAGON"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:CustomFont.PoppinsSemiBold.returnFont(55)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors.splashtitleColor.value, range: NSRange(location:0,length:2))
        lbl_myvagon.attributedText = myMutableString
        lbl_subTitle.font = CustomFont.PoppinsRegular.returnFont(19)
        
        
      //  BtnJoinForFree.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
       // BtnSignIn.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
      //  BtnJoinForFree.titleLabel?.tintColor = colors.BlueLabelColor.value
        
        BtnSignIn.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
        BtnJoinForFree.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(16)
 
    }
    
    
    
    

   

}
