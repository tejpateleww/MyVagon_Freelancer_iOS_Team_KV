//
//  NewHomeVC.swift
//  MyVagon
//
//  Created by Tej P on 01/02/22.
//

import UIKit
import FSCalendar
import FittedSheets
import CoreLocation

class SearchVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var vWSearchSort: UIView!
    @IBOutlet weak var txtSearch: themeTextfield!
    @IBOutlet weak var btnSort: themeButton!
    @IBOutlet weak var tblSearchData: UITableView!
    @IBOutlet weak var viewSortbyMsg: UIView!
    @IBOutlet weak var lblMsgShort: UILabel!
    @IBOutlet weak var heightConstrantSortView: NSLayoutConstraint!
    
    var homeViewModel = NewHomeViewModel()
    var customTabBarController: CustomTabBarVC?
    var sortBy : String = ""
    var numberOfSections = 0
    var arrHomeData : [[SearchLoadsDatum]]?
    var isFilter:Bool = false
    var arrFilterHomeData : [SearchLoadsDatum] = []
    let refreshControl = UIRefreshControl()
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblSearchData.isUserInteractionEnabled = !self.isLoading
            self.tblSearchData.reloadData()
        }
    }
    var PageNumber = 0
    var isApiProcessing = false
    var isStopPaging = false
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
        self.checkForNotification()
        self.setLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
        self.tblSearchData.reloadData()
    }
    
    func setLocalization(){
        self.txtSearch.placeholder = "Search Options".localized
        self.btnSort.titleLabel?.numberOfLines = 0
        self.btnSort.setTitle("Sort by".localized, for: .normal)
        self.tblSearchData.reloadData()
        self.setSortby()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search and Book Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notification.value,NavItemsRight.chat.value], isTranslucent: true, ShowShadow: false, isHomeTitle: true)
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setSortby()
        self.txtSearch.delegate = self
        self.tblSearchData.delegate = self
        self.tblSearchData.dataSource = self
        self.tblSearchData.separatorStyle = .none
        self.tblSearchData.showsHorizontalScrollIndicator = false
        self.tblSearchData.showsVerticalScrollIndicator = false
        self.tblSearchData.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        self.registerNib()
        self.addRefreshControl()
        self.allSocketOnMethods()
        self.addNotificationObs()
    }
    
    func setupData(){
        self.callSearchDataAPI()
//        self.checkLocationPermission()
    }
    
    func setSortby(){
        if sortBy != ""{
            lblMsgShort.text = "\("Sort by".localized) : \(sortBy.localized)"
            heightConstrantSortView.constant = 40
        }else{
            lblMsgShort.text = ""
            heightConstrantSortView.constant = 0
        }
    }
    
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .goToChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToChatScreen), name: .goToChatScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .goToNotificationScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToNotificationScreen), name: .goToNotificationScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .goToNewScheduleScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToNewScheduleScreen), name: .goToNewScheduleScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .goToHomeScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToHomeScreen), name: .goToHomeScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .goToScheduleDetailsScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToScheduleDetailScreen), name: .goToScheduleDetailsScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reloadDataForNewBid, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataForNewBid), name: .reloadDataForNewBid, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reloadDataForSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataForSearch), name: .reloadDataForSearch, object: nil)
    }
    
    func checkForNotification(){
        if(AppDelegate.pushNotificationObj != nil){
            if(AppDelegate.pushNotificationType == NotificationTypes.newMeassage.rawValue){
                self.goToChatScreen()
            }else if(AppDelegate.pushNotificationType == NotificationTypes.general.rawValue) {
                self.goToNotificationScreen()
            }else if(AppDelegate.pushNotificationType == NotificationTypes.cancellation.rawValue) {
                self.gotoNewSchedule()
            }else if(AppDelegate.pushNotificationType == NotificationTypes.shipmentProgress.rawValue) {
                self.goToScheduleDetail()
            }
        }
    }
    
    @objc func goToChatScreen(){
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ChatVC.storyboardID) as! ChatVC
        controller.shipperID = AppDelegate.shared.shipperIdForChat
        controller.shipperName = AppDelegate.shared.shipperNameForChat
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func goToNotificationScreen() {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: NotificationVC.storyboardID) as! NotificationVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func goToNewScheduleScreen() {
        gotoNewSchedule()
    }
    
    @objc func goToHomeScreen() {
        self.customTabBarController?.selectedIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            NotificationCenter.default.post(name: .reloadDataForSearch, object: nil)
        })
    }
    
    @objc func goToScheduleDetailScreen() {
        self.goToScheduleDetail()
    }
    
    @objc func reloadDataForSearch() {
        self.sortBy = ""
        self.setSortby()
        self.reloadFilterData()
    }
    
    @objc func reloadDataForNewBid() {
        reloadSearchData()
    }
    
    func gotoNewSchedule() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.customTabBarController?.selectedIndex = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                NotificationCenter.default.post(name: .PostCompleteTrip, object: nil)
            })
        })
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    func goToScheduleDetail() {
        self.getTripData(bookingId: AppDelegate.pushNotificationObj?.booking_id ?? "")
    }
    
    func gotoNewScheduleDetail(tripdata: MyLoadsNewBid) {
        var loadStatus = ""
        switch tripdata.isBid {
        case 0:
            loadStatus = MyLoadType.Book.Name
        case 1:
            loadStatus = MyLoadType.Bid.Name
        default:
            loadStatus = MyLoadType.PostedTruck.Name
        }
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ScheduleDetailVC.storyboardID) as! ScheduleDetailVC
        controller.hidesBottomBarWhenPushed = true
        controller.LoadDetails = tripdata
        controller.strLoadStatus = loadStatus
        self.navigationController?.pushViewController(controller, animated: true)
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    func registerNib(){
        let nib = UINib(nibName: SearchDataCell.className, bundle: nil)
        self.tblSearchData.register(nib, forCellReuseIdentifier: SearchDataCell.className)
        let nib2 = UINib(nibName: EarningShimmerCell.className, bundle: nil)
        self.tblSearchData.register(nib2, forCellReuseIdentifier: EarningShimmerCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblSearchData.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblSearchData.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadSearchData()
    }
    
    func reloadSearchData(){
        SingletonClass.sharedInstance.searchReqModel = SearchSaveReqModel()
        self.isFilter = false
        self.reloadFilterData()
        self.sortBy = ""
        setSortby()
    }
    
    func reloadFilterData(){
        self.isStopPaging = false
        self.PageNumber = 0
        self.arrHomeData = []
        self.arrFilterHomeData = []
        self.isTblReload = false
        self.isLoading = true
        self.callSearchDataAPI()
    }
    
    func checkLocationPermission(){
        let LocationStatus = CLLocationManager.authorizationStatus()
        if LocationStatus == .notDetermined {
            appDel.locationManager.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func setupforCustomerConnection() {
        let profile = SingletonClass.sharedInstance.UserProfileData
        let AccessUser:Int = profile?.id ?? 0
        self.connectCustomer(AccessUserId: AccessUser)
    }
    
    func connectCustomer(AccessUserId:Int) {
        let UpdateCustomerSocketParams = ["user_id":"\(AccessUserId)" ]
        SocketIOManager.shared.socketEmit(for: socketApiKeys.driverConnect.rawValue , with: UpdateCustomerSocketParams)
    }
    
    @objc func SocketConnectionProcess() {
        SocketIOManager.shared.establishConnection()
    }
    
    func goToDeatilScreen(index : IndexPath){
        if !self.isLoading {
            if(self.isFilter ? arrFilterHomeData.count > 0 : arrHomeData?.count ?? 0 > 0){
                let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SearchDetailVC.storyboardID) as! SearchDetailVC
                controller.hidesBottomBarWhenPushed = true
                controller.LoadDetails = (self.isFilter) ? arrFilterHomeData[index.row] : arrHomeData?[index.section][index.row]
                UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnSortAction(_ sender: Any) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupVC.storyboardID) as! SortPopupVC
        controller.hidesBottomBarWhenPushed = true
        controller.delegate = self
        if sortBy != ""{
            if let index = controller.arrSordData.firstIndex(of: sortBy){
                controller.selectedIndex = index
            }
        }
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((4 * 50) + 120) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
}

extension SearchVC {
    func callSearchDataAPI() {
        self.PageNumber = self.PageNumber + 1
        self.homeViewModel.newHomeVC =  self
        let ReqModelForGetShipment = ShipmentListReqModel()
        ReqModelForGetShipment.page = "\(PageNumber)"
        ReqModelForGetShipment.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        ReqModelForGetShipment.pickup_date = SingletonClass.sharedInstance.searchReqModel.date
        ReqModelForGetShipment.min_price = SingletonClass.sharedInstance.searchReqModel.price_min
        ReqModelForGetShipment.max_price = SingletonClass.sharedInstance.searchReqModel.price_max
        ReqModelForGetShipment.pickup_lat = SingletonClass.sharedInstance.searchReqModel.pickup_lat
        ReqModelForGetShipment.pickup_lng = SingletonClass.sharedInstance.searchReqModel.pickup_lng
        ReqModelForGetShipment.dropoff_lat = SingletonClass.sharedInstance.searchReqModel.delivery_lng
        ReqModelForGetShipment.dropoff_lng = SingletonClass.sharedInstance.searchReqModel.delivery_lat
        ReqModelForGetShipment.min_weight = SingletonClass.sharedInstance.searchReqModel.weight_min
        ReqModelForGetShipment.max_weight = SingletonClass.sharedInstance.searchReqModel.weight_max
        ReqModelForGetShipment.min_weight_unit = SingletonClass.sharedInstance.searchReqModel.min_weight_unit
        ReqModelForGetShipment.max_weight_unit = SingletonClass.sharedInstance.searchReqModel.max_weight_unit
        ReqModelForGetShipment.jurnyType = SingletonClass.sharedInstance.searchReqModel.pickUpType
        //Sorting logic
        if(self.sortBy == "Price (Lowest First)"){
            ReqModelForGetShipment.price_sort = "asc"
        }else if(self.sortBy == "Price (Highest First)"){
            ReqModelForGetShipment.price_sort = "desc"
        }else if(self.sortBy == "Total Distance"){
            ReqModelForGetShipment.total_distance_sort = "desc"
        }else if(self.sortBy == "Rating"){
            ReqModelForGetShipment.rating_sort = "desc"
        }
        self.homeViewModel.WebServiceSearchList(ReqModel: ReqModelForGetShipment)
    }
    
    func getTripData(bookingId: String) {
        self.homeViewModel.newHomeVC = self
        let reqModel = LoadDetailsReqModel()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = bookingId
        self.homeViewModel.GetLoadDetails(ReqModel: reqModel)
    }
}

//MARK: - HomeSorfDelgate methods
extension SearchVC : HomeSorfDelgate{
    func onSorfClick(strSort: String) {
        self.isFilter = true
        self.sortBy = strSort
        setSortby()
        self.reloadFilterData()
    }
}

//MARK: - UITextFieldDelegate methods
extension SearchVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSearch {
            let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: SearchOptionVC.storyboardID) as! SearchOptionVC
            controller.hidesBottomBarWhenPushed = true
            controller.searchClick = {
                self.reloadDataForSearch()
            }
            self.navigationController?.pushViewController(controller, animated: true)
            return false
        }
        return true
    }
}

//MARK: - UITableView Delegate and Data Source Methods
extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isLoading {return 1}
        let section = (numberOfSections == 0) ? 1 : numberOfSections
        return (self.isFilter) ? 1 : section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.isFilter){
            //return (!self.isTblReload) ? 10 : self.arrFilterHomeData.count
            let count = (self.arrFilterHomeData.count == 0) ? 1 : self.arrFilterHomeData.count
            return (!self.isTblReload) ? 10 : count
        }else{
            if self.arrHomeData?.count ?? 0 > 0 {
                return arrHomeData?[section].count ?? 0
            } else {
                return (!self.isTblReload) ? 10 : 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSearchData.dequeueReusableCell(withIdentifier: EarningShimmerCell.className) as! EarningShimmerCell
        cell.selectionStyle = .none
        if(!self.isTblReload){
            return cell
        }else{
            if(self.isFilter){
                if(self.arrFilterHomeData.count > 0){
                    let cell = self.tblSearchData.dequeueReusableCell(withIdentifier: SearchDataCell.className) as! SearchDataCell
                    cell.setData(data: self.arrFilterHomeData[indexPath.row])
                    cell.tblHeight = { (heightTBl) in
                        self.tblSearchData.layoutIfNeeded()
                        self.tblSearchData.layoutSubviews()
                    }
                    cell.btnMainTapCousure = {
                        self.goToDeatilScreen(index: indexPath)
                    }
                    return cell
                }else{
                    let NoDatacell = self.tblSearchData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    NoDatacell.lblNoDataTitle.text = "No Loads Found".localized
                    return NoDatacell
                }
            }else{
                if(self.arrHomeData?.count ?? 0 > 0){
                    let cell = self.tblSearchData.dequeueReusableCell(withIdentifier: SearchDataCell.className) as! SearchDataCell
                    cell.setData(data: self.arrHomeData?[indexPath.section][indexPath.row])
                    cell.btnMainTapCousure = {
                        self.goToDeatilScreen(index: indexPath)
                    }
                    return cell
                }else{
                    let NoDatacell = self.tblSearchData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    NoDatacell.lblNoDataTitle.text = "No Loads Found".localized
                    return NoDatacell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.isLoading {return ""}
        if self.isFilter {return ""}
        return arrHomeData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isLoading {return UIView()}
        if self.isFilter {return UIView()}
        if self.arrHomeData?.count ?? 0 > 0 {
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
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isLoading {return 0}
        if self.isFilter {return 0}
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(self.isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(self.isLoading, animate: true, viewBackgroundColor: UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToDeatilScreen(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(!isTblReload){
            return UITableView.automaticDimension
        }else{
            if self.isFilter ? arrFilterHomeData.count > 0 : arrHomeData?.count ?? 0 > 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.isFilter ? arrFilterHomeData.count > 2 : arrHomeData?.count ?? 0 > 2){
            if (self.tblSearchData.contentOffset.y >= (self.tblSearchData.contentSize.height - self.tblSearchData.frame.size.height)) && self.isStopPaging == false && self.isApiProcessing == false {
                self.callSearchDataAPI()
            }
        }
    }
}

//MARK: - Socket connection methods
extension SearchVC{
    func allSocketOnMethods() {
        if !SocketIOManager.shared.isSocketOn {
            self.perform(#selector(self.SocketConnectionProcess), with: nil, afterDelay: 2.0)
            SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
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
            }
            SocketIOManager.shared.socket.on(clientEvent: .error) { (data, ack) in
                print("socket error")
                print(data)
                if let status = data[0] as? String , (status == "authentication error" || status == "Could not connect to the server." || status == "The operation couldn’t be completed. Socket is not connected") {
                    if !SocketIOManager.shared.isWaitingMessageDisplayed {
                    }
                }
            }
        }
        else {
            self.setupforCustomerConnection()
        }
    }

}
