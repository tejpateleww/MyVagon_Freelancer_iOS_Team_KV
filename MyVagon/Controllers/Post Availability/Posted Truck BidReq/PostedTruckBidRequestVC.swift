//
//  PostedTruckBidRequestVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 13/06/22.
//

import UIKit
import FittedSheets
import SDWebImage

class PostedTruckBidRequestVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var lblId: themeLabel!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var lblType: themeLabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: themeLabel!
    @IBOutlet weak var lblCompnyName: themeLabel!
    @IBOutlet weak var lblAmount: themeLabel!
    @IBOutlet weak var btnMatchFound: UIButton!
    @IBOutlet weak var lblMatchFount: themeLabel!
    @IBOutlet weak var btnSortBy: themeButton!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var tblLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var tblBidRequestHeight: NSLayoutConstraint!
    @IBOutlet weak var tblBidRequest: UITableView!
    @IBOutlet weak var viewContents: UIView!
    
    
    //MARK: - Variable
    var BidsData : MyLoadsNewDatum?
    var PostTruckID = ""
    var sortBy = ""
    let postTruckBidsViewModel = NewPostTruckBidsViewModel()
    var arrBidsData : [MyLoadsNewPostedTruck]?
    var isLoading = true {
        didSet {
            tblBidRequest.isUserInteractionEnabled = !isLoading
            tblBidRequest.reloadDataWithAutoSizingCellWorkAround()
        }
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblBidRequestHeight.constant = newsize.height
            }
        }
    }
    
    //MARK: - Custom methods
    func setUpUI(){
        self.setMainView()
        self.setUpMatchFoundBtn()
        self.btnSortBy.setTitle("Sort by".localized, for: .normal)
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "bidRequestTitle".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.viewStatus.roundCornerssingleSide(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        self.viewType.layer.cornerRadius = self.viewStatus.frame.height / 2
    }
    
    func setMainView(){
        self.viewContents.layoutIfNeeded()
        self.viewContents.layer.cornerRadius = 15
        self.viewContents.layer.masksToBounds = true
        let bezierPath = UIBezierPath.init(roundedRect: self.viewContents.bounds, cornerRadius: 15)
        self.viewContents.layer.shadowPath = bezierPath.cgPath
        self.viewContents.layer.masksToBounds = false
        self.viewContents.layer.shadowColor = UIColor.black.cgColor
        self.viewContents.layer.shadowRadius = 3.0
        self.viewContents.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.viewContents.layer.shadowOpacity = 0.3
        self.viewContents.backgroundColor = nil
        self.viewContents.layer.backgroundColor =  UIColor.white.cgColor
    }
    
    func setUpMatchFoundBtn(){
        if (BidsData?.postedTruck?.matchesCount ?? 0) != 0{
            self.btnMatchFound.setTitleColor(#colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), for: .normal)
            self.btnMatchFound.layer.borderColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1).cgColor
            self.btnMatchFound.backgroundColor = .clear
            self.btnMatchFound.layer.borderWidth = 1
            let totalCount = (BidsData?.postedTruck?.matchesCount ?? 0)
            self.btnMatchFound.setTitle("\("load_found".localized)\(totalCount) \("Matches Load Found".localized)", for: .normal)
        }else{
            self.btnMatchFound.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1)
            self.btnMatchFound.setTitleColor(hexStringToUIColor(hex: "#FFFFFF"), for: .normal)
            self.btnMatchFound.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1).cgColor
            self.btnMatchFound.setTitle("No Matches Found".localized, for: .normal)
        }
    }
    
    func setUpData(){
        self.SetUpTable()
        self.lblCompnyName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
        self.lblId.text = "#\(BidsData?.postedTruck?.id ?? Int())"
        self.lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (BidsData?.postedTruck?.bidAmount ?? "") : ""
        self.lblType.text = "Posted Truck".localized
        self.lblStatus.text = MyLoadesStatus.pending.Name.localized.capitalized
        self.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
        self.viewType.clipsToBounds = true
        self.viewType.backgroundColor = .lightGray
        self.callAPI()
    }
    
    func SetUpTable(){
        self.tblBidRequest.dataSource = self
        self.tblBidRequest.delegate = self
        self.tblBidRequest.separatorStyle = .none
        self.tblBidRequest.isScrollEnabled = false
        self.tblBidRequest.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblBidRequest.register(UINib(nibName: EarningShimmerCell.className, bundle: nil), forCellReuseIdentifier: EarningShimmerCell.className)
        self.tblLocation.dataSource = self
        self.tblLocation.delegate = self
        self.tblLocation.separatorStyle = .none
        self.tblLocation.isScrollEnabled = false
        self.tblLocation.isUserInteractionEnabled = false
        self.tblLocation.register(UINib(nibName: SearchLocationCell.className, bundle: nil), forCellReuseIdentifier: SearchLocationCell.className)
        
    }
    
    //MARK: - IBAction methods
    @IBAction func btnMatchFoundClick(_ sender: Any) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckMatchesVC.storyboardID) as! PostedTruckMatchesVC
        controller.NumberOfCount = BidsData?.postedTruck?.matchesCount ?? 0
        controller.hidesBottomBarWhenPushed = true
        controller.PostTruckID = "\(BidsData?.postedTruck?.id ?? 0)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnSortByClick(_ sender: Any) {
        if !isLoading{
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupVC.storyboardID) as! SortPopupVC
            controller.hidesBottomBarWhenPushed = true
            controller.isFromBid = true
            controller.delegate = self
            if self.sortBy != ""{
                if let index = controller.arrSordData.firstIndex(of: self.sortBy){
                    controller.selectedIndex = index
                }
            }
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((2 * 50) + 120) + appDel.GetSafeAreaHeightFromBottom())])
            sheetController.allowPullingPastMaxHeight = false
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
}

//MARK: - SortBy delegate
extension PostedTruckBidRequestVC : HomeSorfDelgate{
    func onSorfClick(strSort: String) {
        self.sortBy = strSort
        isLoading = true
        arrBidsData?.removeAll()
        tblBidRequest.reloadData()
        callAPI()
    }
}

//MARK: - Table View dataSource and delegate
extension PostedTruckBidRequestVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblBidRequest{
            if isLoading {
                return 2
            }
            return arrBidsData?.count ?? 0
        }else if tableView == tblLocation{
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblBidRequest{
            let cell = self.tblBidRequest.dequeueReusableCell(withIdentifier: EarningShimmerCell.className) as! EarningShimmerCell
            cell.selectionStyle = .none
            if(self.isLoading){
                return cell
            }else{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "PostedTruckBidReqCell", for: indexPath) as! PostedTruckBidReqCell
                cell.setData(data: arrBidsData?[indexPath.row])
                let BookingDetails = arrBidsData?[indexPath.row].bookingInfo
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
                cell.tblHeight = { (heightTBl) in
                    self.tblBidRequest.layoutIfNeeded()
                    self.tblBidRequest.layoutSubviews()
                }
                return cell
            }
        }else if tableView == tblLocation{
            let cell =  tableView.dequeueReusableCell(withIdentifier: SearchLocationCell.className, for: indexPath) as! SearchLocationCell
            if indexPath.row == 0 {
                cell.lblDateTime.isHidden = false
                cell.lblDateTime.text = "\(BidsData?.postedTruck?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")"
                cell.lblCompanyName.text = BidsData?.postedTruck?.fromAddress ?? ""
                cell.imgLocation.image = UIImage(named: "ic_PickUp")
                cell.viewLine.isHidden = false
            } else {
                cell.lblDateTime.isHidden = false
                cell.lblDateTime.text = "\(BidsData?.postedTruck?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")"
                cell.lblCompanyName.text = (BidsData?.postedTruck?.toAddress != nil || BidsData?.postedTruck?.toAddress ?? "" != "") ? BidsData?.postedTruck?.toAddress ?? "" : "N/A"
                cell.imgLocation.image = UIImage(named: "ic_DropOff")
                cell.viewLine.isHidden = true
            }
            cell.lblAddress.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblBidRequest {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckBidReqDetailVC.storyboardID) as! PostedTruckBidReqDetailVC
            controller.hidesBottomBarWhenPushed = true
            controller.LoadDetails = self.arrBidsData?[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblBidRequest{
            cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        }
    }
}

//MARK: - Webservice method
extension PostedTruckBidRequestVC{
    
    func callAPIForAcceptReject(Accepted:Bool,bookingID:String,loadDetails:MyLoadsNewPostedTruck?,isForBook:Bool,RemainingsMinute:Int = 0) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: PostedTruckBidReqActionVC.storyboardID) as! PostedTruckBidReqActionVC
        controller.bidRequestViewController = self
        controller.LoadDetails = loadDetails
        controller.isAccept = Accepted
        controller.isForBook = isForBook
        let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(22)] as [NSAttributedString.Key : Any]
        if isForBook {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: PostedTruckCancelReqVC.storyboardID) as! PostedTruckCancelReqVC
            controller.hidesBottomBarWhenPushed = true
            controller.remainingsMinute = RemainingsMinute
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((6 * 50) + 110) + appDel.GetSafeAreaHeightFromBottom())])
            sheetController.allowPullingPastMaxHeight = false
            self.present(sheetController, animated: true, completion: nil)
        } else {
            let AttributedStringFinal = "\("Are_you_sure_you_want_to".localized) ".Medium(color: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), FontSize: 16)
            if Accepted {
                AttributedStringFinal.append("\("bidaccept".localized)".Medium(color: #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1), FontSize: 16))
                controller.TitleAttributedText = NSAttributedString(string: "\("Accept".localized.capitalized) \("Bid_Request_post".localized)", attributes: TitleAttribute)
            } else {
                AttributedStringFinal.append("\("bidDecline".localized)".Medium(color: #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), FontSize: 16))
                controller.TitleAttributedText = NSAttributedString(string: "\("Decline".localized.capitalized) \("Bid_Request_post".localized)", attributes: TitleAttribute)
            }
            AttributedStringFinal.append(" \("the bid request?".localized)".Medium(color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), FontSize: 16))
//            controller.TitleAttributedText = AttributedStringFinal
//            controller.TitleAttributedText = NSAttributedString(string: "\("Bid_Request_post".localized)", attributes: TitleAttribute)
            controller.DescriptionAttributedText = AttributedStringFinal
        }
        controller.IsHideImage = true
        controller.LeftbtnTitle = "Cancel".localized
        controller.RightBtnTitle = "Yes".localized
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
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func callAPI() {
        self.postTruckBidsViewModel.bidRequestViewController =  self
        let reqModel = PostTruckBidReqModel()
        reqModel.availability_id = PostTruckID
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        if(self.sortBy == "Price (Lowest First)"){
            reqModel.sort = "price_low"
        }else if(self.sortBy == "Price (Highest First)"){
            reqModel.sort = "price_high"
        }else{
            reqModel.sort = ""
        }
        self.postTruckBidsViewModel.BidRequest(ReqModel: reqModel)
    }
}
