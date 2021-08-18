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
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TitleImage: UIImageView!
    
    @IBOutlet weak var LblTitle: themeLabel!
    @IBOutlet weak var LblDescripiton: themeLabel!
    
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
        
        
        TitleImage.isHidden = (IsHideImage == true) ? true : false
        TitleImage.image = ShownImage ?? UIImage()
        
        LblTitle.attributedText = TitleAttributedText
        LblDescripiton.attributedText = DescriptionAttributedText
        
        BtnLeft.setTitle(LeftbtnTitle, for: .normal)
        BtnRight.setTitle(RightBtnTitle, for: .normal)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
