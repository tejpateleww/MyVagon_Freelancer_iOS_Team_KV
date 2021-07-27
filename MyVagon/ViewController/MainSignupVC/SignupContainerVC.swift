//
//  SignupContainerVC.swift
//  MyVagon
//
//  Created by Admin on 26/07/21.
//

import UIKit

enum TabSelection: Int {
    case freelancer
    case Company
    
}


class SignupContainerVC: UIViewController {

    //MARK:- ===== Outlets =======
    @IBOutlet var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet var viewTabView: UIView!
    
    var tabTypeSelection = TabSelection(rawValue: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in btnSelection{
            if i.tag == 0 {
                i.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
                selectedBtnUIChanges(Selected: true, Btn: i)
            }
            else {
                selectedBtnUIChanges(Selected: false, Btn:i)
            }
        }
        

       
    }
    
    @IBAction func btnTabSelection(_ sender: UIButton) {
        let _ = btnSelection.map{$0.isSelected = false}
        for i in btnSelection{
            selectedBtnUIChanges(Selected: false, Btn: i)
        }
        if(sender.tag == 0)
        {
            selectedBtnUIChanges(Selected: true, Btn:sender)
            self.tabTypeSelection = .freelancer
            
        }
        else  if(sender.tag == 1)
        {
            self.tabTypeSelection = .Company
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        
        self.btnLeadingConstaintOfAnimationView.constant = sender.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
    }
    

    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
        
    }
    

    

}
