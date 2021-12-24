//
//  BidAcceptRejectViewController.swift
//  MyVagon
//
//  Created by Apple on 20/12/21.
//

import UIKit

class BidAcceptRejectViewController: UIViewController {
    var isAccept : Bool = false
    var isForBook : Bool = false
    var LoadDetails : MyLoadsNewPostedTruck?

    var bidAcceptRejectViewModel = BidAcceptRejectViewModel()
    
    var bidRequestViewController : BidRequestViewController?
    var bidRequestDetailViewController : BidRequestDetailViewController?
    
    var isFromDetails = false
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
        
        BtnLeft.isHidden = (LeftbtnTitle == "") ? true : false
        BtnRight.isHidden = (RightBtnTitle == "") ? true : false
        
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
    
    
    @IBAction func btnAcceptClick(_ sender: themeButton) {
        if isForBook {
            self.callAPIforRejectBooking(bookingID: "\(LoadDetails?.id ?? 0)")
        } else {
            if isAccept {
                self.callAPIForAcceptReject(Accepted: true, bookingID: "\(LoadDetails?.id ?? 0)")
            } else {
                self.callAPIForAcceptReject(Accepted: false, bookingID: "\(LoadDetails?.id ?? 0)")
            }
           
        }
        
       
    }
    
    @IBAction func btnCancelClick(_ sender: themeButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ------s----------------------------------------------
    
    func callAPIForAcceptReject(Accepted:Bool,bookingID:String) {
        self.bidAcceptRejectViewModel.bidAcceptRejectViewController = self
        self.bidAcceptRejectViewModel.bidRequestViewController = bidRequestViewController
        self.bidAcceptRejectViewModel.bidRequestDetailViewController = bidRequestDetailViewController
        let reqModel = BidAcceptRejectReqModel()
        reqModel.booking_request_id = bookingID
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.status = (Accepted == true) ? "accept" : "reject"
        self.bidAcceptRejectViewModel.AcceptReject(ReqModel: reqModel,isFromDetail: isFromDetails)
    }
    func callAPIforRejectBooking(bookingID:String) {
        self.bidAcceptRejectViewModel.bidAcceptRejectViewController = self
        self.bidAcceptRejectViewModel.bidRequestViewController = bidRequestViewController
        self.bidAcceptRejectViewModel.bidRequestDetailViewController = bidRequestDetailViewController
        let reqModel = BidAcceptRejectReqModel()
        reqModel.booking_request_id = bookingID
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.status = "reject"
        self.bidAcceptRejectViewModel.RejectBooking(ReqModel: reqModel,isFromDetail: isFromDetails)
    }
}
