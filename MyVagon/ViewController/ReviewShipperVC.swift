//
//  ReviewShipperVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit
import Cosmos
class ReviewShipperVC: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var rateShipperViewModel = RateShipperViewModel()
    var bookingID = ""
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var btnRate: themeButton!
    @IBOutlet weak var viewRatting: CosmosView!
    @IBOutlet weak var textviewReview: ChatthemeTextView!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Rate & Review Shipper", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        LblTitle.attributedText = GetAttributedString(BoldString: "Shipper?", String: "How do you like the services of the " )
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func GetAttributedString(BoldString:String,String:String) -> NSMutableAttributedString {
        let text = "\(String) \(BoldString)"
        
        let rangeString = (text as NSString).range(of: String)
        
        let rangeBoldString = (text as NSString).range(of: BoldString)
        
        let OtherAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1F1F41"), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(16)]
        
        
        let BoldAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#9B51E0"), NSAttributedString.Key.font: CustomFont.PoppinsBold.returnFont(16)]
        
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttributes(OtherAttribute, range: rangeString)
        
        attributedString.addAttributes(BoldAttributes, range: rangeBoldString)
        
        return attributedString
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSaveClick(_ sender: Any) {
        CallAPI()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
    func CallAPI() {
        
        self.rateShipperViewModel.reviewShipperVC = self
        
        let reqModel = RateReviewReqModel()
        reqModel.booking_id = bookingID
        reqModel.rating = "\(viewRatting.rating)"
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.review = textviewReview.text
        self.rateShipperViewModel.WebServiceForRate(ReqModel: reqModel)
    }
    
    
    
}
