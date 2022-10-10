//
//  SignupContainerVC.swift
//  MyVagon
//
//  Created by Admin on 26/07/21.
//

import UIKit

enum TabSelection: Int {
    case signInWithEmail
    case signInWithPhone
    
}


class SignupContainerVC: BaseViewController {

    //MARK:-Properties
    @IBOutlet var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet var HeightOfDriverContainerLogin: NSLayoutConstraint!
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet var viewTabView: UIView!
  
    var tabTypeSelection = TabSelection(rawValue: 0)
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [], isTranslucent: true)
        for i in btnSelection{
            if i.tag == 0 {
                i.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
                selectedBtnUIChanges(Selected: true, Btn: i)
            }
            else {
                selectedBtnUIChanges(Selected: false, Btn:i)
            }
        }
        if let MainView = self.children.first?.view.subviews.first {
            HeightOfDriverContainerLogin.constant = MainView.frame.size.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [], isTranslucent: true)
    }
    
    //MARK: - IBAction Method
    @IBAction func btnTabSelection(_ sender: UIButton) {
        let _ = btnSelection.map{$0.isSelected = false}
        for i in btnSelection{
            selectedBtnUIChanges(Selected: false, Btn: i)
        }
        if(sender.tag == 0){
            selectedBtnUIChanges(Selected: true, Btn:sender)
            self.tabTypeSelection = .signInWithEmail
        }
        else  if(sender.tag == 1){
            self.tabTypeSelection = .signInWithPhone
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        self.btnLeadingConstaintOfAnimationView.constant = sender.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
    }
    
    //MARK: - Custom method
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText).withAlphaComponent(0.4), for: .normal)
    }
}
