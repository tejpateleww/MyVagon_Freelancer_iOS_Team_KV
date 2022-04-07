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

class NewHomeVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var vWSearchSort: UIView!
    @IBOutlet weak var txtSearch: themeTextfield!
    @IBOutlet weak var btnSort: themeButton!
    @IBOutlet weak var tblSearchData: UITableView!
    
    var homeViewModel = NewHomeViewModel()
    var customTabBarController: CustomTabBarVC?
    var sortBy : String = ""
    var numberOfSections = 0
    var arrHomeData : [[SearchLoadsDatum]]?
    
    //For Filter
    var isFilter:Bool = false
    var arrFilterHomeData : [SearchLoadsDatum] = []
    
    //Pull to refresh
    let refreshControl = UIRefreshControl()
    
    //Shimmer
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblSearchData.isUserInteractionEnabled = !self.isLoading
            self.tblSearchData.reloadData()
        }
    }
    
    //Pagination
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
    }
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search and Book Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notification.value,NavItemsRight.chat.value], isTranslucent: true, ShowShadow: false)
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
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
        self.checkLocationPermission()
    }
    
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .goToChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToChatScreen), name: .goToChatScreen, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .reloadDataForSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataForSearch), name: .reloadDataForSearch, object: nil)
    }
    
    func checkForNotification(){
        if(AppDelegate.pushNotificationObj != nil){
            if(AppDelegate.pushNotificationType == NotificationTypes.newMeassage.rawValue){
                self.goToChatScreen()
            }
        }
    }
    
    @objc func goToChatScreen() {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
        controller.shipperID = AppDelegate.shared.shipperIdForChat
        controller.shipperName = AppDelegate.shared.shipperNameForChat
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func reloadDataForSearch() {
        self.reloadFilterData()
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
        self.isStopPaging = false
        self.PageNumber = 0
        self.arrHomeData = []
        self.arrFilterHomeData = []
        self.isTblReload = false
        self.isLoading = true
        self.callSearchDataAPI()
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
        }else if LocationStatus == .restricted || LocationStatus == .denied {
            Utilities.CheckLocation(currentVC:self)
        }
    }
    
    
    //MARK: - Socket connection methods
    func allSocketOnMethods() {
        
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
    
    func setupforCustomerConnection() {
        let profile = SingletonClass.sharedInstance.UserProfileData
        let AccessUser:Int = profile?.id ?? 0
        self.connectCustomer(AccessUserId: AccessUser)
    }
    
    func connectCustomer(AccessUserId:Int) {
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
    
    @objc func SocketConnectionProcess() {
        SocketIOManager.shared.establishConnection()
    }
    
    func goToDeatilScreen(index : IndexPath){
        
        if !self.isLoading {
            if(self.isFilter ? arrFilterHomeData.count > 0 : arrHomeData?.count ?? 0 > 0){
                let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: LoadDetailsVC.storyboardID) as! LoadDetailsVC
                controller.hidesBottomBarWhenPushed = true
                controller.LoadDetails = (self.isFilter) ? arrFilterHomeData[index.row] : arrHomeData?[index.section][index.row]
                UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnSortAction(_ sender: Any) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupViewController.storyboardID) as! SortPopupViewController
        controller.hidesBottomBarWhenPushed = true
        controller.delegate = self
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((4 * 50) + 120) + appDel.GetSafeAreaHeightFromBottom())])
        self.present(sheetController, animated: true, completion: nil)
    }
    
}

extension NewHomeVC {
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
        ReqModelForGetShipment.min_price = SingletonClass.sharedInstance.searchReqModel.weight_min
        ReqModelForGetShipment.max_weight = SingletonClass.sharedInstance.searchReqModel.weight_max
        ReqModelForGetShipment.min_weight_unit = SingletonClass.sharedInstance.searchReqModel.min_weight_unit
        ReqModelForGetShipment.max_weight_unit = SingletonClass.sharedInstance.searchReqModel.max_weight_unit
        
        //Sorting logic
        if(self.sortBy == "Deadheading"){
            
        }else if(self.sortBy == "Price (Lowest First)"){
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
}

//MARK: - HomeSorfDelgate methods
extension NewHomeVC : HomeSorfDelgate{
    func onSorfClick(strSort: String) {
        self.isFilter = true
        self.sortBy = strSort
        self.reloadFilterData()
    }
}

//MARK: - UITextFieldDelegate methods
extension NewHomeVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool   {
        if textField == self.txtSearch {
            let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: SearchOptionViewController.storyboardID) as! SearchOptionViewController
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            return false
        }
        return true
    }
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension NewHomeVC : UITableViewDelegate, UITableViewDataSource {
    
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
                    cell.selectionStyle = .none
                    
                    cell.lblCompanyName.text = arrFilterHomeData[indexPath.row].shipperDetails?.companyName ?? ""
                    cell.lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (arrFilterHomeData[indexPath.row].amount ?? "" ) : ""
                    cell.lblLoadId.text = "#\(arrFilterHomeData[indexPath.row].id ?? 0)"
                    cell.lblTonMiles.text =   "\(arrFilterHomeData[indexPath.row].totalWeight ?? ""), \(arrFilterHomeData[indexPath.row].distance ?? "") Km"
                    let DeadheadValue = (arrFilterHomeData[indexPath.row].trucks?.locations?.first?.deadhead ?? "" == "0") ? arrFilterHomeData[indexPath.row].trucks?.truckType?.name ?? "" : "\(arrFilterHomeData[indexPath.row].trucks?.locations?.first?.deadhead ?? "") : \(arrFilterHomeData[indexPath.row].trucks?.truckType?.name ?? "")"
                    cell.lblDeadhead.text = DeadheadValue
                    
                    if (self.arrFilterHomeData[indexPath.row].isBid ?? 0) == 1 {
                        cell.lblStatus.text = bidStatus.BidNow.Name
                        cell.vWStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
                    } else {
                        cell.lblStatus.text = bidStatus.BookNow.Name
                        cell.vWStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
                    }
                    
                    cell.arrLocations = arrFilterHomeData[indexPath.row].trucks?.locations ?? []
                    cell.tblHeight = { (heightTBl) in
                        self.tblSearchData.layoutIfNeeded()
                        self.tblSearchData.layoutSubviews()
                    }
                    
                    cell.btnMainTapCousure = {
                        self.goToDeatilScreen(index: indexPath)
                    }
                    
                    cell.tblSearchLocation.reloadData()
                    cell.tblSearchLocation.layoutIfNeeded()
                    cell.tblSearchLocation.layoutSubviews()
                    return cell
                }else{
                    let NoDatacell = self.tblSearchData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    NoDatacell.lblNoDataTitle.text = "No Loads Found"
                    return NoDatacell
                }
            }else{
                if(self.arrHomeData?.count ?? 0 > 0){
                    let cell = self.tblSearchData.dequeueReusableCell(withIdentifier: SearchDataCell.className) as! SearchDataCell
                    cell.selectionStyle = .none 
                    
                    cell.lblCompanyName.text = arrHomeData?[indexPath.section][indexPath.row].shipperDetails?.companyName ?? ""
                    cell.lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (arrHomeData?[indexPath.section][indexPath.row].amount ?? "" ) : ""
                    cell.lblLoadId.text = "#\(arrHomeData?[indexPath.section][indexPath.row].id ?? 0)"
                    cell.lblTonMiles.text =   "\(arrHomeData?[indexPath.section][indexPath.row].totalWeight ?? ""), \(arrHomeData?[indexPath.section][indexPath.row].distance ?? "") Km"
                    let DeadheadValue = (arrHomeData?[indexPath.section][indexPath.row].trucks?.locations?.first?.deadhead ?? "" == "0") ? arrHomeData?[indexPath.section][indexPath.row].trucks?.truckType?.name ?? "" : "\(arrHomeData?[indexPath.section][indexPath.row].trucks?.locations?.first?.deadhead ?? "") : \(arrHomeData?[indexPath.section][indexPath.row].trucks?.truckType?.name ?? "")"
                    cell.lblDeadhead.text = DeadheadValue
                    
                    if (self.arrHomeData?[indexPath.section][indexPath.row].isBid ?? 0) == 1 {
                        cell.lblStatus.text = bidStatus.BidNow.Name
                        cell.vWStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
                    } else {
                        cell.lblStatus.text = bidStatus.BookNow.Name
                        cell.vWStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
                    }
                    
                    cell.arrLocations = arrHomeData?[indexPath.section][indexPath.row].trucks?.locations ?? []
                    
                    cell.btnMainTapCousure = {
                        self.goToDeatilScreen(index: indexPath)
                    }
                    
                    cell.tblSearchLocation.reloadData()
                    cell.tblSearchLocation.layoutIfNeeded()
                    cell.tblSearchLocation.layoutSubviews()
                    
                    return cell
                }else{
                    let NoDatacell = self.tblSearchData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    NoDatacell.lblNoDataTitle.text = "No Loads Found"
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
                print("call from scroll..")
                self.callSearchDataAPI()
            }
        }
    }
    
}
