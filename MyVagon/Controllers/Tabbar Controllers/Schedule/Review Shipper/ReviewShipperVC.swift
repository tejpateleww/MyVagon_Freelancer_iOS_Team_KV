//
//  ReviewShipperVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit
import Cosmos

class ReviewShipperVC: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var btnRate: themeButton!
    @IBOutlet weak var viewRatting: CosmosView!
    @IBOutlet weak var textviewReview: ChatthemeTextView!
    
    var rateShipperViewModel = RateShipperViewModel()
    var bookingID = ""
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Rate & Review Shipper".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom method
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.LblTitle.attributedText = GetAttributedString(BoldString: "Shipper?".localized, String: "How do you like the services of the".localized )
        self.btnRate.setTitle("Save".localized, for: .normal)
        textviewReview.placeholder = "Review Shipper".localized
    }
    
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
    
    //MARK: - IBAction method
    @IBAction func btnSaveClick(_ sender: Any) {
        CallAPI()
    }
}

//MARK: - WebService method
extension ReviewShipperVC{
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
