//
//  BidNowPopupViewController.swift
//  MyVagon
//
//  Created by Apple on 30/09/21.
//

import UIKit

class BidNowPopupViewController: UIViewController {
  
    
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var bidNowViewModel = BidNowViewModel()
    var MinimumBidAmount = ""
    var BookingId = ""
    var AvailabilityId = ""

    
    var LeftbtnTitle : String?
    var RightBtnTitle : String?
    var IsHideImage : Bool = true
    var ShownImage : UIImage?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: ViewCustomClass!
    
    
    @IBOutlet weak var LblTitle: themeLabel!
    @IBOutlet weak var LblDescripiton: themeLabel!
    
    @IBOutlet weak var BtnLeft: themeButton!
    @IBOutlet weak var BtnRight: themeButton!
    
    @IBOutlet weak var bidTextField: themeTextfield!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
        SetValue()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
    //    MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        
        LblTitle.text = Currency + MinimumBidAmount
        
        UIView.performWithoutAnimation {
            BtnLeft.setTitle("Cancel", for: .normal)
            BtnRight.setTitle("Bid", for: .normal)
            self.BtnLeft.layoutIfNeeded()
            self.BtnRight.layoutIfNeeded()
        }
        
    }
   
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func btnCancle(_ sender: themeButton) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnBidPost(_ sender: themeButton) {
        BidPost()
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func BidPost() {
        
        self.bidNowViewModel.bidNowPopupViewController = self
        
        let reqModel = BidReqModel()
        reqModel.booking_id = BookingId
        reqModel.amount = (bidTextField.text ?? "").removeFormatAmount().0
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.availability_id = AvailabilityId
        self.bidNowViewModel.WebServiceBidPost(ReqModel: reqModel)
    }
    
}
