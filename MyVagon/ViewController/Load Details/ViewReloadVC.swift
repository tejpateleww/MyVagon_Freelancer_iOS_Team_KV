//
//  ViewReloadVC.swift
//  MyVagon
//
//  Created by Tej P on 16/03/22.
//

import UIKit

class ViewReloadVC: BaseViewController {
    
    @IBOutlet weak var lblTitleBookingConfirmed: themeLabel!
    @IBOutlet weak var lblReloadsFound: UILabel!
    @IBOutlet weak var btnDismiss: themeButton!
    @IBOutlet weak var btnViewReloads: themeButton!
    
    var strTitle : String = ""
    var customTabBarController: CustomTabBarVC?
    var driverId = ""
    var bookingId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    

    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.lblReloadsFound.text = strTitle
    }
    
    func setupData(){
        
    }
    
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
                NotificationCenter.default.post(name: .backToLoadDeatil, object: nil)
            })
        }
        
    }
    
    
}
