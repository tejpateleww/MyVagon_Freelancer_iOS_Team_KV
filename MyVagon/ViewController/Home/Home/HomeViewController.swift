//
//  HomeViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit
import FSCalendar
import FittedSheets

class HomeViewController: BaseViewController, UITextFieldDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var isLoading = true {
        didSet {
            tblLocations.isUserInteractionEnabled = !isLoading
            tblLocations.reloadData()
        }
    }
    
    var arrHomeData : [HomeDatum]?
    
    
    var homeViewModel = HomeViewModel()
    var arrStatus = ["All","Pending","Scheduled","In-Progress","Past"]
  
    var selectedIndex = 1
    
    var customTabBarController: CustomTabBarVC?
    var refreshControl = UIRefreshControl()
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    
    @IBOutlet weak var TextFieldSearch: themeTextfield!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = true
        let latStr = String(21.298100)
            let   longStr = String(70.251404)

               let staticMapUrl = "http://maps.google.com/maps/api/staticmap?markers=color:blue|\(latStr),\(longStr)&\("zoom=10&size=400x300")&sensor=true&key=AIzaSyBXAdCe4nJuapECudMeh4q-gGlU-yAMQX0"

               print(staticMapUrl)
        
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
       
        tblLocations.register(UINib(nibName: "PickUpDropOffCell", bundle: nil), forCellReuseIdentifier: "PickUpDropOffCell")
      
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search and Book Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notification.value,NavItemsRight.chat.value], isTranslucent: true, ShowShadow: false)
     
        calender.accessibilityIdentifier = "calender"
        configureCalendar()
        TextFieldSearch.delegate = self
        DispatchQueue.main.async {
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.reloadData()
        }
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = RefreshControlColor
        self.tblLocations.refreshControl = refreshControl
        
        CallWebSerive()
        // Do any additional setup after loading the view.
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        CallWebSerive()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
       override func viewWillDisappear(_ animated: Bool) {
           
           super.viewWillDisappear(true)
       }

    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool   {
        if textField == TextFieldSearch {
            
            let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: SearchOptionViewController.storyboardID) as! SearchOptionViewController
                        controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            
//
//
            return false
        }
        return true
        
    }
    
//    {
//
//
//    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSortClick(_ sender: themeButton) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupViewController.storyboardID) as! SortPopupViewController
                    controller.hidesBottomBarWhenPushed = true
        
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((controller.arrayForSort.count * 50) + 110))])
                self.present(sheetController, animated: true, completion: nil)
        
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func CallWebSerive() {
    
        self.homeViewModel.homeViewController =  self
        
        let ReqModelForGetShipment = ShipmentListReqModel()
        
        ReqModelForGetShipment.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
//        ReqModelForGetShipment.driver_id = "271"
        
     

        self.homeViewModel.GetShipmentList(ReqModel: ReqModelForGetShipment)
        
    }
    
    // ----------------------------------------------------
      //MARK:- ======== Calender Setup =======
    // ----------------------------------------------------
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
        
        var numOfSections: Int = 0
        if arrHomeData?.count != 0
           {
               //tableView.separatorStyle = .singleLine
            numOfSections            = arrHomeData?.count ?? 0
               tableView.backgroundView = nil
           }
           else
           {
               let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
               noDataLabel.text          = "No Records Found"
               noDataLabel.font = CustomFont.PoppinsRegular.returnFont(14)
               noDataLabel.textColor     = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
               noDataLabel.textAlignment = .center
               tableView.backgroundView  = noDataLabel
               tableView.separatorStyle  = .none
           }
           return numOfSections
        
       // return arrHomeData?.count ?? 0// arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeData?[section].bidsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PickUpDropOffCell", for: indexPath) as! PickUpDropOffCell
        print("ATDebug :: \(indexPath.section) :: \(indexPath.row)")
        cell.PickUpDropOffData = arrHomeData?[indexPath.section].bidsData?[indexPath.row].trucks?.locations
        
        cell.BookingDetails = arrHomeData?[indexPath.section].bidsData?[indexPath.row]
        
        cell.tblHeight = { (heightTBl) in
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.layoutSubviews()
        }
        cell.tblMultipleLocation.reloadData()
        cell.tblMultipleLocation.layoutIfNeeded()
        cell.tblMultipleLocation.layoutSubviews()

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: LoadDetailsVC.storyboardID) as! LoadDetailsVC
        controller.hidesBottomBarWhenPushed = true
        controller.LoadDetails = arrHomeData?[indexPath.section].bidsData?[indexPath.row]
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrHomeData?[section].date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy")
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
        label.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
        label.text = arrHomeData?[section].date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy")
        label.textAlignment = .center
        label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
        label.textColor = UIColor(hexString: "#292929")
        label.drawLineOnBothSides(labelWidth: label.frame.size.width, color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1))
        headerView.addSubview(label)
        
        return headerView
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
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
        tblLocations.reloadData()
    }
}
enum NotificationKeys : CaseIterable{
    
    static let KGetTblHeight = "TblHeight"
    static let KUpdateHomeScreenArray = "UpdateHomeScreenArray"
    
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
