//
//  CommonAcceptRejectPopupVC.swift
//  MyVagon
//
//  Created by Apple on 16/08/21.
//

import UIKit

class CommonAcceptRejectPopupVC: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
     
    var TitleAttributedText : NSAttributedString?
    var DescriptionAttributedText : NSAttributedString?
    
    var LeftbtnTitle : String?
    var RightBtnTitle : String?
    var IsHideImage : Bool = true
    var ShownImage : UIImage?
    
    
    var LeftbtnClosour : (()->())?
    var RightbtnClosour : (()->())?
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TitleImage: UIImageView!
    
    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var LblDescripiton: UILabel!
    
    @IBOutlet weak var BtnLeft: themeButton!
    @IBOutlet weak var BtnRight: themeButton!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetValue()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
    }
   
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        
        
        TitleImage.superview?.isHidden = (IsHideImage == true) ? true : false
        TitleImage.image = ShownImage ?? UIImage()
        
        LblTitle.attributedText = TitleAttributedText
        LblDescripiton.attributedText = DescriptionAttributedText
        
        UIView.performWithoutAnimation {
            BtnLeft.setTitle(LeftbtnTitle, for: .normal)
            BtnRight.setTitle(RightBtnTitle, for: .normal)
            self.BtnLeft.layoutIfNeeded()
            self.BtnRight.layoutIfNeeded()
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnCancle(_ sender: themeButton) {
        if let click = self.LeftbtnClosour{
            click()
        }
        
        
    }
    
    @IBAction func btnBookNow(_ sender: themeButton) {
        if let click = self.RightbtnClosour{
            click()
        }
       
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
