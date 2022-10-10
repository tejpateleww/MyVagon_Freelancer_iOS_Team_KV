//
//  NewEditProfile.swift
//  MyVagon
//
//  Created by Dhanajay  on 14/03/22.
//

import UIKit
import FittedSheets

class NewEditProfile: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var lblPersonalInfo: UILabel!
    @IBOutlet weak var lblTractorDetail: UILabel!
    @IBOutlet weak var lblTruckDetail: UILabel!
    @IBOutlet weak var lblLicenseDetail: UILabel!
    @IBOutlet weak var lblPaymentDetail: UILabel!
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var viewLicence: UIView!
    @IBOutlet weak var viewTractor: UIView!
    @IBOutlet weak var viewTruck: UIView!
    @IBOutlet weak var btnDeleteMyAccount: themeButton!
    
    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom methods
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.lblPersonalInfo.text = "Personal information".localized
        self.lblTractorDetail.text = "Tractor_detail_Edit".localized
        self.lblTruckDetail.text = "Truck_detail_edit".localized
        self.lblLicenseDetail.text = "Licence Detail".localized
        self.lblPaymentDetail.text = "Payment Detail".localized
        self.btnDeleteMyAccount.setTitle("btn_Delete_Account".localized, for: .normal)
    }
    
    func setUpUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Profile".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        if UserDefault.string(forKey: UserDefaultsKey.LoginUserType.rawValue) == LoginType.dispatcher_driver.rawValue{
            viewPayment.isHidden = true
            viewLicence.isHidden = true
            viewTruck.isHidden = true
            viewTractor.isHidden = true
        }else{
            viewPayment.isHidden = false
            viewLicence.isHidden = false
            viewTruck.isHidden = false
            viewTractor.isHidden = false
        }
    }
    
    //MARK: - IBAction methods
    @IBAction func btnPersnolInfoClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: EditPersonalInfoVC.storyboardID) as! EditPersonalInfoVC
        controller.hidesBottomBarWhenPushed = true
        controller.Iseditable = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnTractorDetailClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: TractorDetailVC.storyboardID) as! TractorDetailVC
        controller.isFromEdit = true
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnTruckDetailClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: RegisterTruckListVC.storyboardID) as! RegisterTruckListVC
        controller.isFromEdit = true
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnLicenceClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: IdentifyYourselfVC.storyboardID) as! IdentifyYourselfVC
        controller.isFromEdit = true
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnPaymentDetailClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: PaymentsVC.storyboardID) as! PaymentsVC
        controller.hidesBottomBarWhenPushed = true
        controller.isFromEdit = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnDeleteAccountClick(_ sender: Any) {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: DeleteAccountPopUpVC.storyboardID) as! DeleteAccountPopUpVC
            controller.hidesBottomBarWhenPushed = true
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(200) + appDel.GetSafeAreaHeightFromBottom())])
            sheetController.allowPullingPastMaxHeight = false
            self.present(sheetController, animated: true, completion: nil)
    }
    
}
