//
//  FilterPickupDatePopupViewController.swift
//  MyVagon
//
//  Created by Apple on 18/08/21.
//

import UIKit

class FilterPickupDatePopupViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: UIView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Account", leftImage: NavItemsLeft.none.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
