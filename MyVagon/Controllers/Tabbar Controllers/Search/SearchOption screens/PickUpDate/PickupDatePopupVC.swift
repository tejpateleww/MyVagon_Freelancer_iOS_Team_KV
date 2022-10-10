//
//  FilterPickupDatePopupViewController.swift
//  MyVagon
//
//  Created by Apple on 18/08/21.
//

import UIKit
import FSCalendar
class PickupDatePopupVC: UIViewController {

   //MARK: - Propertise
    @IBOutlet weak var btnCancel: themeButton!
    @IBOutlet weak var btnSubmit: themeButton!
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    
    var SelectedDate : Date?
    var selectDateClosour : ((Date)->())?
    var customTabBarController: CustomTabBarVC?

    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
  
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
        MainView.layer.cornerRadius = 30
    }
    
    //MARK: - Custom method
    func setUpUI(){
        configureCalendar()
        calender.select(Date())
        self.setLocalization()
        calender.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        if SingletonClass.sharedInstance.searchReqModel.date != "" {
            calender.select(SingletonClass.sharedInstance.searchReqModel.date.StringToDate(Format: "yyyy-MM-dd"))
        }
    }
    
    func setLocalization() {
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }
    
    func configureCalendar() {
        calender.delegate = self
        calender.dataSource = self
        view.layoutIfNeeded()
    }
    
    // MARK: - IBAction methods
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnSubmitAction(_ sender: themeButton) {
        if let click = self.selectDateClosour {
            click(SelectedDate ?? Date())
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK FSCalander datasource delegate
extension PickupDatePopupVC: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let order = Calendar.current.compare(date, to: Date(), toGranularity: .day)
         if order != .orderedAscending{
             SelectedDate = date
         }else{
             calendar.select(SelectedDate ?? Date())
         }
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
