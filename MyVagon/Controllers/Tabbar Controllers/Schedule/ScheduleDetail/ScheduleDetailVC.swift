//
//  SchedualLoadDetailsViewController.swift
//  MyVagon
//
//  Created by Apple on 13/12/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import SDWebImage
import UIView_Shimmer
import MapKit
import FittedSheets
import Cosmos

class ScheduleDetailVC: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var MapViewForLocation: GMSMapView!
    @IBOutlet weak var scrollViewHide: UIScrollView!
    @IBOutlet weak var lblDaysToGo: themeLabel!
    @IBOutlet weak var lblBookingID: themeLabel!
    @IBOutlet weak var lblDeadHead: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblTotalMiles: themeLabel!
    @IBOutlet weak var lbljourney: themeLabel!
    @IBOutlet weak var lblBookingStatus: themeLabel!
    @IBOutlet weak var lblTruckType: themeLabel!
    @IBOutlet weak var lblJourneyType: themeLabel!
    @IBOutlet weak var lblShipperName: themeLabel!
    @IBOutlet weak var lblShipperRatting: themeLabel!
    @IBOutlet weak var lblLoadStatus: themeLabel!
    @IBOutlet weak var lblLoadStatusDesc: themeLabel!
    @IBOutlet weak var btnViewPOD: themeButton!
    @IBOutlet weak var btnCancelBidRequest: themeButton!
    @IBOutlet weak var btnMarkAsPaid: themeButton!
    @IBOutlet weak var btnStartTrip: themeButton!
    @IBOutlet weak var btnViewNotes: themeButton!
    @IBOutlet weak var vWLoadStatus: UIView!
    @IBOutlet weak var viewShipperDetail: UIView!
    @IBOutlet weak var vwShimmer: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var tblMainData: UITableView!
    @IBOutlet weak var tblMainDataHeight: NSLayoutConstraint!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var imgShipperProfile: UIImageView!
    @IBOutlet weak var viewRatting: CosmosView!
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var btnEnlarge: UIButton!
    @IBOutlet weak var lblTotalKM: themeLabel!
    @IBOutlet weak var lblJourney: themeLabel!
    @IBOutlet weak var lblShipperDetails: UILabel!
    
    let schedualDetailViewModel = SchedualDetailViewModel()
    var LoadDetails : MyLoadsNewBid?
    var arrTypes:[(MyLoadsNewTruckTypeCategory,Bool)] = []
    var customTabBarController: CustomTabBarVC?
    var strLoadStatus:String = ""
    var strHour : String = ""
    var isLoading = false {
        didSet {
            tblMainData.isUserInteractionEnabled = !isLoading
            tblMainData.reloadData()
        }
    }
    var startLocIndex : Int = 0
    var CurrentLocMarker: GMSMarker?
    var DropLocMarker: GMSMarker?
    var arrMarkers: [GMSMarker] = []
    var path = GMSPath()
    var polyline : GMSPolyline!
    var chat = false
    
    // MARK: - Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            if collObj == self.tblMainData{
                self.tblMainDataHeight.constant = tblMainData.contentSize.height
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    // MARK: - Custom methods
    func setupUI(){
        self.btnCancelBidRequest.setTitle("Cancel Bid Request".localized, for: .normal)
        if (self.LoadDetails?.status == MyLoadesStatus.inprocess.Name){
            chat = true
        }else if (self.LoadDetails?.status == MyLoadesStatus.completed.Name){
            if self.LoadDetails?.paymentStatus == "pending"{
                chat = true
            }
        }
        self.setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "Load Details".localized, leftImage: NavItemsLeft.back.value, rightImages: chat ? [NavItemsRight.chatDirect.value] : [], isTranslucent: true)
        self.reloadAfterStartTrip()
        self.SetValue()
        self.setupMap()
        self.lblLoadStatusDesc.isHidden = true
        self.vWLoadStatus.layer.cornerRadius = vWLoadStatus.frame.height / 2
        self.vWLoadStatus.clipsToBounds = true
        self.lblLoadStatus.text = self.strLoadStatus.capitalized.localized
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.tblMainData.delegate = self
        self.tblMainData.dataSource = self
        self.tblMainData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMainData.register(UINib(nibName: LoadDetailCell.className, bundle: nil), forCellReuseIdentifier: LoadDetailCell.className)
        self.LoadDetails?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,true))
        })
        ColTypes.reloadData()
        AppDelegate.shared.shipperIdForChat = "\(self.LoadDetails?.shipperDetails?.id ?? 0)"
        AppDelegate.shared.shipperNameForChat = self.LoadDetails?.shipperDetails?.name ?? ""
        AppDelegate.shared.shipperProfileForChat = self.LoadDetails?.shipperDetails?.profile ?? ""
        self.addObserver()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.lblJourney.text = "\("Journey".localized) : "
        self.lblTotalKM.text = "\("Total Km".localized) :"
        self.lblShipperDetails.text = "\("Shipper Details".localized) : "
        self.btnViewNotes.setTitle("Notes".localized, for: .normal)
        self.btnMarkAsPaid.setTitle("Mark_as_Paid".localized, for: .normal)
        self.btnViewPOD.setTitle("View_POD".localized, for: .normal)
    }
    
    func reloadAfterStartTrip(){
        self.btnEnlarge.isHidden = LoadDetails?.status == MyLoadesStatus.inprocess.Name ? false : true
    }
    
    func goToTrackingScreen() {
        if(LoadDetails?.status == MyLoadesStatus.inprocess.Name){
            let controller = AppStoryboard.LiveTracking.instance.instantiateViewController(withIdentifier: TrackingVC.storyboardID) as! TrackingVC
            controller.hidesBottomBarWhenPushed = true
            controller.TripDetails = self.LoadDetails
//            controller.ismultipal = LoadDetails?.bookingType
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func SetValue() {
        let data = LoadDetails
        let DateOfPickup = "\(data?.date ?? "") \(data?.pickupTimeTo ?? "")"
        self.lblDaysToGo.superview?.isHidden = true
        self.btnStartTrip.setTitle(TripStatus.ClicktoStartTrip.Name.localized, for: .normal)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(reviewGesture(_:)))
        self.viewShipperDetail.addGestureRecognizer(gesture)
        if(data?.status == MyLoadesStatus.scheduled.Name){
            let dateToCompare = Utilities.getDateFromString(strDate: DateOfPickup)
            let CurrentDate = Utilities.getDateFromString2(strDate: SingletonClass.sharedInstance.SystemDate)
            strHour = Utilities.getDateDiff(start: CurrentDate, end: dateToCompare)
            if(strHour.contains("-")){
                self.lblDaysToGo.text = ""
            }else{
                let formatter = RelativeDateTimeFormatter()
                formatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
                formatter.unitsStyle = .full
                let relativeDate = formatter.localizedString(for: dateToCompare, relativeTo: CurrentDate)
                let dateToDisplay = relativeDate.components(separatedBy: "in ")
                if(dateToDisplay.count > 1){
                    let date = "\(dateToDisplay[1])".replaceCharacter(oldCharacter: "", newCharacter: "")
                    self.lblDaysToGo.text = "\("hoursLeft".localized) \(date) \("to go".localized)"
                }else{
                    let date = "\(dateToDisplay[0])".replaceCharacter(oldCharacter: "σε ", newCharacter: "")
                    self.lblDaysToGo.text = "\("hoursLeft".localized) \(date) \("to go".localized)"
                }
            }
        }
        self.viewStatus.backgroundColor = (data?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        self.btnViewNotes.isHidden = ((data?.trucks?.note ?? "") == "") ? true : false
        let radius = viewStatus.frame.height / 2
        self.viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        self.lblBookingID.text = "#\(data?.id ?? 0)"
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1{
            let amount = (data?.bookingBidAmount != "" && data?.bookingBidAmount != nil) ? data?.bookingBidAmount : data?.amount
            self.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + "\(amount ?? "")" : ""
            self.lblPrice.isHidden = false
        }else{
            self.lblPrice.isHidden = true
        }
        self.lblBookingStatus.text = data?.status
        self.lblTruckType.text = data?.trucks?.truckType?.name ?? ""
        self.lbljourney.text = "\(data?.journey ?? "")"
        self.lblJourneyType.text = "\(data?.journeyType ?? "")"
        self.lblTotalMiles.text = "\(data?.distance ?? "")"
        self.lblDeadHead.text = "\(Double(data?.trucks?.locations?.first?.deadhead ?? "") ?? 0.0) Km Deadhead"
        self.lblDeadHead.isHidden = true
        self.lblShipperName.text = data?.shipperDetails?.companyName ?? ""
        self.viewRatting.settings.fillMode = .precise
        self.viewRatting.rating = Double(data?.shipperDetails?.shipperRating ?? "0.0") ?? 0.0
        self.lblShipperRatting.attributedText = "(\(data?.shipperDetails?.noOfShipperRated ?? 0))".underLine()
        let strUrl = "\(APIEnvironment.ShipperImageURL)\(data?.shipperDetails?.profile ?? "")"
        self.imgShipperProfile.isCircle()
        self.imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
        self.btnViewPOD.superview?.isHidden = true
        self.btnCancelBidRequest.superview?.isHidden = true
        self.btnMarkAsPaid.superview?.isHidden = true
        setStatus(data?.status ?? "")
    }
    
    func setStatus(_ status: String){
        switch status {
        case MyLoadesStatus.pending.Name:
            self.btnStartTrip.superview?.isHidden = true
            self.btnCancelBidRequest.superview?.isHidden = false
            if UserDefault.string(forKey: UserDefaultsKey.LoginUserType.rawValue) == LoginType.dispatcher_driver.rawValue{
                self.btnCancelBidRequest.setTitle(ReqCancelTitle.decline.Name.localized, for: .normal)
            }else{
                self.btnCancelBidRequest.setTitle(ReqCancelTitle.cencelBid.Name.localized, for: .normal)
            }
            self.lblLoadStatusDesc.isHidden = false
            self.lblLoadStatusDesc.text = BidStatusLabel.bidConfirmationPending.Name.localized
            self.lblBookingStatus.text =  MyLoadesStatus.pending.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.4078431373, blue: 0.4039215686, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            var hidden = (Int(strHour) ?? 0 <= 8) ? true : false
            if LoadDetails?.cancelRequest == "1"{
                hidden = false
                self.setReqButton(btn: btnCancelBidRequest)
            }else{
                if UserDefault.string(forKey: UserDefaultsKey.LoginUserType.rawValue) == LoginType.dispatcher_driver.rawValue{
                    self.btnCancelBidRequest.setTitle(ReqCancelTitle.decline.Name.localized, for: .normal)
                }else{
                    self.btnCancelBidRequest.setTitle(ReqCancelTitle.deleteBid.Name.localized, for: .normal)
                }
            }
            self.btnCancelBidRequest.superview?.isHidden = hidden
            self.lblDaysToGo.superview?.backgroundColor = UIColor(hexString: "#F9F1DF")
            self.lblDaysToGo.fontColor = UIColor(hexString: "#000000")
            self.lblDaysToGo.layoutSubviews()
            self.btnStartTrip.superview?.isHidden = (Int(strHour) ?? 0 <= 8) ? false : true
            self.lblDaysToGo.superview?.isHidden = (Int(strHour) ?? 0 <= 0) ? true : false
            self.stepIndicatorView.isHidden = !self.lblDaysToGo.isHidden
            self.lblBookingStatus.text =  MyLoadesStatus.scheduled.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        case MyLoadesStatus.inprocess.Name:
            self.btnStartTrip.superview?.isHidden = true
            self.lblBookingStatus.text =  MyLoadesStatus.inprocess.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
        case MyLoadesStatus.completed.Name:
            self.btnViewPOD.superview?.isHidden = ((LoadDetails?.podURL ?? "") != "") ? false : true
            if(LoadDetails?.podURL ?? "") == ""{
                self.btnStartTrip.setTitle(TripStatus.UploadPOD.Name.localized, for: .normal)
                self.btnStartTrip.superview?.isHidden = false
            }else{
                if LoadDetails?.shipperRate == 0 {
                    self.btnStartTrip.setTitle(TripStatus.RateShipper.Name.localized, for: .normal)
                    self.btnStartTrip.superview?.isHidden = false
                } else {
                    self.btnStartTrip.setTitle(TripStatus.RateShipper.Name.localized, for: .normal)
                    self.btnStartTrip.superview?.isHidden = true
                }
            }
            self.lblBookingStatus.text =  MyLoadesStatus.completed.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            var Visible = true
            if(self.LoadDetails?.paymentStatus == "pending"){
                Visible = true
                if(self.LoadDetails?.podURL != ""){
                    Visible = false
                }else{
                    Visible = true
                }
            }
            self.btnMarkAsPaid.superview?.isHidden = Visible
            self.viewStatus.backgroundColor = (self.LoadDetails?.paymentStatus == "pending") ? #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.lblBookingStatus.text = (self.LoadDetails?.paymentStatus == "pending") ? MyLoadesStatus.completed.Name.localized.capitalized : "Paid".localized
        case MyLoadesStatus.canceled.Name:
            self.lblBookingStatus.text =  MyLoadesStatus.canceled.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
            btnStartTrip.superview?.isHidden = true
        default:
            break
        }
    }
    
    func setReqButton(btn: UIButton){
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("You already requested to cancel".localized, for: .normal)
    }
    
    func popBack(){
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
    }
    
    private func openMarkAsPaidAlert(){
         Utilities.showAlertWithTitleFromVC(vc: self, title: "Mark_as_Paid_title", message: "Mark_as_PaidAlert".localized, buttons: ["NO".localized,"YES".localized], isOkRed: false) { (ind) in
             if ind == 1{
                 self.CallAPIForAcceptPayment()
             }
         }
     }
    
    // MARK: - IBAction methods
    @IBAction func btnNotesClick(_ sender: themeButton) {
        let data = LoadDetails
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
        controller.noteString = (data?.trucks?.note ?? "")
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280 + appDel.GetSafeAreaHeightFromBottom()))])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion:  {
        })
    }
    
    @IBAction func btnViewPODClick(_ sender: themeButton) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ViewPodVC.storyboardID) as! ViewPodVC
        controller.hidesBottomBarWhenPushed = true
        controller.imageURl = LoadDetails?.podURL ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnStartTripClick(_ sender: themeButton) {
        if sender.titleLabel?.text == TripStatus.UploadPOD.Name.localized {
            AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
            AttachmentHandler.shared.imagePickedBlock = { (image) in
                self.ImageUploadAPI(arrImages: [image])
            }
        } else if sender.titleLabel?.text == TripStatus.RateShipper.Name.localized {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ReviewShipperVC.storyboardID) as! ReviewShipperVC
            controller.bookingID = "\(LoadDetails?.id ?? 0)"
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            if appDel.locationManager.isAlwaysPermissionGranted() {
                if sender.titleLabel?.text == TripStatus.ClicktoStartTrip.Name.localized {
                    CallAPIForStartTrip()
                }
            } else {
                Utilities.AlwaysAllowPermission(currentVC: self)
            }
        }
    }
    
    @IBAction func btnCancelBidRequestAction(_ sender: Any) {
        if(self.LoadDetails?.status == MyLoadesStatus.pending.Name){
            Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: "Are you sure you want to cancel this bid request?".localized, buttons: ["No".localized, "Yes".localized]) { index in
                if(index == 1){
                    self.CallAPIForCancelBid()
                }
            }
        }else{
            if LoadDetails?.cancelRequest == "0"{
                Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: "Are you sure you want to cancel?".localized, buttons: ["No".localized, "Yes".localized]) { index in
                    if(index == 1){
                        self.CallAPIForDeleteBid()
                    }
                }
            }
        }
    }
    
    @IBAction func btnMarkAsPaidAction(_ sender: Any) {
        openMarkAsPaidAlert()
    }
    
    @objc func reviewGesture(_ sender: UITapGestureRecognizer){
        let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: shipperDetailsVC.storyboardID) as! shipperDetailsVC
        controller.shipperId = "\(LoadDetails?.shipperDetails?.id ?? 0)"
        controller.showChat = chat
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnEnlargeAction(_ sender: Any) {
        self.goToTrackingScreen()
    }
}

// MARK: - Tableview methods
extension ScheduleDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadDetails?.trucks?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainData.dequeueReusableCell(withIdentifier: "LoadDetailCell") as! LoadDetailCell
        setUpCell(data: self.LoadDetails?.trucks?.locations?[indexPath.row], bookingType: LoadDetails?.bookingType ?? "",cell: cell)
        let data = LoadDetails
        var pickupArray = data?.trucks?.locations?.compactMap({$0.isPickup})
        pickupArray = pickupArray?.uniqued()
        if(indexPath.row == 0){
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_PickUp")
        }else if(indexPath.row == (data?.trucks?.locations?.count ?? 0) - 1){
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_DropOff")
        }else{
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_pickDrop")
            cell.vWHorizontalDotLine.isHidden = false
        }
        cell.btnNoteClick = {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
            controller.noteString = self.LoadDetails?.trucks?.locations?[indexPath.row].note ?? ""
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .coverVertical
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280) + appDel.GetSafeAreaHeightFromBottom())])
            sheetController.allowPullingPastMaxHeight = false
            UIApplication.topViewController()?.present(sheetController, animated: true, completion:  {
            })
        }
        if indexPath.row == 0 {
            cell.ViewDottedTop.isHidden = true
        } else if indexPath.row == ((data?.trucks?.locations?.count ?? 0) - 1) {
            cell.ViewDottedbottom.isHidden = true
        } else {
            cell.ViewDottedTop.isHidden = false
            cell.ViewDottedbottom.isHidden = false
        }
        cell.sizeForTableview = { (heightTBl) in
            self.tblMainData.layoutIfNeeded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SearchLocationVC.storyboardID) as! SearchLocationVC
        controller.locationId = "\(self.LoadDetails?.trucks?.locations?[indexPath.row].id ?? 0)"
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setUpCell(data: MyLoadsNewLocation?,bookingType:String,cell:LoadDetailCell){
        cell.ViewForSavingTree.isHidden = true
        cell.btnNotes.isHidden = (data?.note ?? "" == "")
        cell.lblName.text = data?.companyName ?? ""
        cell.lblAddress.text = data?.dropLocation ?? ""
        cell.lblDate.text = data?.companyName ?? ""
        if (data?.deliveryTimeFrom ?? "") == (data?.deliveryTimeTo ?? "") {
            cell.lblDate.text =  "\(data?.deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.deliveryTimeFrom ?? ""))"
        } else {
            cell.lblDate.text =  "\(data?.deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.deliveryTimeFrom ?? ""))-\(data?.deliveryTimeTo ?? "")"
        }
        var picUp = 0
        if bookingType == "multiple_shipment"{
            if data?.products?.count ?? 0 > 1{
                cell.showStatus = true
            }else{
                picUp = data?.products?.first?.isPickup ?? 0
            }
        }else{
            picUp = data?.isPickup ?? 0
        }
        if cell.showStatus{
            cell.lblPickupDropOff.text = ""
            cell.lblPickupDropOff.superview?.backgroundColor = .clear
        }else{
            cell.lblPickupDropOff.text = picUp == 0 ? "DROP".localized : "PICKUP".localized
            cell.lblPickupDropOff.superview?.backgroundColor = (picUp == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        }
        cell.LoadDetails = data?.products
        cell.TblLoadDetails.reloadData()
        cell.selectionStyle = .none
    }
}

// MARK: - Collectionview methods
extension ScheduleDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ColTypes{
            return arrTypes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ColTypes{
            return CGSize(width: ((arrTypes[indexPath.row].0.name?.capitalized ?? "").sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30, height: ColTypes.frame.size.height - 10)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ColTypes{
            let cell = ColTypes.dequeueReusableCell(withReuseIdentifier: "TypesColCell", for: indexPath) as! TypesColCell
            cell.lblTypes.text = arrTypes[indexPath.row].0.name
            cell.BGView.layer.cornerRadius = 17
            cell.BGView.layer.borderWidth = 0
            cell.BGView.backgroundColor = UIColor(hexString: "#1F1F41").withAlphaComponent(0.05)
            cell.BGView.layer.borderColor = UIColor.clear.cgColor
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ScheduleDetailVC {
    func setupMap(){
        self.MapViewForLocation.clear()
        self.MapViewForLocation.isUserInteractionEnabled = false
        self.mapSetupForLocations()
    }
    
    func mapSetupForLocations(){
        var sourcelat = "0.0"
        var sourcelng = "0.0"
        var destinationlat = "0.0"
        var destinationLong = "0.0"
        sourcelat = LoadDetails?.trucks?.locations?[startLocIndex].dropLat ?? "0.0"
        sourcelng = LoadDetails?.trucks?.locations?[startLocIndex].dropLng ?? "0.0"
        destinationlat = LoadDetails?.trucks?.locations?[startLocIndex + 1].dropLat ?? "0.0"
        destinationLong = LoadDetails?.trucks?.locations?[startLocIndex + 1].dropLng ?? "0.0"
        self.MapSetup(currentlat: sourcelat, currentlong: sourcelng, droplat: destinationlat, droplog: destinationLong)
    }
    
    func MapSetup(currentlat: String, currentlong:String, droplat: String, droplog:String){
        DispatchQueue.main.async {
            //Drop Location pin setup
            self.DropLocMarker = GMSMarker()
            self.DropLocMarker?.position = CLLocationCoordinate2D(latitude: Double(droplat) ?? 0.0, longitude: Double(droplog) ?? 0.0)
            self.DropLocMarker?.snippet = self.LoadDetails?.trucks?.locations?[self.startLocIndex + 1].dropLocation ?? ""
            let markerView = MarkerPinView()
            markerView.markerImage = (self.startLocIndex == (self.LoadDetails?.trucks?.locations?.count ?? 0) - 2) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_pickDrop")
            markerView.layoutSubviews()
            self.DropLocMarker?.iconView = markerView
            DispatchQueue.main.async {
                self.DropLocMarker?.map = self.MapViewForLocation
            }
            //Current Location pin setup
            self.CurrentLocMarker = GMSMarker()
            self.CurrentLocMarker?.position = CLLocationCoordinate2D(latitude: Double(currentlat) ?? 0.0, longitude: Double(currentlong) ?? 0.0)
            self.CurrentLocMarker?.snippet = self.LoadDetails?.trucks?.locations?[self.startLocIndex].dropLocation ?? ""
            let markerView2 = MarkerPinView()
            markerView2.markerImage = (self.startLocIndex == 0) ? UIImage(named: "ic_PickUp") : UIImage()
            markerView2.layoutSubviews()
            self.CurrentLocMarker?.iconView = markerView2
            DispatchQueue.main.async {
                self.CurrentLocMarker?.map = self.MapViewForLocation
            }
            //For Displaying both markers in screen centered
            if(self.startLocIndex == 0){
                self.arrMarkers.append(self.CurrentLocMarker!)
            }
            self.arrMarkers.append(self.DropLocMarker!)
            self.fetchRoute(currentlat: currentlat, currentlong: currentlong, droplat: droplat, droplog: droplog)
        }
    }
    
    func fetchRoute(currentlat: String, currentlong:String, droplat: String, droplog:String) {
        let CurrentLatLong = "\(currentlat),\(currentlong)"
        let DestinationLatLong = "\(droplat),\(droplog)"
        let param = "origin=\(CurrentLatLong)&destination=\(DestinationLatLong)&mode=driving&key=\(AppInfo.Google_API_Key)"
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?\(param)")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    Utilities.ShowAlertOfInfo(OfMessage: error!.localizedDescription)
                }
                return
            }
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]?, let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }
            guard let status = jsonResponse["status"] as? String else {
                return
            }
            if(status == "REQUEST_DENIED" || status == "ZERO_RESULTS" || status == "OVER_QUERY_LIMIT"){
                print("Map Error : \(jsonResponse["error_message"] as? String ?? "REQUEST_DENIED")")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    Utilities.ShowAlertOfInfo(OfMessage: "Map Error : \(jsonResponse["error_message"] as? String ?? "REQUEST_DENIED")")
                }
                return
            }
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            guard let route = routes[0] as? [String: Any] else {
                return
            }
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            self.drawPath(from: polyLineString)
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        DispatchQueue.main.async {
            self.path = GMSPath(fromEncodedPath: polyStr)!
            self.polyline = GMSPolyline(path: self.path)
            self.polyline.strokeWidth = 3.0
            self.polyline.strokeColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
            self.polyline.map = self.MapViewForLocation
        }
        if(LoadDetails?.trucks?.locations?.count ?? 0 > 2 && LoadDetails?.trucks?.locations?.count != (startLocIndex + 2)){
            self.startLocIndex += 1
            self.mapSetupForLocations()
        }else{
            var bounds = GMSCoordinateBounds()
            for marker in self.arrMarkers
            {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 80)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.MapViewForLocation.animate(with: update)
            }
        }
    }
}

//MARK: - WebService method
extension ScheduleDetailVC{
    func CallAPIForStartTrip() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        let reqModel = StartTripReqModel()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        reqModel.shipper_id = "\(self.LoadDetails?.shipperDetails?.id ?? 0)"
        reqModel.location_id = "\(self.LoadDetails?.trucks?.locations?[0].id ?? 0)"
        self.schedualDetailViewModel.WebServiceStartTrip(ReqModel: reqModel)
    }
    
    func CallAPIForCancelBid() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        let reqModel = CancelBidReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        reqModel.shipper_id = "\(self.LoadDetails?.shipperDetails?.id ?? 0)"
        self.schedualDetailViewModel.CancelBidRequest(ReqModel: reqModel)
    }
    
    func CallAPIForAcceptPayment() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        let reqModel = AcceptPaymentReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        self.schedualDetailViewModel.WebServiceAcceptPayment(ReqModel: reqModel)
    }
    
    func CallAPIForDeleteBid() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        let reqModel = CancelBidReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        reqModel.shipper_id = "\(self.LoadDetails?.shipperDetails?.id ?? 0)"
        self.schedualDetailViewModel.DeleteBidRequest(ReqModel: reqModel)
    }
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        self.schedualDetailViewModel.WebServiceImageUpload(images: arrImages)
    }
}
