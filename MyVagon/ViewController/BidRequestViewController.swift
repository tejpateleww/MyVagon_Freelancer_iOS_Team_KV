//
//  BidRequestViewController.swift
//  MyVagon
//
//  Created by Apple on 01/12/21.
//

import UIKit
import Cosmos
import SDWebImage
import FittedSheets
class BidRequestViewController: BaseViewController {
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var BidsData : MyLoadsNewDatum?
    let postTruckBidsViewModel = PostTruckBidsViewModel()
    var PostTruckID = ""
    var arrBidsData : [SearchLoadsDatum]?
    var isLoading = true {
        didSet {
            tblAvailableData.isUserInteractionEnabled = !isLoading
            tblAvailableData.reloadDataWithAutoSizingCellWorkAround()
        }
    }
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblAvailableData: UITableView!
    
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        tblAvailableData.register(UINib(nibName: "MyLoadesCell", bundle: nil), forCellReuseIdentifier: "MyLoadesCell")
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Bid Request", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.option.value], isTranslucent: true, ShowShadow: true)
        callAPI()
        
        tblAvailableData.delegate = self
        tblAvailableData.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
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
    func callAPI() {
        self.postTruckBidsViewModel.bidRequestViewController =  self
        
        let reqModel = PostTruckBidReqModel()
        reqModel.availability_id = PostTruckID
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        self.postTruckBidsViewModel.PostedTruckBid(ReqModel: reqModel)
    }
    
    func callAPIForAcceptReject(Accepted:Bool) {
        self.postTruckBidsViewModel.bidRequestViewController =  self
        
        let reqModel = BidAcceptRejectReqModel()
        reqModel.availability_id = PostTruckID
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.is_accept = (Accepted == true) ? "1" : "0"
        self.postTruckBidsViewModel.AcceptReject(ReqModel: reqModel)
    }
    
}
extension BidRequestViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        if arrBidsData?.count != 0
        {
            //tableView.separatorStyle = .singleLine
            return 2
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
        if section == 0 {
            return 1
        }
        return arrBidsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "MyLoadesCell", for: indexPath) as! MyLoadesCell
            if !isLoading {
                cell.isLoading = self.isLoading
                cell.myloadDetails = BidsData
                cell.isShowFooter =  true
                
                cell.tblHeight = { (heightTBl) in
                    self.tblAvailableData.layoutIfNeeded()
                    self.tblAvailableData.layoutSubviews()
                }
                cell.tblMultipleLocation.reloadData()
                cell.tblMultipleLocation.layoutIfNeeded()
                cell.tblMultipleLocation.layoutSubviews()
                
                
            }
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PostAvailabilityRequestCell", for: indexPath) as! PostAvailabilityRequestCell
            
            cell.acceptRejectClosour = { (isAccept) in
                if isAccept {
                    self.callAPIForAcceptReject(Accepted: true)
                } else {
                    self.callAPIForAcceptReject(Accepted: true)
                }
                
            }
            
            let BookingDetails = arrBidsData?[indexPath.row]
            
            cell.lblPrice.text = Currency + (BookingDetails?.amount ?? "")
            cell.lblCompanyName.text = BookingDetails?.shipperDetails?.name ?? ""
            cell.lblOfferPrice.text = "10% ↑"
            cell.lblRatting.text = "(4)"
            cell.lblWeightAndMiles.text = "\(BookingDetails?.totalWeight ?? ""), \(BookingDetails?.distance ?? "") Km"
            cell.lblDeadhead.text = (BookingDetails?.trucks?.locations?.first?.deadhead ?? "" == "0") ? BookingDetails?.trucks?.truckType?.name ?? "" : "\(BookingDetails?.trucks?.locations?.first?.deadhead ?? "") : \(BookingDetails?.trucks?.truckType?.name ?? "")"
            cell.lblTruckType.text = BookingDetails?.trucks?.truckType?.name ?? ""
            
            let StringURLForProfile = "\(APIEnvironment.TempProfileURL.rawValue)\(BookingDetails?.shipperDetails?.profile ?? "")"
            cell.imgCompany.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgCompany.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
            
            
            cell.viewCosoms.rating = 4
            
            
            
            cell.PickUpDropOffData = arrBidsData?[indexPath.row].trucks?.locations
            
            
            cell.tblHeight = { (heightTBl) in
                self.tblAvailableData.layoutIfNeeded()
                self.tblAvailableData.layoutSubviews()
            }
            cell.tblMultipleLocation.reloadData()
            cell.tblMultipleLocation.layoutIfNeeded()
            cell.tblMultipleLocation.layoutSubviews()
            
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        
        if tableView == tblAvailableData {
            
            //
            //            if indexPath.row == ((arrHomeData?[indexPath.section].count ?? 0) - 1) && isNeedToReload == true
            //                {
            //                    let spinner = UIActivityIndicatorView(style: .medium)
            //                    spinner.tintColor = RefreshControlColor
            //                    spinner.startAnimating()
            //                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblLocations.bounds.width, height: CGFloat(44))
            //
            //                    self.tblLocations.tableFooterView = spinner
            //                    self.tblLocations.tableFooterView?.isHidden = false
            //                    CallWebSerive()
            //                }
            //
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isLoading {
            if section == 1 {
                return "\(arrBidsData?.count ?? 0) Matches Found"
            }
            return ""
            
        }
        return ""
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isLoading {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let cell =  tblAvailableData.dequeueReusableCell(withIdentifier: "bidRequestHeaderCell") as! bidRequestHeaderCell
            cell.lblMatchesFound.text = "\(arrBidsData?.count ?? 0) Matches Found"
            cell.btnSortClosour = {
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupViewController.storyboardID) as! SortPopupViewController
                controller.hidesBottomBarWhenPushed = true
                controller.arrayForSort = [  SortModel(Title: "Price : Low to high", IsSelect: true),
                                             SortModel(Title: "Price : High to Low", IsSelect: false),
                                             SortModel(Title: "Min Deadheading", IsSelect: false)]
                let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((3 * 50) + 110))])
                self.present(sheetController, animated: true, completion: nil)
            }
            
            headerView.addSubview(cell)
            
            return cell
           
        } else {
            return UIView()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading{
            return 0
        }else{
            if section == 1 {
                return 48
            }
            return 0
        }
    }
}

class PostAvailabilityRequestCell : UITableViewCell {
    
    var acceptRejectClosour:((Bool)->())?
    
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblOfferPrice: themeLabel!
    @IBOutlet weak var lblRatting: themeLabel!
    @IBOutlet weak var lblWeightAndMiles: themeLabel!
    @IBOutlet weak var lblDeadhead: themeLabel!
    @IBOutlet weak var lblTruckType: themeLabel!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var viewCosoms: CosmosView!
    
    
    
    @IBAction func btnAccept(_ sender: themeButton) {
        if let click = self.acceptRejectClosour{
            click(true)
        }
    }
    
    @IBAction func btnSortClick(_ sender: themeButton) {
        if let click = self.acceptRejectClosour{
            click(false)
        }
    }
    
    
    
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!
    
    
    var PickUpDropOffData : [SearchLocation]?
    
    var tblHeight:((CGFloat)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // tblMultipleLocation.backgroundColor = .clear
        
        if tblMultipleLocation.observationInfo != nil {
            self.tblMultipleLocation.removeObserver(self, forKeyPath: "contentSize")
        }
        self.tblMultipleLocation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblMultipleLocation.dataSource = self
        tblMultipleLocation.delegate = self
        tblMultipleLocation.rowHeight = UITableView.automaticDimension
        tblMultipleLocation.estimatedRowHeight = 100
        tblMultipleLocation.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblMultipleLocation.register(UINib(nibName: "BidRequestTblCell", bundle: nil), forCellReuseIdentifier: "BidRequestTblCell")
        tblMultipleLocation.register(UINib(nibName: "ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        // tblMultipleLocation.reloadData()
        
        
        //        tblMultipleLocation.register(UINib(nibName: "HeaderTblViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTblViewCell")
        
        tblMultipleLocation.register(UINib(nibName: "HeaderOfLocationsTbl", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderOfLocationsTbl")
        ReloadAllData()
        //self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()
    }
    func ReloadAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tblMultipleLocation.layoutIfNeeded()
            self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()//reloadDataWithAutoSizingCellWorkAround()
        })
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //viewContainer is the parent of viewContents
        //viewContents contains all the UI which you want to show actually.
        self.viewContents.layoutIfNeeded()
        tblMultipleLocation.layer.cornerRadius = 15
        tblMultipleLocation.clipsToBounds = true
        self.viewContents.layer.cornerRadius = 15
        self.viewContents.layer.masksToBounds = true
        
        let bezierPath = UIBezierPath.init(roundedRect: self.viewContents.bounds, cornerRadius: 15)
        self.viewContents.layer.shadowPath = bezierPath.cgPath
        self.viewContents.layer.masksToBounds = false
        self.viewContents.layer.shadowColor = UIColor.black.cgColor
        self.viewContents.layer.shadowRadius = 3.0
        self.viewContents.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.viewContents.layer.shadowOpacity = 0.3
        
        // sending viewContainer color to the viewContents.
        // let backgroundCGColor =
        //You can set your color directly if you want by using below two lines. In my case I'm copying the color.
        self.viewContents.backgroundColor = nil
        self.viewContents.layer.backgroundColor =  UIColor.white.cgColor
        tblMultipleLocation.tableFooterView?.isHidden = true
        // self.tblMultipleLocation.contentInset = UIEdgeInsets(top: -11, left: 0, bottom: 0, right: 0)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.conHeightOfTbl.constant = newsize.height
                
                
                if let getHeight  = tblHeight.self {
                    self.tblMultipleLocation.layoutSubviews()
                    self.tblMultipleLocation.layoutIfNeeded()
                    getHeight(self.tblMultipleLocation.contentSize.height)
                    
                    
                    
                }
                
            }
        }
    }
    
}
extension PostAvailabilityRequestCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PickUpDropOffData?.count ?? 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
        
        cell.lblAddress.text = PickUpDropOffData?[indexPath.row].dropLocation
        
        cell.BtnShowMore.superview?.isHidden = true
        cell.lblCompanyName.text = PickUpDropOffData?[indexPath.row].companyName
        
        if (PickUpDropOffData?.count ?? 0) == 1 {
            cell.viewLine.isHidden = true
        } else {
            
            cell.viewLine.isHidden = (indexPath.row == ((PickUpDropOffData?.count ?? 0) - 1)) ? true : false
        }
        
        cell.lblDateTime.text = "\(PickUpDropOffData?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? ""))"
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
class bidRequestHeaderCell : UITableViewCell {
    @IBOutlet weak var lblMatchesFound: themeLabel!
    @IBOutlet weak var btnSort: themeButton!
    var btnSortClosour:(()->())?
    
    @IBAction func btnSortClick(_ sender: themeButton) {
        if let click = self.btnSortClosour {
            click()
        }
      
        
        
    }
}
