//
//  ReviewShipperVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class ReviewShipperVC: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    @IBOutlet weak var LblTitle: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    
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
        let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: shipperDetailsVC.storyboardID) as! shipperDetailsVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
  
    
}
