//
//  HomeViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit
import FSCalendar

class HomeViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    
    @IBOutlet weak var calender: FSCalendar!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search and Book Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notification.value,NavItemsRight.chat.value], isTranslucent: true, ShowShadow: false)
        
        self.calender.firstWeekday = 1
        self.conHeightOfCalender.constant = 300
        
        calender.select(Date())
        calender.scope = .month
        calender.accessibilityIdentifier = "calender"
        configureCalendar()
        
        
        // Do any additional setup after loading the view.
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
    
    
    
   
    
    
      //MARK:- ======== Calender Setup =======
    func configureCalendar() {
        
        calender.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
//        calender.frame = CGRect(x: 100, y: 0, width: calender.frame.width, height: calender.frame.height)
        calender.calendarHeaderView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        calender.calendarWeekdayView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        calender.appearance.todaySelectionColor = UIColor.appColor(.themeColorForButton)
        calender.appearance.headerTitleColor = UIColor(hexString: "#1F1F41")
        calender.appearance.headerTitleFont = CustomFont.PoppinsRegular.returnFont(14.0)
        calender.appearance.titleFont = CustomFont.PoppinsRegular.returnFont(12.0)
        calender.appearance.weekdayFont = CustomFont.PoppinsMedium.returnFont(12.0)
        calender.appearance.selectionColor = UIColor.appColor(.themeColorForButton);      calender.appearance.titleSelectionColor = colors.white.value

        calender.appearance.headerDateFormat = "MMM, yyyy"
        calender.appearance.headerMinimumDissolvedAlpha = 0.0
        calender.delegate = self
        calender.dataSource = self
        calender.scope = .week
        
        calender.weekdayHeight = 40
        
        calender.rowHeight = 40
        
        view.layoutIfNeeded()
        calender.clipsToBounds = true
        calender.layer.cornerRadius = 0
        calender.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      //  calender.createShadow(color: .black, opacity: 0.1, offset: CGSize(width: 0, height: 0), radius: 5, scale: true, shadowSize: 1)
        view.layoutIfNeeded()
    }
    
    @IBAction func nextTapped(_ sender:UIButton) {
        calender.setCurrentPage(getNextMonth(date: calender.currentPage), animated: true)
    }

    @IBAction  func previousTapped(_ sender:UIButton) {
        calender.setCurrentPage(getPreviousMonth(date: calender.currentPage), animated: true)
    }

    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .day, value: 7, to:date)!
    }

    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .day, value: -7, to:date)!
    }
    
}
class CalenderUI : FSCalendar {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print(date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let shouldBegin = true//self.CalenderStackView.contentOffset.y <= -self.tableView.contentInset.top
//        if shouldBegin {
//            let velocity = self.scopeGesture.velocity(in: self.view)
//            switch self.Calander.scope {
//            case .month:
//                return velocity.y < 0
//            case .week:
//                return velocity.y > 0
//            @unknown default:
//                print("Error")
//            }
//        }
//        return shouldBegin
//    }
    
    
   
}
