//
//  LicenseViewController.swift
//  MyVagon
//
//  Created by Apple on 08/09/21.
//

import UIKit

class LicenseViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TextFieldLicenseNumber: themeTextfield!
    @IBOutlet weak var TextFieldLicenseExpiryDate: themeTextfield!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        MainView.layer.cornerRadius = 30
        MainView.clipsToBounds = true
        
        TextFieldLicenseExpiryDate.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .date, MinDate: true, MaxDate: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    override func viewWillLayoutSubviews() {
        MainView.layoutIfNeeded()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @objc func btnDoneDatePickerClicked() {
        if let datePicker = self.TextFieldLicenseExpiryDate.inputView as? UIDatePicker {
            
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatterString.onlyDate.rawValue
         
            TextFieldLicenseExpiryDate.text = formatter.string(from: datePicker.date)

        }
        self.TextFieldLicenseExpiryDate.resignFirstResponder() // 2-5
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
