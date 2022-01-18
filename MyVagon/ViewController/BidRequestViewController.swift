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
    var arrBidsData : [MyLoadsNewPostedTruck]?
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
        self.postTruckBidsViewModel.BidRequest(ReqModel: reqModel)
    }
    
    func callAPIForAcceptReject(Accepted:Bool,bookingID:String,loadDetails:MyLoadsNewPostedTruck?,isForBook:Bool,RemainingsMinute:Int = 0) {
        
        
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: BidAcceptRejectViewController.storyboardID) as! BidAcceptRejectViewController
        controller.bidRequestViewController = self
        controller.LoadDetails = loadDetails
            controller.isAccept = Accepted
        controller.isForBook = isForBook
        let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(22)] as [NSAttributedString.Key : Any]
        
        
        if isForBook {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ReasonForCancelBookViewController.storyboardID) as! ReasonForCancelBookViewController
                        controller.hidesBottomBarWhenPushed = true
            controller.arrayForSort = [  SortModel(Title: "Rate too low", IsSelect: true),
                                         SortModel(Title: "Pickup window", IsSelect: false),
                                         SortModel(Title: "Delivery window", IsSelect: false),
                                         SortModel(Title: "Equipment issue", IsSelect: false),
                                         SortModel(Title: "Delayed by previous receiver", IsSelect: false),
                                         SortModel(Title: "Other", IsSelect: false)]
            controller.remainingsMinute = RemainingsMinute
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((6 * 50) + 110) + appDel.GetSafeAreaHeightFromBottom())])
                    self.present(sheetController, animated: true, completion: nil)
            
            
//
//            let AttributedStringFinal = "Are you sure you want to ".Medium(color: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), FontSize: 16)
//
//                AttributedStringFinal.append("decline".Medium(color: #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), FontSize: 16))
//
//            AttributedStringFinal.append(" the book request?".Medium(color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), FontSize: 16))
//
//            controller.TitleAttributedText = AttributedStringFinal
//
//            controller.TitleAttributedText = NSAttributedString(string: "Book Request", attributes: TitleAttribute)
//            controller.DescriptionAttributedText = AttributedStringFinal
//
            
            
        } else {
           
            let AttributedStringFinal = "Are you sure you want to ".Medium(color: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), FontSize: 16)
            if Accepted {
                AttributedStringFinal.append("accept".Medium(color: #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1), FontSize: 16))
            } else {
                AttributedStringFinal.append("decline".Medium(color: #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), FontSize: 16))
            }
            
            AttributedStringFinal.append(" the bid request?".Medium(color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), FontSize: 16))
            
            controller.TitleAttributedText = AttributedStringFinal
            
            controller.TitleAttributedText = NSAttributedString(string: "Bid Request", attributes: TitleAttribute)
            controller.DescriptionAttributedText = AttributedStringFinal
        }
        
      
        controller.IsHideImage = true
        controller.LeftbtnTitle = "Cancel"
        controller.RightBtnTitle = "Yes"
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        controller.LeftbtnClosour = {
            controller.view.backgroundColor = .clear
            controller.dismiss(animated: true, completion: nil)
        }
        controller.RightbtnClosour = {
            
            controller.view.backgroundColor = .clear
            controller.dismiss(animated: true, completion: nil)
        }
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(220) + appDel.GetSafeAreaHeightFromBottom())])
        self.present(sheetController, animated: true, completion: nil)
     
    }
    
}
extension BidRequestViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading {
            return 2
        }
        if arrBidsData?.count != 0
        {
            //tableView.separatorStyle = .singleLine
            return 2
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

        return 0
        // return arrHomeData?.count ?? 0// arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            if section == 0 {
                return 0
            }
            return 5
        }
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
            cell.isLoading = self.isLoading
            if !isLoading {
                
                let BookingDetails = arrBidsData?[indexPath.row].bookingInfo
                cell.btnAccept.layer.borderWidth = 1
                cell.btnReject.layer.borderWidth = 1
                let TimeToCancel = (30*60)-(arrBidsData?[indexPath.row].time_difference ?? 0)

                if (BookingDetails?.isBid ?? 0) == 1 {
                    cell.acceptRejectClosour = { (isAccept) in
                        if isAccept {
                            self.callAPIForAcceptReject(Accepted: true, bookingID: "\(self.arrBidsData?[indexPath.row].id ?? 0)", loadDetails: self.arrBidsData?[indexPath.row], isForBook: false)
                        } else {
                            self.callAPIForAcceptReject(Accepted: false, bookingID: "\(self.arrBidsData?[indexPath.row].id ?? 0)", loadDetails: self.arrBidsData?[indexPath.row], isForBook: false)
                        }
                        
                    }
                } else {
                    let minutes = TimeToCancel / 60
                    cell.acceptRejectClosour = { (isAccept) in
                        self.callAPIForAcceptReject(Accepted: false, bookingID: "\(self.arrBidsData?[indexPath.row].id ?? 0)", loadDetails: self.arrBidsData?[indexPath.row], isForBook: true,RemainingsMinute: minutes)
                        
                    }
                   
                }
                
                cell.lblPrice.text = Currency + (BookingDetails?.amount ?? "")
                cell.lblCompanyName.text = BookingDetails?.shipperDetails?.companyName ?? ""
                
                cell.lblOfferPrice.text = "10% ↑"
                cell.lblRatting.text = "(4)"
                cell.lblWeightAndMiles.text = "\(BookingDetails?.totalWeight ?? "0 KG"), \(BookingDetails?.distance ?? "") Km"
                
                cell.lblDeadhead.text = "\(Double(BookingDetails?.trucks?.locations?.first?.deadhead ?? "0") ?? 0.0) Km Deadhead"
              
                cell.lblTruckType.text = BookingDetails?.trucks?.truckType?.name ?? "Truck type"
                
                let StringURLForProfile = "\(APIEnvironment.TempProfileURL)\(BookingDetails?.shipperDetails?.profile ?? "")"
                cell.imgCompany.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgCompany.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
               
                cell.viewCosoms.rating = 4
                cell.viewCosoms.isHidden = false
                cell.PickUpDropOffData = BookingDetails?.trucks?.locations
                
                cell.btnAccept.isHidden = ((BookingDetails?.isBid ?? 0) == 1) ? false : true
                
                
                cell.btnReject.setTitle(((BookingDetails?.isBid ?? 0) == 1) ? "Reject" : "\( TimeToCancel / 60) minutes remaining to cancel", for: .normal)
            } else {
                cell.viewCosoms.isHidden = true
                cell.btnAccept.layer.borderWidth = 0
                cell.btnReject.layer.borderWidth = 0
            }
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
        if indexPath.section == 0 {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckBidsViewController.storyboardID) as! PostedTruckBidsViewController
            controller.NumberOfCount = BidsData?.postedTruck?.count ?? 0

            controller.hidesBottomBarWhenPushed = true
            controller.PostTruckID = "\(BidsData?.postedTruck?.id ?? 0)"
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: BidRequestDetailViewController.storyboardID) as! BidRequestDetailViewController
            controller.hidesBottomBarWhenPushed = true
            controller.LoadDetails = self.arrBidsData?[indexPath.row]
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
      
        
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
                let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((3 * 50) + 110) + appDel.GetSafeAreaHeightFromBottom())])
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
    @IBOutlet weak var btnAccept: themeButton!
    @IBOutlet weak var btnReject: themeButton!
    
    
    
    @IBAction func btnAcceptClick(_ sender: themeButton) {
        if let click = self.acceptRejectClosour{
            click(true)
        }
    }
    
    @IBAction func btnRejectClick(_ sender: themeButton) {
        if let click = self.acceptRejectClosour{
            click(false)
        }
    }
    
    var isLoading : Bool = false

    
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!
    
    
    var PickUpDropOffData : [MyLoadsNewLocation]?
    
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
        if  isLoading {
            return 2
        }
        return PickUpDropOffData?.count ?? 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if !isLoading {
            if PickUpDropOffData?[indexPath.row].isPickup == 0 && (indexPath.row != 0 || indexPath.row != PickUpDropOffData?.count) {
                cell.imgLocation.image = UIImage(named: "ic_pickDrop")
            } else {
                cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
            }
            
            
       
        
        cell.lblAddress.text = PickUpDropOffData?[indexPath.row].dropLocation
        
        cell.BtnShowMore.superview?.isHidden = true
        cell.lblCompanyName.text = PickUpDropOffData?[indexPath.row].companyName
        
        if (PickUpDropOffData?.count ?? 0) == 1 {
            cell.viewLine.isHidden = true
        } else {
            
            cell.viewLine.isHidden = (indexPath.row == ((PickUpDropOffData?.count ?? 0) - 1)) ? true : false
        }
            var StringForDateTime = ""
            StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
            StringForDateTime.append(" ")
            
            if (PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "") == (PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? "") {
                StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "")")
            } else {
                StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "")-\(PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? "")")
            }
            cell.lblDateTime.text = StringForDateTime
        }
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
