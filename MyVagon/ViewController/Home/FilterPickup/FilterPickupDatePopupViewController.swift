//
//  FilterPickupDatePopupViewController.swift
//  MyVagon
//
//  Created by Apple on 18/08/21.
//

import UIKit

class FilterPickupDatePopupViewController: UIViewController {

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
      
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
  
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
        MainView.layer.cornerRadius = 30
            // Call the roundCorners() func right there.
//        MainView.roundCorners(corners: [ .topRight], radius: 30)
        }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnSubmitAction(_ sender: themeButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
