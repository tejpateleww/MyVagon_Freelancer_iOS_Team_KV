//
//  ViewReloadVC.swift
//  MyVagon
//
//  Created by Tej P on 16/03/22.
//

import UIKit

class ViewReloadVC: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var lblTitleBookingConfirmed: themeLabel!
    @IBOutlet weak var lblReloadsFound: UILabel!
    @IBOutlet weak var btnDismiss: themeButton!
    @IBOutlet weak var btnViewReloads: themeButton!
    
    var strTitle : String = ""
    var customTabBarController: CustomTabBarVC?
    var driverId = ""
    var bookingId = ""
    var isFromRelode = false
    
    //MARK: - Life cycle metohd
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom method
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.lblTitleBookingConfirmed.text = "Booking Confirmed".localized
        btnDismiss.setTitle("Dismiss".localized, for: .normal)
        btnViewReloads.setTitle("View Reloads".localized, for: .normal)
    }

    func prepareView(){
        self.setupUI()
    }
    
    func setupUI(){
        if isFromRelode{
            self.lblReloadsFound.isHidden = true
            self.lblTitleBookingConfirmed.text = "Reload Booking Confirmed"
            self.btnViewReloads.isHidden = true
            self.btnDismiss.setTitle("Book more loads", for: .normal)
        }else{
            self.lblReloadsFound.text = strTitle
        }
    }
    
    //MARK: - IBAction method
    @IBAction func btnReloadAction(_ sender: Any) {
        appDel.NavigateToHome()
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: RelatedMatchesVC.storyboardID) as! RelatedMatchesVC
        controller.hidesBottomBarWhenPushed = true
        controller.driverId = self.driverId
        controller.bookingId = self.bookingId
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: {
                if self.isFromRelode{
                    appDel.NavigateToHome()
                }else{
                    NotificationCenter.default.post(name: .backToLoadDeatil, object: nil)
                }
            })
        }
    }
}
