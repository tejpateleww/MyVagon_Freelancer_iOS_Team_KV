//
//  FilterPickupDatePopupViewController.swift
//  MyVagon
//
//  Created by Apple on 18/08/21.
//

import UIKit
import FSCalendar
class FilterPickupDatePopupViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var SelectedDate : Date?
    var selectDateClosour : ((Date)->())?
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        configureCalendar()
        if SingletonClass.sharedInstance.searchReqModel.pickup_date != "" {
            calender.select(SingletonClass.sharedInstance.searchReqModel.pickup_date.StringToDate(Format: "yyyy-MM-dd"))
          
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
      //MARK:- ======== Calender Setup =======
    // ----------------------------------------------------
    func configureCalendar() {
        
        calender.delegate = self
        calender.dataSource = self
        
        view.layoutIfNeeded()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnSubmitAction(_ sender: themeButton) {
        if let click = self.selectDateClosour {
            click(SelectedDate ?? Date())
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
extension FilterPickupDatePopupViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SelectedDate = date
        print(date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
}
//SingletonClass.sharedInstance.searchReqModel.pickup_date
