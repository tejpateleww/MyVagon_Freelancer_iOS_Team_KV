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
    var PageNumber = 0
    var numberOfSections = 0
    //var arrHomeData : [SearchLoadsDatum] = []
    var arrHomeData : [[SearchLoadsDatum]]?
    
    // Pull to refresh
    let refreshControl = UIRefreshControl()
    
    //shimmer
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblSearchData.isUserInteractionEnabled = !isLoading
            self.tblSearchData.reloadData()
        }
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.tblSearchData.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
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
        
        self.registerNib()
        self.addRefreshControl()
    }
    
    func setupData(){
        self.callSearchDataAPI()
        self.checkLocationPermission()
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
        self.PageNumber = 0
        self.arrHomeData = []
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
    
    //MARK: - UIButton Action methods
    @IBAction func btnSortAction(_ sender: Any) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupViewController.storyboardID) as! SortPopupViewController
        controller.hidesBottomBarWhenPushed = true
        controller.delegate = self
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((5 * 50) + 110) + appDel.GetSafeAreaHeightFromBottom())])
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
        self.sortBy = strSort
        self.reloadSearchData()
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
        if isLoading {return 1}
        return self.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrHomeData?.count ?? 0 > 0 {
            return arrHomeData?[section].count ?? 0
        } else {
            return (!self.isTblReload) ? 10 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblSearchData.dequeueReusableCell(withIdentifier: EarningShimmerCell.className) as! EarningShimmerCell
        cell.selectionStyle = .none
        if(!self.isTblReload){
            return cell
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
                    cell.lblStatus.text =  bidStatus.BookNow.Name
                    cell.vWStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
                }
                
                cell.arrLocations = arrHomeData?[indexPath.section][indexPath.row].trucks?.locations ?? []
                cell.tblHeight = { (heightTBl) in
                    self.tblSearchData.layoutIfNeeded()
                    self.tblSearchData.layoutSubviews()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isLoading {return ""}
        return arrHomeData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoading {return UIView()}
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
        if isLoading {return 0}
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: LoadDetailsVC.storyboardID) as! LoadDetailsVC
            controller.hidesBottomBarWhenPushed = true
            controller.LoadDetails = arrHomeData?[indexPath.section][indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(!isTblReload){
            return UITableView.automaticDimension
        }else{
            if self.arrHomeData?.count ?? 0 != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
}
