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
    var tblCellHeight = CGFloat()
    var arrStatus = ["All","Pending","Scheduled","In-Progress","Past"]
    var arrSection = ["Today" , "20th March'21" , "22Th March'21"]
    var selectedIndex = 1
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTblHeight(_:)), name: NSNotification.Name(NotificationKeys.KGetTblHeight), object: nil)
        tblLocations.register(UINib(nibName: "PickUpDropOffCell", bundle: nil), forCellReuseIdentifier: "PickUpDropOffCell")
       // tblLocations.estimatedRowHeight = 500
       // tblLocations.rowHeight = UITableView.automaticDimension
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search and Book Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notification.value,NavItemsRight.chat.value], isTranslucent: true, ShowShadow: false)
     
    
        calender.accessibilityIdentifier = "calender"
        configureCalendar()
       
        DispatchQueue.main.async {
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           
//        tblLocations.layoutIfNeeded()
//        tblLocations.heightAnchor.constraint(equalToConstant: tblLocations.contentSize.height).isActive = true
       }

       override func viewWillDisappear(_ animated: Bool) {
           
           super.viewWillDisappear(true)
       }

       
//
    // handle notification
    @objc func getTblHeight(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
            if let dict = notification.userInfo as NSDictionary? {
                if let height = dict["TblHeight"] as? CGFloat{
                     print(height)
                   let ind = dict["indexPath"] as? IndexPath
                    print(ind)
                    
                    tblCellHeight = height
                    tblLocations.reloadData()
                   // tblLocations.reloadRows(at: [ind?.row], with: .automatic)
                }
            }
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
        
        calender.backgroundColor = UIColor(hexString: "#F7F1FD")
        //UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
//        calender.frame = CGRect(x: 100, y: 0, width: calender.frame.width, height: calender.frame.height)
        calender.calendarHeaderView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        calender.calendarWeekdayView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        calender.appearance.todaySelectionColor = UIColor.appColor(.themeColorForButton)
        calender.appearance.headerTitleColor = UIColor(hexString: "#1F1F41")
        calender.appearance.headerTitleFont = CustomFont.PoppinsRegular.returnFont(14.0)
        calender.appearance.titleFont = CustomFont.PoppinsRegular.returnFont(12.0)
        calender.appearance.weekdayFont = CustomFont.PoppinsMedium.returnFont(12.0)
        calender.appearance.selectionColor = UIColor.appColor(.themeColorForButton);      calender.appearance.titleSelectionColor = colors.white.value

        calender.appearance.headerDateFormat = "MMMM, yyyy"
        calender.appearance.headerMinimumDissolvedAlpha = 0.0
        calender.delegate = self
        calender.dataSource = self
        calender.scope = .week
        
       // calender.weekdayHeight = 40
        calender.weekdayHeight = 40
        calender.headerHeight = 30
        calender.rowHeight = 40
        
        //calender.rowHeight = 40
        
        
        view.layoutIfNeeded()
        calender.clipsToBounds = true
        calender.layer.cornerRadius = 5
      //  calender.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print(date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
}
class CalenderUI : FSCalendar {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


extension HomeViewController : UITableViewDataSource , UITableViewDelegate {
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PickUpDropOffCell", for: indexPath) as! PickUpDropOffCell
       
        print(tblLocations.rowHeight)
//        cell.tblMultipleLocation.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(tblLocations.frame.height)
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrSection[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
               let label = UILabel()
               label.frame = CGRect.init(x: 18, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
               label.text = arrSection[section]
               label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
               label.textColor = UIColor(hexString: "#292929")
               
               headerView.addSubview(label)
             
             return headerView
               
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 40
    }
}

extension HomeViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.lblStatus.text = arrStatus[indexPath.row]
        cell.lblStatus.textColor =  selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor(hexString: "#9A9AA9")
        cell.viewBG.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionOfHistory.frame.width/4, height:50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionOfHistory.reloadData()
    }

}
enum NotificationKeys : CaseIterable{
    
    static let KGetTblHeight = "TblHeight"
    
}

