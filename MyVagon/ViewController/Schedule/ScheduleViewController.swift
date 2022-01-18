//
//  ViewLoadAllScreenVC1.swift
//  MyVagon
//
//  Created by Admin on 11/08/21.
//

import UIKit
import FSCalendar
import DropDown
import CoreLocation
enum MyLoadesStatus {
    
    case all,pending,scheduled,inprocess,past,completed,canceled
    
    var Name:String {
        switch self {
        case .all:
            return "all"
        case .pending:
            return "pending"
        case .scheduled:
            return "scheduled"
        case .inprocess:
            return "in-process"
        case .past:
            return "past"
        case .completed:
            return "completed"
        case .canceled:
            return "canceled"
        }
    }
}

class ScheduleViewController: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    @IBOutlet weak var viewPostAvailability: UIView!
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var PageNumber = 0
    
    var isNeedToReload = false
    let chooseDropDown = DropDown()
    
    var CurrentFilterStatus : MyLoadesStatus = .all
    var myLoadsViewModel = MyLoadsViewModel()
    var refreshControl = UIRefreshControl()
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var customTabBarController: CustomTabBarVC?
    var tblCellHeight = CGFloat()
    var arrStatus:[MyLoadesStatus] = [.all,.pending,.scheduled,.inprocess,.past]
    
    var selectedIndex = 0
    var arrMyLoadesData : [[MyLoadsNewDatum]]?
    var optionArray : [String] = ["All","Bid","Book","Posted truck"]
    var selectedType = "all"
    var isLoading = true {
        didSet {
            tblLocations.isUserInteractionEnabled = !isLoading
            tblLocations.reloadData()
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshViewForPostTruck), name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil)
        setupChooseDropDown()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTblHeight(_:)), name: NSNotification.Name(NotificationKeys.KGetTblHeight), object: nil)
        tblLocations.register(UINib(nibName: "MyLoadesCell", bundle: nil), forCellReuseIdentifier: "MyLoadesCell")
        tblLocations.register(UINib(nibName: "NoBookingTblCell", bundle: nil), forCellReuseIdentifier: "NoBookingTblCell")
        
        setNavigationBar(subTitle: "")
    
        
      
     
        DispatchQueue.main.async {
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.reloadData()
        }
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = RefreshControlColor
        self.tblLocations.refreshControl = refreshControl
        
        CallWebSerive(status: CurrentFilterStatus)
        
        btnOptionClosour = {
            self.chooseDropDown.show()
        }
    }
    @objc func RefreshViewForPostTruck() {
        PageNumber = 0
        CallWebSerive(status: CurrentFilterStatus)
    }
    func setNavigationBar(subTitle:String) {
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Loads", leftImage: NavItemsLeft.none.value, rightImages:  [NavItemsRight.option.value], isTranslucent: true, ShowShadow: true,subTitleString: subTitle)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
        tblLocations.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
    }
    
    @objc func getTblHeight(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let height = dict["TblHeight"] as? CGFloat{
                
                tblCellHeight = height
                tblLocations.reloadData()
                // tblLocations.reloadRows(at: [ind?.row], with: .automatic)
            }
        }
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        PageNumber = 0
        CallWebSerive(status: CurrentFilterStatus)
        
    }
    @IBAction func BtnPostTruck(_ sender: themeButton) {
       
        
        let controller = PostTruckViewController.instantiate(fromAppStoryboard: .Home)
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func CallWebSerive(status:MyLoadesStatus) {
        
        if PageNumber == 0 {
            isLoading = true
        }
        PageNumber = PageNumber + 1
        self.myLoadsViewModel.scheduleViewController =  self
        
        let ReqModelForMyLoades = MyLoadsReqModel()
        
        ReqModelForMyLoades.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        ReqModelForMyLoades.page_num = "\(PageNumber)"
        ReqModelForMyLoades.status = status.Name
      
        ReqModelForMyLoades.type = selectedType
        //        ReqModelForGetShipment.driver_id = "271"
        
        
        
        self.myLoadsViewModel.getMyloads(ReqModel: ReqModelForMyLoades)
        
    }
   
    func setupChooseDropDown() {
        chooseDropDown.anchorView = btnOption
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDown.dataSource = optionArray
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [] (index, item) in
            if index == 0 {
                self.setNavigationBar(subTitle: "")
            } else {
                self.setNavigationBar(subTitle: self.optionArray[index])
            }
            self.selectedType = self.optionArray[index].lowercased().replacingOccurrences(of: " ", with: "_")
            self.PageNumber = 0
            self.CallWebSerive(status: self.CurrentFilterStatus)
            print(item)
        }
    }
}
extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print(date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
}
extension ScheduleViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading {
            return 1
        } else {
            var numOfSections: Int = 0
            if arrMyLoadesData?.count != 0
            {
                //tableView.separatorStyle = .singleLine
                numOfSections            = arrMyLoadesData?.count ?? 0
                tableView.backgroundView = nil
            }
            else
            {
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
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 10
        }
        return arrMyLoadesData?[section].count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "MyLoadesCell", for: indexPath) as! MyLoadesCell
        cell.isLoading = self.isLoading
        if !isLoading {
         
            cell.myloadDetails = arrMyLoadesData?[indexPath.section][indexPath.row]
            cell.isShowFooter =   (arrMyLoadesData?[indexPath.section][indexPath.row].type == MyLoadType.PostedTruck.Name) ? true : false
            
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
        
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.postAvailibility ?? 0 == 1 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isLoading {
            return arrMyLoadesData?[section].first?.date ?? ""
        }
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isLoading {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
            let label = UILabel()
            label.frame = headerView.frame
            label.text = arrMyLoadesData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
            label.textAlignment = .center
            label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
            label.textColor = UIColor(hexString: "#292929")
            label.drawLineOnBothSides(labelWidth: label.frame.size.width, color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1))
            headerView.addSubview(label)
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading{
            return 0
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        
        if tableView == tblLocations {
            if indexPath.section == ((arrMyLoadesData?.count ?? 0) - 1) {
                if indexPath.row == ((arrMyLoadesData?[indexPath.section].count ?? 0) - 1) && isNeedToReload == true
                {
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.tintColor = RefreshControlColor
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblLocations.bounds.width, height: CGFloat(44))
                    
                    self.tblLocations.tableFooterView = spinner
                    self.tblLocations.tableFooterView?.isHidden = false
                    CallWebSerive(status: CurrentFilterStatus)
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (arrMyLoadesData?[indexPath.section][indexPath.row].type == MyLoadType.PostedTruck.Name) == true {
//            if (arrMyLoadesData?[indexPath.section][indexPath.row].postedTruck?.isBid ?? 0) == 1 {
//                
//            }
            
            
            let myloadDetails = arrMyLoadesData?[indexPath.section][indexPath.row]
            if myloadDetails?.postedTruck?.bookingInfo != nil {
                if !isLoading {
                    WebServiceSubClass.SystemDateTime { (_, _, _, _) in
                        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SchedualLoadDetailsViewController.storyboardID) as! SchedualLoadDetailsViewController
                        controller.hidesBottomBarWhenPushed = true
                        controller.LoadDetails = self.arrMyLoadesData?[indexPath.section][indexPath.row].postedTruck?.bookingInfo
                        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            } else {
                if (myloadDetails?.postedTruck?.bookingRequestCount ?? 0) != 0 {
                    if (myloadDetails?.postedTruck?.isBid ?? 0) == 1 {
                        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: BidRequestViewController.storyboardID) as! BidRequestViewController
                        controller.BidsData = arrMyLoadesData?[indexPath.section][indexPath.row]
                        controller.hidesBottomBarWhenPushed = true
                        controller.PostTruckID = "\(arrMyLoadesData?[indexPath.section][indexPath.row].postedTruck?.id ?? 0)"
                        self.navigationController?.pushViewController(controller, animated: true)
                    } else {

                    }
                }  else {
                    if (myloadDetails?.postedTruck?.matchesCount ?? 0) != 0 {

                        if (myloadDetails?.postedTruck?.isBid ?? 0) == 1 {
                            
                            
                            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckBidsViewController.storyboardID) as! PostedTruckBidsViewController
                            controller.NumberOfCount = myloadDetails?.postedTruck?.matchesCount ?? 0

                            controller.hidesBottomBarWhenPushed = true
                            controller.PostTruckID = "\(myloadDetails?.postedTruck?.id ?? 0)"
                            self.navigationController?.pushViewController(controller, animated: true)
                            
                        } else {
                          
                         
                        }
                    } else {
                      
                    }
                }
            }
        } else {
            if !isLoading {
                WebServiceSubClass.SystemDateTime { (_, _, _, _) in
                    let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SchedualLoadDetailsViewController.storyboardID) as! SchedualLoadDetailsViewController
                    controller.hidesBottomBarWhenPushed = true
                    controller.strLoadStatus = self.arrMyLoadesData?[indexPath.section][indexPath.row].type ?? ""
                    if (self.arrMyLoadesData?[indexPath.section][indexPath.row].type == MyLoadType.Bid.Name) {
                        controller.LoadDetails = self.arrMyLoadesData?[indexPath.section][indexPath.row].bid
                    } else {
                        controller.LoadDetails = self.arrMyLoadesData?[indexPath.section][indexPath.row].book
                    }
                    UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
                }
               
            }
        }
//        if (indexPath.row % 2) == 0 {
//            print("View Match Clicked")
//        }
////        cell.btnViewMatchFoundClick = { (selected) in
////            if (selected.row % 2) == 0 {
////                print("View Match Clicked")
////            }
////
////        }
        
    }
}

extension ScheduleViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.lblStatus.text = arrStatus[indexPath.row].Name.capitalized
        cell.lblStatus.textColor =  selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor(hexString: "#9A9AA9")
        cell.viewBG.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((arrStatus[indexPath.row].Name.capitalized).sizeOfString(usingFont: CustomFont.PoppinsRegular.returnFont(14)).width) + 30
                      , height: collectionOfHistory.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PageNumber = 0
        CurrentFilterStatus = arrStatus[indexPath.row]
        CallWebSerive(status: CurrentFilterStatus)
        selectedIndex = indexPath.row
        collectionOfHistory.reloadData()
        tblLocations.reloadData()
        
    }
    
}
extension ScheduleViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(optionArray[row])
    }
    
    
    
}





