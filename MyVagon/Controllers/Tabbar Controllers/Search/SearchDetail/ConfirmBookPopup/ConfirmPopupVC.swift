//
//  CommonAcceptRejectPopupVC.swift
//  MyVagon
//
//  Created by Apple on 16/08/21.
//

import UIKit

class ConfirmPopupVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var LblDescripiton: UILabel!
    @IBOutlet weak var BtnLeft: themeButton!
    @IBOutlet weak var BtnRight: themeButton!
    
    var loadDetailsModel : LoadDetailViewModel?
    var loadDetailsVc : SearchDetailVC?
    var bookingID = ""
    var availabilityId = ""
    var isForBook = false
    var TitleAttributedText : NSAttributedString?
    var DescriptionAttributedText : NSAttributedString?
    var LeftbtnTitle : String?
    var RightBtnTitle : String?
    var IsHideImage : Bool = true
    var ShownImage : UIImage?
    var LeftbtnClosour : (()->())?
    var RightbtnClosour : (()->())?
    var closeClosour : (()->())?
    
    // MARK: - Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetValue()
    }
    override func viewWillLayoutSubviews() {
        MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let click = self.closeClosour{
            click()
        }
    }
    
    //MARK: - Custom Methods
    func SetValue() {
        TitleImage.superview?.isHidden = (IsHideImage == true) ? true : false
        TitleImage.image = ShownImage ?? UIImage()
        LblTitle.attributedText = TitleAttributedText
        LblDescripiton.attributedText = DescriptionAttributedText
        BtnLeft.isHidden = (LeftbtnTitle == "") ? true : false
        BtnRight.isHidden = (RightBtnTitle == "") ? true : false
        UIView.performWithoutAnimation {
            BtnLeft.setTitle(LeftbtnTitle, for: .normal)
            BtnRight.setTitle(RightBtnTitle, for: .normal)
            self.BtnLeft.layoutIfNeeded()
            self.BtnRight.layoutIfNeeded()
        }
    }
    
    // MARK: - IBAction Methods
    @IBAction func btnCancle(_ sender: themeButton) {
        if let click = self.LeftbtnClosour{
            click()
        }
    }
    
    @IBAction func btnBookNow(_ sender: themeButton) {
        if isForBook{
            self.CallBookNow()
        } else {
            if let click = self.RightbtnClosour{
                click()
            }
        }
    }
}

// MARK: - Webservice Methods
extension ConfirmPopupVC{
    func CallBookNow() {
        self.loadDetailsModel?.loadDetailsVC = loadDetailsVc
        self.loadDetailsModel?.commonAcceptRejectPopupVC = self
        let reqModel = BookNowReqModel()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = bookingID
        reqModel.availability_id = availabilityId
        self.loadDetailsModel?.BookNow(ReqModel: reqModel)
    }
}
