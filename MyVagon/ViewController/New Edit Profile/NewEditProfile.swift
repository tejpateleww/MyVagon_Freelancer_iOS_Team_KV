//
//  NewEditProfile.swift
//  MyVagon
//
//  Created by Dhanajay  on 14/03/22.
//

import UIKit

class NewEditProfile: BaseViewController {

    
    //MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpData()
    }
    
    //MARK: - Custom methods
    
    func setUpUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Profile", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
    }
    
    func setUpData(){
        
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnPersnolInfoClicked(_ sender: Any) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: EditPersonalInfoVC.storyboardID) as! EditPersonalInfoVC
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
        print("btn licence info clicked")
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: EditLicenceDetailsVC.storyboardID) as! EditLicenceDetailsVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnPaymentDetailClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: PaymentsVC.storyboardID) as! PaymentsVC
        controller.hidesBottomBarWhenPushed = true
        controller.isFromEdit = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
