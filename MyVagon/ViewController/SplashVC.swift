//
//  SplashVC.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit


    

class SplashVC: UIViewController {

    @IBOutlet weak var lbl_myvagon: UILabel!
    
    
    @IBOutlet weak var img_myvagon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SplashVC.tapFunction))
        lbl_myvagon.isUserInteractionEnabled = true
        lbl_myvagon.addGestureRecognizer(tap)
        
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BoardingVC") as! BoardingVC
        navigationController?.pushViewController(vc,animated: true) //SignInVC
        
        
    }
    func initView() {
        
        navigationController?.isNavigationBarHidden = true
        var myString:NSString = "MYVAGON"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:CustomFont.PoppinsSemiBold.returnFont(55)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors.splashtitleColor.value, range: NSRange(location:0,length:2))
        lbl_myvagon.attributedText = myMutableString
        
        //UIFont(name: "Georgia", size: 55.0)
        
    }

   

}
