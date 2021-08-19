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
    var arrSection = ["Today" , "20th March'21" , "22th March'21"]
    var selectedIndex = 1
    
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
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
        self.customTabBarController?.showTabBar()
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
        
        calender.delegate = self
        calender.dataSource = self
        
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
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
        label.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
        label.text = arrSection[section]
        label.textAlignment = .center
        label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
        label.textColor = UIColor(hexString: "#292929")
        label.drawLineOnBothSides(labelWidth: label.frame.size.width, color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1))
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
        return CGSize(width: ((arrStatus[indexPath.row].capitalized).sizeOfString(usingFont: CustomFont.PoppinsRegular.returnFont(14)).width) + 30
                      , height: collectionOfHistory.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionOfHistory.reloadData()
    }
}
enum NotificationKeys : CaseIterable{
    
    static let KGetTblHeight = "TblHeight"
    
}

