//
//  HomeViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit
import FSCalendar
import FittedSheets
import CoreLocation





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
    
    var PageNumber = 0
    var arrHomeData : [[SearchLoadsDatum]]?
    
    var isNeedToReload = false
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
    @IBOutlet weak var btnSort: themeButton!
    
    @IBOutlet weak var TextFieldSearch: themeTextfield!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = true
        tblLocations.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))

     
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
        AllSocketOnMethods()
        CallWebSerive()
        checkLocationPermission()
        // Do any additional setup after loading the view.
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        SingletonClass.sharedInstance.searchReqModel = SearchSaveReqModel()
        PageNumber = 0
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
    
    func AllSocketOnMethods() {
        
        if !SocketIOManager.shared.isSocketOn {
            self.perform(#selector(self.SocketConnectionProcess), with: nil, afterDelay: 2.0)
            
            SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
                print("socket Now connected")
                SocketIOManager.shared.isSocketOn = true
                self.setupforCustomerConnection()
            }
            
            SocketIOManager.shared.socket.on(clientEvent: .disconnect) {data, ack in
                print("socket Now Disconnected")
               
            }
            
            SocketIOManager.shared.socket.on(clientEvent: .reconnect) {data, ack in
                print("socket Now Reconnected")
                self.setupforCustomerConnection()
            }
            
            SocketIOManager.shared.socket.on(clientEvent: .statusChange) { (data, ack) in
                print("socket status change")
                print(data)
                /*
                    if let status = data[1] as? Int, status == 2 {
                        if !SocketIOManager.shared.isWaitingMessageDisplayed {
                        if let _:SimpleTxtWithOKPopup = appDel.window?.rootViewController?.presentedViewController as? SimpleTxtWithOKPopup {
                            return
                        }
                            self.perform(#selector(self.waitingForSocketConnect), with: nil, afterDelay: 0.10)
                        }
                    }
                    else
                        */
//                    if let status = data[1] as? Int, status == 3 {
//                        if SocketIOManager.shared.isWaitingMessageDisplayed {
//                            if let simpleAlert:SimpleTxtWithOKPopup = appDel.window?.rootViewController?.presentedViewController as? SimpleTxtWithOKPopup {
//                                simpleAlert.dismiss(animated: false, completion: nil)
//                                SocketIOManager.shared.isWaitingMessageDisplayed = false
//                            }
//                        }
//                    }
             }
            
            SocketIOManager.shared.socket.on(clientEvent: .error) { (data, ack) in
                print("socket error")
                print(data)
                if let status = data[0] as? String , (status == "authentication error" || status == "Could not connect to the server." || status == "The operation couldn’t be completed. Socket is not connected") {
                    if !SocketIOManager.shared.isWaitingMessageDisplayed {
//                    if let _:SimpleTxtWithOKPopup = appDel.window?.rootViewController?.presentedViewController as? SimpleTxtWithOKPopup {
//                        return
//                    }
//                        self.perform(#selector(self.waitingForSocketConnect), with: nil, afterDelay: 0.10)
//                    }
                }
            }
            
       
        }
        }
        else {
            self.setupforCustomerConnection()
        }
        
    }
    func setupforCustomerConnection() {
        let profile = SingletonClass.sharedInstance.UserProfileData
        let AccessUser:Int = profile?.id ?? 0
      
        self.connectCustomer(AccessUserId: AccessUser)

    }
    func checkLocationPermission(){
        let LocationStatus = CLLocationManager.authorizationStatus()
        if LocationStatus == .notDetermined {
            appDel.locationManager.locationManager.requestAlwaysAuthorization()
            
        }else if LocationStatus == .restricted || LocationStatus == .denied {
            Utilities.CheckLocation(currentVC:self)
        }
    }
    
    func connectCustomer(AccessUserId:Int) {
    
        // Connect Customer
        let UpdateCustomerSocketParams = ["user_id":"\(AccessUserId)" ]
        SocketIOManager.shared.socketEmit(for: socketApiKeys.driverConnect.rawValue , with: UpdateCustomerSocketParams)
        
        if SingletonClass.sharedInstance.initResModel?.bookingData != nil {
            if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.arrivedAt ?? "") == "" {
                SingletonClass.sharedInstance.CurrentTripStart = true
            } else {
                SingletonClass.sharedInstance.CurrentTripStart = false
            }
            
        }
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    @objc func SocketConnectionProcess() {
        
        SocketIOManager.shared.establishConnection()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool   {
        if textField == TextFieldSearch {
            
            let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: SearchOptionViewController.storyboardID) as! SearchOptionViewController
                        controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)

            return false
        }
        return true
        
    }

    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSortClick(_ sender: themeButton) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupViewController.storyboardID) as! SortPopupViewController
        controller.hidesBottomBarWhenPushed = true
        controller.delegate = self
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((5 * 50) + 110) + appDel.GetSafeAreaHeightFromBottom())])
        self.present(sheetController, animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func CallWebSerive() {
        PageNumber = PageNumber + 1
        self.homeViewModel.homeViewController =  self
        
        let ReqModelForGetShipment = ShipmentListReqModel()
        ReqModelForGetShipment.page = "\(PageNumber)"
        ReqModelForGetShipment.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        ReqModelForGetShipment.pickup_date = SingletonClass.sharedInstance.searchReqModel.pickup_date 
        ReqModelForGetShipment.min_price = SingletonClass.sharedInstance.searchReqModel.min_price 
        ReqModelForGetShipment.max_price = SingletonClass.sharedInstance.searchReqModel.max_price 
        ReqModelForGetShipment.pickup_lat = SingletonClass.sharedInstance.searchReqModel.pickup_lat 
        ReqModelForGetShipment.pickup_lng = SingletonClass.sharedInstance.searchReqModel.pickup_lng 
        ReqModelForGetShipment.dropoff_lat = SingletonClass.sharedInstance.searchReqModel.dropoff_lat 
        ReqModelForGetShipment.dropoff_lng = SingletonClass.sharedInstance.searchReqModel.dropoff_lng
        ReqModelForGetShipment.min_price = SingletonClass.sharedInstance.searchReqModel.min_weight
        ReqModelForGetShipment.max_weight = SingletonClass.sharedInstance.searchReqModel.max_weight
        ReqModelForGetShipment.min_weight_unit = SingletonClass.sharedInstance.searchReqModel.min_weight_unit
        ReqModelForGetShipment.max_weight_unit = SingletonClass.sharedInstance.searchReqModel.max_weight_unit
        
        self.homeViewModel.GetShipmentList(ReqModel: ReqModelForGetShipment)
    }
    
    //MARK: - ======== Calender Setup =======
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

//MARK:- CancelRideViewDelgate
extension HomeViewController : HomeSorfDelgate{
    func onSorfClick(strSort: String) {
        print(strSort)
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
        if isLoading {
            return 1
        }
        var numOfSections: Int = 0
        if arrHomeData?.count != 0{
            numOfSections = arrHomeData?.count ?? 0
            tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No loads found"
            noDataLabel.font = CustomFont.PoppinsRegular.returnFont(14)
            noDataLabel.textColor     = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 5
        }
        return arrHomeData?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PickUpDropOffCell", for: indexPath) as! PickUpDropOffCell
        cell.isLoading = self.isLoading
        if !isLoading {
            cell.PickUpDropOffData = arrHomeData?[indexPath.section][indexPath.row].trucks?.locations
            
            cell.BookingDetails = arrHomeData?[indexPath.section][indexPath.row]
            
            cell.tblHeight = { (heightTBl) in
                self.tblLocations.layoutIfNeeded()
                self.tblLocations.layoutSubviews()
            }
            cell.tblMultipleLocation.reloadData()
            cell.tblMultipleLocation.layoutIfNeeded()
            cell.tblMultipleLocation.layoutSubviews()
        }
       

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: LoadDetailsVC.storyboardID) as! LoadDetailsVC
            controller.hidesBottomBarWhenPushed = true
            controller.LoadDetails = arrHomeData?[indexPath.section][indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isLoading {
            return ""
        }
        return arrHomeData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoading {
            return UIView()
        }
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
        let label = UILabel()
        label.frame = headerView.frame
        label.text = arrHomeData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
        label.textAlignment = .center
        label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
        label.textColor = UIColor(hexString: "#292929")
        label.drawLineOnBothSides(labelWidth: label.frame.size.width, color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1))
        headerView.addSubview(label)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        
        if tableView == tblLocations {
            if indexPath.section == ((arrHomeData?.count ?? 0) - 1) {
                if indexPath.row == ((arrHomeData?[indexPath.section].count ?? 0) - 1) && isNeedToReload == true
                {
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.tintColor = RefreshControlColor
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblLocations.bounds.width, height: CGFloat(44))
                    
                    self.tblLocations.tableFooterView = spinner
                    self.tblLocations.tableFooterView?.isHidden = false
                    CallWebSerive()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 0
        }
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
