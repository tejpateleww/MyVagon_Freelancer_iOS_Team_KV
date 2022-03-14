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
        print("btn persnol info clicked")
    }
    @IBAction func btnTractorDetailClicked(_ sender: Any) {
        print("btn tractor info clicked")
    }
    @IBAction func btnTruckDetailClicked(_ sender: Any) {
        print("btn truck info clicked")
    }
    @IBAction func btnLicenceClicked(_ sender: Any) {
        print("btn licence info clicked")
    }
    
    @IBAction func btnPaymentDetailClicked(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: PaymentsVC.storyboardID) as! PaymentsVC
        controller.hidesBottomBarWhenPushed = true
        controller.isFromEdit = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
