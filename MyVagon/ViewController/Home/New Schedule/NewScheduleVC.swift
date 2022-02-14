//
//  NewScheduleVC.swift
//  MyVagon
//
//  Created by Dhananjay  on 02/02/22.
//

import UIKit
import DropDown

enum NewScheduleStatus {

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
            return "in-progress"
        case .past:
            return "past"
        case .completed:
            return "completed"
        case .canceled:
            return "cancelled"
        }
    }
}

class NewScheduleVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    @IBOutlet weak var tblScheduleData: UITableView!
    
    var optionMenuDropDown = DropDown()
    var optionArray : [String] = ["All","Bid","Book","Posted truck"]
    var arrStatus:[NewScheduleStatus] = [.all,.pending,.scheduled,.inprocess,.past]
    var selectedIndex = 0
    var PageNumber = 0
    var myScheduleViewModel = MyScheduleViewModel()
    var CurrentFilterStatus : NewScheduleStatus = .all
    
    // Pull to refresh
    let refreshControl = UIRefreshControl()
    
    //shimmer
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblScheduleData.isUserInteractionEnabled = !isLoading
            self.tblScheduleData.reloadData()
        }
    }
    var isNeedToReload = true
    var arrMyScheduleData : [[MyLoadsNewDatum]]?
    
    //MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        setNavigationBar(subTitle: "")
        
        self.tblScheduleData.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        self.tblScheduleData.delegate = self
        self.tblScheduleData.dataSource = self
        self.tblScheduleData.separatorStyle = .none
        self.tblScheduleData.showsHorizontalScrollIndicator = false
        self.tblScheduleData.showsVerticalScrollIndicator = false
        
        self.registerNib()
        self.addRefreshControl()
        self.addObserver()
    }
    
    func setupData(){
        self.collectionOfHistory.dataSource = self
        self.collectionOfHistory.delegate = self
        self.setupOptionMenu()
        CallWebSerive(status: self.CurrentFilterStatus)
        self.btnOptionClosour = {
            self.optionMenuDropDown.show()
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: ScheduleDataCell.className, bundle: nil)
        self.tblScheduleData.register(nib, forCellReuseIdentifier: ScheduleDataCell.className)
        let nib2 = UINib(nibName: EarningShimmerCell.className, bundle: nil)
        self.tblScheduleData.register(nib2, forCellReuseIdentifier: EarningShimmerCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblScheduleData.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    func addObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshViewForPostTruck), name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil)
    }
    
    func setupOptionMenu() {
        self.optionMenuDropDown.anchorView = btnOption
        self.optionMenuDropDown.dataSource = optionArray
        self.optionMenuDropDown.selectRow(at: 0)
        
        self.optionMenuDropDown.selectionAction = { [] (index, item) in
            if self.optionArray[index] == "All" {
                self.setNavigationBar(subTitle: "")
            } else {
                self.setNavigationBar(subTitle: self.optionArray[index])
            }
            self.reloadSearchData()
        }
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblScheduleData.addSubview(self.refreshControl)
    }
    
    func reloadSearchData(){
        self.PageNumber = 0
        self.arrMyScheduleData = []
        self.isTblReload = false
        self.isLoading = true
        self.CallWebSerive(status: self.CurrentFilterStatus)
    }
    
    func setNavigationBar(subTitle:String){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Loads", leftImage: NavItemsLeft.none.value, rightImages:  [NavItemsRight.option.value], isTranslucent: true, ShowShadow: true,subTitleString: subTitle)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadSearchData()
    }
    
    @objc func RefreshViewForPostTruck() {
        self.PageNumber = 0
        self.arrMyScheduleData = []
        self.isTblReload = false
        self.isLoading = true
        self.CallWebSerive(status: CurrentFilterStatus)
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnPostTruck(_ sender: Any) {
        let controller = PostTruckViewController.instantiate(fromAppStoryboard: .Home)
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - Api Methods
extension NewScheduleVC{
    
    func CallWebSerive(status:NewScheduleStatus) {
        self.PageNumber = self.PageNumber + 1
        self.myScheduleViewModel.scheduleViewController =  self
        let ReqModelForMyLoades = MyLoadsReqModel()
        ReqModelForMyLoades.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        ReqModelForMyLoades.page_num = "\(self.PageNumber)"
        ReqModelForMyLoades.status = status.Name
        ReqModelForMyLoades.type = self.optionMenuDropDown.selectedItem?.lowercased().replacingOccurrences(of: " ", with: "_")
        self.myScheduleViewModel.getMyloads(ReqModel: ReqModelForMyLoades)
    }
    
}
//MARK: - UICollectionView Delegate and Data Sourse Methods
extension NewScheduleVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
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
        return CGSize(width: ((arrStatus[indexPath.row].Name.capitalized).sizeOfString(usingFont: CustomFont.PoppinsRegular.returnFont(14)).width) + 30, height: collectionOfHistory.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.PageNumber = 0
        self.arrMyScheduleData = []
        self.isTblReload = false
        self.isLoading = true
        self.CurrentFilterStatus = arrStatus[indexPath.row]
        self.CallWebSerive(status: CurrentFilterStatus)
        self.selectedIndex = indexPath.row
        self.collectionOfHistory.reloadData()
    }
    
}
//MARK: - UITableView Delegate and Data Sourse Methods
extension NewScheduleVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading {
            return 1
        }
        return (arrMyScheduleData?.count ?? 0 == 0) ? 1 : arrMyScheduleData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arrMyScheduleData?.count ?? 0 > 0){
            return self.arrMyScheduleData?[section].count ?? 0
        }else{
            return (!self.isTblReload) ? 10 : 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (!self.isTblReload){
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningShimmerCell", for: indexPath) as! EarningShimmerCell
            cell.selectionStyle = .none
            return cell
        }else{
            if arrMyScheduleData?.count ?? 0 > 0{
            let cell = self.tblScheduleData.dequeueReusableCell(withIdentifier: "ScheduleDataCell", for: indexPath) as! ScheduleDataCell
            cell.selectionStyle = .none
            cell.lblScheduleType.text = arrMyScheduleData?[indexPath.section][indexPath.row].type?.capitalized
                cell.tblData = arrMyScheduleData?[indexPath.section][indexPath.row]
                switch arrMyScheduleData?[indexPath.section][indexPath.row].type{
                case MyLoadType.Bid.Name:
                    cell.setData(data: arrMyScheduleData?[indexPath.section][indexPath.row].bid)
                case MyLoadType.Book.Name:
                    cell.setData(data: arrMyScheduleData?[indexPath.section][indexPath.row].book)
                case MyLoadType.PostedTruck.Name:
                    cell.lblScheduleType.text = "Posted Truck"
                    cell.setPostedTruck(lodeData: arrMyScheduleData?[indexPath.section][indexPath.row].postedTruck)
                default :
                    break
                }

                cell.tblSearchLocation.reloadData()
                cell.tblSearchLocation.layoutIfNeeded()
                cell.tblSearchLocation.layoutSubviews()
                cell.btnMatchTapCousure = {
                    self.handalMatchAction(myloadDetails: self.arrMyScheduleData?[indexPath.section][indexPath.row])
                }
            return cell
        }else{
            let NoDatacell = self.tblScheduleData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            NoDatacell.lblNoDataTitle.text = "No Loads Found"
            return NoDatacell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoading {return UIView()}
        if self.arrMyScheduleData?.count ?? 0 > 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
            let label = UILabel()
            label.frame = headerView.frame
            label.text = arrMyScheduleData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
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
        if !isLoading{
            if indexPath.section == ((arrMyScheduleData?.count ?? 0) - 1){
                if indexPath.row == ((arrMyScheduleData?[indexPath.section].count ?? 0) - 1) && isNeedToReload {
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.tintColor = RefreshControlColor
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblScheduleData.bounds.width, height: CGFloat(44))
                    
                    self.tblScheduleData.tableFooterView = spinner
                    self.tblScheduleData.tableFooterView?.isHidden = false
                    CallWebSerive(status: CurrentFilterStatus)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!isTblReload){
            return UITableView.automaticDimension
        }else{
            if(arrMyScheduleData?.count ?? 0 > 0){
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (arrMyScheduleData?[indexPath.section][indexPath.row].type == MyLoadType.PostedTruck.Name) == true {
            let myloadDetails = arrMyScheduleData?[indexPath.section][indexPath.row]
            if myloadDetails?.postedTruck?.bookingInfo != nil {
                if !isLoading {
                    WebServiceSubClass.SystemDateTime { (_, _, _, _) in
                        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SchedualLoadDetailsViewController.storyboardID) as! SchedualLoadDetailsViewController
                        controller.hidesBottomBarWhenPushed = true
                        controller.LoadDetails = self.arrMyScheduleData?[indexPath.section][indexPath.row].postedTruck?.bookingInfo
                        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            } 
        } else {
            if !isLoading {
                WebServiceSubClass.SystemDateTime { (_, _, _, _) in
                    let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SchedualLoadDetailsViewController.storyboardID) as! SchedualLoadDetailsViewController
                    controller.hidesBottomBarWhenPushed = true
                    controller.strLoadStatus = self.arrMyScheduleData?[indexPath.section][indexPath.row].type ?? ""
                    if (self.arrMyScheduleData?[indexPath.section][indexPath.row].type == MyLoadType.Bid.Name) {
                        controller.LoadDetails = self.arrMyScheduleData?[indexPath.section][indexPath.row].bid
                    } else {
                        controller.LoadDetails = self.arrMyScheduleData?[indexPath.section][indexPath.row].book
                    }
                    UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func handalMatchAction(myloadDetails :MyLoadsNewDatum?){
        if (myloadDetails?.postedTruck?.bookingRequestCount ?? 0) != 0 {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: BidRequestViewController.storyboardID) as! BidRequestViewController
            controller.BidsData = myloadDetails
            controller.hidesBottomBarWhenPushed = true
            controller.PostTruckID = "\(myloadDetails?.postedTruck?.id ?? 0)"
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            if (myloadDetails?.postedTruck?.matchesCount ?? 0) != 0 {
                let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckBidsViewController.storyboardID) as! PostedTruckBidsViewController
                controller.NumberOfCount = myloadDetails?.postedTruck?.matchesCount ?? 0
                controller.hidesBottomBarWhenPushed = true
                controller.PostTruckID = "\(myloadDetails?.postedTruck?.id ?? 0)"
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
