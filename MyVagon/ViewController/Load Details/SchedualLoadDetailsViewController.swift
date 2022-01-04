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

class SchedualLoadDetailsViewController: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var moveMent: ARCarMovement?
    var oldCoordinate: CLLocationCoordinate2D?
    var path = GMSPath()
    var polyline : GMSPolyline!

    var Point2Marker: GMSMarker?
    var TruckMarker: GMSMarker?
    
    var oldPoint:CLLocation!
    var newPoint:CLLocation!
    var coordinates : [CLLocation] = []
    
    let schedualDetailViewModel = SchedualDetailViewModel()
    var loadDetailViewModel = LoadDetailViewModel()
    var LoadDetails : MyLoadsNewBid?
    var arrTypes:[(MyLoadsNewTruckTypeCategory,Bool)] = []
    var isLoading = false {
        didSet {
            
            tblMainData.isUserInteractionEnabled = !isLoading
            tblMainData.reloadData()
        }
    }
    var customTabBarController: CustomTabBarVC?
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var lblDaysToGo: themeLabel!
    @IBOutlet weak var MapViewForLocation: GMSMapView!
    @IBOutlet weak var vwShimmer: UIView!
    @IBOutlet weak var scrollViewHide: UIScrollView!
    @IBOutlet weak var btnViewNotes: themeButton!
    @IBOutlet weak var lblBookingID: themeLabel!
    @IBOutlet weak var lblDeadHead: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblTotalMiles: themeLabel!
    @IBOutlet weak var lbljourney: themeLabel!
    @IBOutlet weak var lblBookingStatus: themeLabel!
    @IBOutlet weak var lblTruckType: themeLabel!
    @IBOutlet weak var lblJourneyType: themeLabel!
    @IBOutlet weak var tblMainData: UITableView!
    @IBOutlet weak var tblMainDataHeight: NSLayoutConstraint!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblShipperName: themeLabel!
    @IBOutlet weak var lblShipperRatting: themeLabel!
    @IBOutlet weak var imgShipperProfile: UIImageView!
    @IBOutlet weak var viewRatting: CosmosView!
    
    @IBOutlet weak var btnViewPOD: themeButton!
    
    
    @IBOutlet weak var btnStartTrip: themeButton!
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moveMent = ARCarMovement()
        self.moveMent?.delegate = self
        
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        
        SetValue()
        //   getLoadsData()
        tblMainData.delegate = self
        tblMainData.dataSource = self
        tblMainData.reloadData()
        setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "Load Details", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        tblMainData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        tblMainData.register(UINib(nibName: "LoadDetailCell", bundle: nil), forCellReuseIdentifier: "LoadDetailCell")
        
        LoadDetails?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,true))
        })
        
        ColTypes.reloadData()
        
        
        
        
        
    }
    func setUserImageInMarker()->UIImage{
        if let url = URL(string: SingletonClass.sharedInstance.UserProfileData?.profile ?? ""), let data = try? Data(contentsOf: url), let imageFromUrl = UIImage(data: data){
            let image = imageFromUrl.sd_resizedImage(with: CGSize(width: 80, height: 80), scaleMode: .aspectFill)?.withRenderingMode(.alwaysOriginal).radiusImageWithBorder(width: 2, color: .white)
            return image ?? UIImage()
            
        }
        return UIImage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func SetValue() {
        setupMap()
        let data = LoadDetails
        let arrLocation = data?.trucks?.locations
        for i in 0...((arrLocation?.count ?? 0) - 1) {
            if ((arrLocation?[i].arrivedAt ?? "") == "") || ((arrLocation?[i].StartLoading ?? "") == "") || ((arrLocation?[i].startJourney ?? "") == "") {
                
                SingletonClass.sharedInstance.CurrentTripSecondLocation = arrLocation?[i]
                if i != 0 {
                    self.stepIndicatorView.currentStep = i
                } else {
                    self.ChangeStepIndicatorView(TotalSteps: data?.trucks?.locations?.count ?? 2, CurrentStep: i)
                }
                break
            }
        }
       
        
        SingletonClass.sharedInstance.CurrentTripShipperID = "\(data?.shipperDetails?.id ?? 0)"
        let DateOfPickup = "\(data?.date ?? "") \(data?.pickupTimeTo ?? "")"
        
        let DateFromatChange = DateOfPickup.StringToDate(Format: "yyyy-MM-dd h:m a")
        
        let serverDate =  SingletonClass.sharedInstance.SystemDate.StringToDate(Format: "yyyy-MM-dd hh:mm:ss")
        print(serverDate)
        print(DateFromatChange)
        
        var daysLeft:(String,Int,OffSetType) = ("0 hour",0,.Hours)
        if DateFromatChange.seconds(from: serverDate) > 0 {
            daysLeft = DateFromatChange.CheckHours(from: serverDate)
//            daysLeft = DateFromatChange.offset(from: serverDate)
            
            
        }
        self.lblDaysToGo.text = daysLeft.0 + " to go"
        
        viewStatus.backgroundColor = (data?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        
        btnViewNotes.isHidden = ((data?.trucks?.note ?? "") == "") ? true : false
        let radius = viewStatus.frame.height / 2
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
        lblBookingID.text = "#\(data?.id ?? 0)"
        
        lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (data?.amount ?? "") : ""
        
        lblBookingStatus.text = data?.status
        
        lblTruckType.text = data?.trucks?.truckType?.name ?? ""
        
        lbljourney.text = "\(data?.journey ?? "")"
        lblJourneyType.text = "\(data?.journeyType ?? "")"
        
        lblTotalMiles.text = "\(data?.distance ?? "")"
        
        lblDeadHead.text = "\(data?.trucks?.locations?.first?.deadhead ?? "") Mile Deadhead"
        
        lblShipperName.text = data?.shipperDetails?.companyName ?? ""
        
        viewRatting.rating = data?.shipperDetails?.shipperRating ?? 0.0
        lblShipperRatting.attributedText = "(\(data?.shipperDetails?.shipperRating ?? 0.0))".underLine()
        let strUrl = "\(APIEnvironment.ShipperImageURL)\(data?.shipperDetails?.profile ?? "")"
        imgShipperProfile.isCircle()
        imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
       
        self.btnViewPOD.superview?.isHidden = true
        lblDaysToGo.superview?.isHidden = true
        
        self.btnStartTrip.superview?.isHidden = true
        MapViewForLocation.isUserInteractionEnabled = false
        switch data?.status {
        case MyLoadesStatus.pending.Name:
            lblBookingStatus.text =  MyLoadesStatus.pending.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            lblDaysToGo.superview?.backgroundColor = UIColor(hexString: "#F9F1DF")
            lblDaysToGo.fontColor = UIColor(hexString: "#000000")
            lblDaysToGo.layoutSubviews()
            self.btnStartTrip.superview?.isHidden = ( daysLeft.2 == .Hours && daysLeft.1 <= 8) ? false : true
            lblDaysToGo.superview?.isHidden = ( daysLeft.2 == .Hours && daysLeft.1 <= 8) ? true : false
            
            lblBookingStatus.text =  MyLoadesStatus.scheduled.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
            
            
        case MyLoadesStatus.inprocess.Name:
            MapViewForLocation.isUserInteractionEnabled = true
            lblDaysToGo.superview?.isHidden = false
            lblDaysToGo.superview?.backgroundColor = UIColor(hexString: "#1F1F41")
            lblDaysToGo.fontColor = UIColor(hexString: "#FFFFFF")
            lblDaysToGo.layoutSubviews()
            
            if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.arrivedAt ?? "") == "" {
                self.lblDaysToGo.text = "Enroute to \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                self.btnStartTrip.superview?.isHidden = false
                self.btnStartTrip.setTitle(TripStatus.ClicktoStartTrip.Name, for: .normal)
            } else if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.StartLoading ?? "") == "" {
                var pickupArray = SingletonClass.sharedInstance.CurrentTripSecondLocation?.products?.compactMap({$0.isPickup})
                pickupArray = pickupArray?.uniqued()
                if pickupArray?.count != 0   {
                    if pickupArray?.count == 1 {
                        if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                            self.btnStartTrip.setTitle(TripStatus.StartLoading.Name, for: .normal)
                        } else {
                            self.btnStartTrip.setTitle(TripStatus.StartOffLoad.Name, for: .normal)
                        }
                    }  else {
                        self.btnStartTrip.setTitle(TripStatus.StartLoadingOffLoading.Name, for: .normal)
                        
                    }
                }
              
                
                self.lblDaysToGo.text =  "Arrived at \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                self.btnStartTrip.superview?.isHidden = false
            } else if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.startJourney ?? "") == "" {
                var pickupArray = SingletonClass.sharedInstance.CurrentTripSecondLocation?.products?.compactMap({$0.isPickup})
                pickupArray = pickupArray?.uniqued()
                if pickupArray?.count != 0   {
                    if pickupArray?.count == 1 {
                        if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                            self.lblDaysToGo.text =  "Loading at \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                        } else {
                            self.lblDaysToGo.text =  "Off Loading at \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                        }
                    }  else {
                        self.lblDaysToGo.text =  "Loading at/Off Loading \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                    }
                }
               
                if self.LoadDetails?.trucks?.locations?.last?.id == SingletonClass.sharedInstance.CurrentTripSecondLocation?.id {
                    self.btnStartTrip.setTitle(TripStatus.CompleteTrip.Name, for: .normal)
                } else {
                    self.btnStartTrip.setTitle(TripStatus.StartJourney.Name, for: .normal)
                }
                
                self.btnStartTrip.superview?.isHidden = false
            } else {
               
            }
            
            lblBookingStatus.text =  MyLoadesStatus.inprocess.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
        case MyLoadesStatus.completed.Name:
            self.btnViewPOD.superview?.isHidden = ((data?.podURL ?? "") != "") ? false : true
            if (data?.podURL ?? "") == "" {
                self.btnStartTrip.setTitle(TripStatus.UploadPOD.Name, for: .normal)
                
                self.btnStartTrip.superview?.isHidden = false
                
            } else {
                if data?.shipperRate == "0" {
                    self.btnStartTrip.setTitle(TripStatus.RateShipper.Name, for: .normal)
                    self.btnStartTrip.superview?.isHidden = false
                } else {
                    self.btnStartTrip.setTitle(TripStatus.RateShipper.Name, for: .normal)
                    self.btnStartTrip.superview?.isHidden = true
                }
            }
            lblBookingStatus.text =  MyLoadesStatus.completed.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        case MyLoadesStatus.canceled.Name.capitalized:
            lblBookingStatus.text =  MyLoadesStatus.canceled.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
            
        case .none:
            break
        case .some(_):
            break
        }
        if SingletonClass.sharedInstance.CurrentTripStart {
            updateMap()
        } else {
            self.clearMap()
        }
        
        
//        updateMap()
        
        
        
    }
    func ChangeStepIndicatorView(TotalSteps:Int,CurrentStep:Int) {
        stepIndicatorView.numberOfSteps = TotalSteps
        stepIndicatorView.currentStep = CurrentStep
        stepIndicatorView.circleRadius = 10
        stepIndicatorView.circleStrokeWidth = 1
        stepIndicatorView.lineMargin = 0
        stepIndicatorView.lineStrokeWidth = 2
        stepIndicatorView.directionRaw = 0
        
        
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            if collObj == self.tblMainData{
                self.tblMainDataHeight.constant = tblMainData.contentSize.height
            }
        }
    }
    func showCurrentLocation() {
        //Current Location pin setup
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnNotesClick(_ sender: themeButton) {
        let data = LoadDetails
        
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
        
        controller.noteString = (data?.trucks?.note ?? "")
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280 + appDel.GetSafeAreaHeightFromBottom()))])
        self.present(sheetController, animated: true, completion:  {
        })
        
        
    }
    @IBAction func btnViewPODClick(_ sender: themeButton) {
        
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ViewPODViewController.storyboardID) as! ViewPODViewController
        controller.hidesBottomBarWhenPushed = true
        controller.imageURl = LoadDetails?.podURL ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    @IBAction func btnStartTripClick(_ sender: themeButton) {
        if sender.titleLabel?.text == TripStatus.UploadPOD.Name {
           AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
           AttachmentHandler.shared.imagePickedBlock = { (image) in
               self.ImageUploadAPI(arrImages: [image])
           }
       } else if sender.titleLabel?.text == TripStatus.RateShipper.Name {
           let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ReviewShipperVC.storyboardID) as! ReviewShipperVC
           controller.bookingID = "\(LoadDetails?.id ?? 0)"
           controller.hidesBottomBarWhenPushed = true
           self.navigationController?.pushViewController(controller, animated: true)
       } else {
        if appDel.locationManager.isAlwaysPermissionGranted() {
            if sender.titleLabel?.text == TripStatus.ClicktoStartTrip.Name {
                EmitForStartTrip(BookingID: "\(LoadDetails?.id ?? 0)", LocationID: "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)", ShipperID: "\(LoadDetails?.shipperDetails?.id ?? 0)")
                self.clearMap()
                
            } else if sender.titleLabel?.text == TripStatus.Arrivedatpickuplocation.Name || sender.titleLabel?.text == TripStatus.ArrivedatpickuplocationDropOff.Name {
                CallAPIForArriveAtLocation()
            } else if sender.titleLabel?.text == TripStatus.StartLoading.Name || sender.titleLabel?.text == TripStatus.StartLoadingOffLoading.Name {
                SingletonClass.sharedInstance.emitForCurrentLocation()
                CallAPIForStartLoading()
            } else if sender.titleLabel?.text == TripStatus.StartJourney.Name {
                CallAPIForStartJourney()
            } else if sender.titleLabel?.text == TripStatus.ArrivedatDroplocation.Name {
                CallAPIForArriveAtLocation()
            }  else if sender.titleLabel?.text == TripStatus.CompleteTrip.Name {
                
                CallAPIForCompleteTrip()
            } else if sender.titleLabel?.text == TripStatus.StartOffLoad.Name {
                CallAPIForStartLoading()
            }
            
        } else {
            Utilities.AlwaysAllowPermission(currentVC: self)
        }
       }
       
         
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Socket Emit ---------
    // ----------------------------------------------------
    
    func EmitForStartTrip(BookingID:String,LocationID:String,ShipperID:String) {
        self.socketOnForTripStart()
        let params = [  "booking_id" : BookingID,
                        "locaition_id" : LocationID,
                        "driver_id" : "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)",
                        "shipper_id" : ShipperID]
        
        
        SocketIOManager.shared.socketEmit(for: socketApiKeys.startTrip.rawValue , with: params)
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Socket On ---------
    // ----------------------------------------------------
    func socketOnForTripStart() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.startTrip.rawValue) { (json) in
            print(#function)
            print(json)
            self.LoadDetails?.status = "in-process"
            self.SetValue()
            self.btnStartTrip.superview?.isHidden = true
            
            SingletonClass.sharedInstance.CurrentTripStart = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
        }
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- WebService Call ---------
    // ----------------------------------------------------
    
    func CallAPIForArriveAtLocation() {
        
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        
        let reqModel = ArraivedAtLocationReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        reqModel.location_id = "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)"
        
        self.schedualDetailViewModel.ArrivedAtLocation(ReqModel: reqModel)
    }
    func CallAPIForStartJourney() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        
        let reqModel = StartJourneyReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        reqModel.location_id = "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)"
        
        self.schedualDetailViewModel.StartJourney(ReqModel: reqModel)
    }
    func CallAPIForStartLoading() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        
        let reqModel = StartLoadingReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        reqModel.location_id = "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)"
        
        self.schedualDetailViewModel.StartLoading(ReqModel: reqModel)
    }
    
    func CallAPIForCompleteTrip() {
        
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: CommonAcceptRejectPopupVC.storyboardID) as! CommonAcceptRejectPopupVC
        
        let DescriptionAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
        
        let AttributedStringFinal = "Shipment completed Successfully".Medium(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), FontSize: 18)
        
        controller.IsHideImage = false
        controller.ShownImage = #imageLiteral(resourceName: "ic_truck_completed")
        controller.TitleAttributedText = AttributedStringFinal
        controller.DescriptionAttributedText = NSAttributedString(string: "", attributes: DescriptionAttribute)
        controller.LeftbtnTitle = "Not Now"
        controller.RightBtnTitle = "Upload POD"
        
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        controller.LeftbtnClosour = {
            controller.dismiss(animated: true) {
                self.schedualDetailViewModel.schedualLoadDetailsViewController = self
                
                let reqModel = CompleteTripReqModel()
                reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
                reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
                reqModel.location_id = "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)"
                reqModel.pod_image = ""
                
                self.schedualDetailViewModel.CompleteTrip(ReqModel: reqModel)
            }
            
        }
        controller.RightbtnClosour = {
            controller.dismiss(animated: true) {
                AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
                AttachmentHandler.shared.imagePickedBlock = { (image) in
                    
                    
                    self.ImageUploadAPI(arrImages: [image])
                }
            }
        }
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(270) + appDel.GetSafeAreaHeightFromBottom())])
        self.present(sheetController, animated: true, completion: nil)
        
        
    }
    
    func getLoadsData() {
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        
        let reqModel = LoadDetailsReqModel()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.LoadDetails?.id ?? 0)"
        
        self.schedualDetailViewModel.GetLoadDetails(ReqModel: reqModel)
    }
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        
        self.schedualDetailViewModel.schedualLoadDetailsViewController = self
        
        self.schedualDetailViewModel.WebServiceImageUpload(images: arrImages)
    }
    
    
}
// ----------------------------------------------------
// MARK: - --------- Tableview Methods ---------
// ----------------------------------------------------
extension SchedualLoadDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if LoadDetails?.type ==  MyLoadType.Bid.Name {
        //
        //        } else {
        //            return LoadDetails?.book?.trucks?.locations?.count ?? 0
        //        }
        return LoadDetails?.trucks?.locations?.count ?? 0
        
        //        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainData.dequeueReusableCell(withIdentifier: "LoadDetailCell") as! LoadDetailCell
        cell.ViewForSavingTree.isHidden = true
        
        let data = LoadDetails
        
        
        var pickupArray = data?.trucks?.locations?.compactMap({$0.isPickup})
      
        pickupArray = pickupArray?.uniqued()
        if pickupArray?.count == 1 {
            cell.PickUpDropOffImageView.image = (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
        } else {
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_pickDrop")
        }
   
      
        cell.lblName.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        cell.lblAddress.text = data?.trucks?.locations?[indexPath.row].dropLocation ?? ""
        cell.lblDate.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        
        if (data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "") == (data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "") {
            cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
        } else {
            cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
        }
        
        cell.lblPickupDropOff.text = (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? "DROP" : "PICKUP"
        
        cell.lblPickupDropOff.superview?.backgroundColor = (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        
        cell.LoadDetails = data?.trucks?.locations?[indexPath.row].products
        
        
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
        cell.TblLoadDetails.reloadData()
        cell.selectionStyle = .none
        
        //        if LoadDetails?.type ==   MyLoadType.Bid.Name {
        //
        //        } else {
        //            let data = LoadDetails?.book
        //            cell.PickUpDropOffImageView.image =  (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
        //            cell.lblName.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        //            cell.lblAddress.text = data?.trucks?.locations?[indexPath.row].dropLocation ?? ""
        //            cell.lblDate.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        //
        //            if (data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "") == (data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "") {
        //                cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
        //            } else {
        //                cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
        //            }
        //
        //            cell.lblPickupDropOff.text = (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? "DROP" : "PICKUP"
        //
        //            cell.lblPickupDropOff.superview?.backgroundColor = (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        //
        //            cell.LoadDetails = data?.trucks?.locations?[indexPath.row].products
        //
        //
        //
        //
        //            if indexPath.row == 0 {
        //
        //                cell.ViewDottedTop.isHidden = true
        //            } else if indexPath.row == ((data?.trucks?.locations?.count ?? 0) - 1) {
        //
        //                cell.ViewDottedbottom.isHidden = true
        //            } else {
        //                cell.ViewDottedTop.isHidden = false
        //                cell.ViewDottedbottom.isHidden = false
        //            }
        //            cell.sizeForTableview = { (heightTBl) in
        //                self.tblMainData.layoutIfNeeded()
        //
        //            }
        //            cell.TblLoadDetails.reloadData()
        //            cell.selectionStyle = .none
        //        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //            self.isLoading = false
        //        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
// ----------------------------------------------------
// MARK: - --------- Collectionview Methods ---------
// ----------------------------------------------------
extension SchedualLoadDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ColTypes{
            return arrTypes.count
        }
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ColTypes{
            return CGSize(width: ((arrTypes[indexPath.row].0.name?.capitalized ?? "").sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                          , height: ColTypes.frame.size.height - 10)
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
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
        //            self.isLoading = false
        //        }
    }
}

extension SchedualLoadDetailsViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}
enum TripStatus {
    case ClicktoStartTrip
    case StartLoading
    case StartJourney
    case Arrivedatpickuplocation
    case ArrivedatDroplocation
    case CompleteTrip
    case StartOffLoad
    case UploadPOD
    case RateShipper
    case StartLoadingOffLoading
    case ArrivedatpickuplocationDropOff
    
    var Name:String {
        switch self {
        case .ClicktoStartTrip:
            return "Click to Start Trip"
        case .StartLoading:
            return "Start Loading"
        case .StartJourney:
            return "Start Journey"
        case .Arrivedatpickuplocation:
            return "Arrived at pickup location"
        case .ArrivedatDroplocation:
            return "Arrived at drop off location"
        case .CompleteTrip:
            return "Complete Shipment"
        case .StartOffLoad:
            return "Start Off Loading"
        case .UploadPOD:
            return "Upload POD"
        case .RateShipper:
            return "Rate Shipper"
        case .StartLoadingOffLoading:
            return "Start Loading/Offloading"
        case .ArrivedatpickuplocationDropOff:
            return "Arrived at pickup/dropoff location"
        }
    }
}

extension SchedualLoadDetailsViewController {
    func updateMap() {
        setupPickupRoute()

    }
}
extension SchedualLoadDetailsViewController {
    
    func setupMap(){
       print("ATdebug for live track \(#function)")
        self.MapViewForLocation.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
      
        
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.MapViewForLocation.padding = mapInsets
        
        let camera =  GMSCameraPosition.camera(withTarget: SingletonClass.sharedInstance.userCurrentLocation.coordinate, zoom: 10)
        self.MapViewForLocation.camera = camera

    }
    
    //MARK:- Setup Route methods
    func clearMap() {
        self.MapViewForLocation.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
        
        self.TruckMarker = GMSMarker()
        self.TruckMarker?.position = SingletonClass.sharedInstance.userCurrentLocation.coordinate

        self.TruckMarker?.snippet = "Your Location"
        
        let markerView2 = MarkerPinView()
        markerView2.markerImage = UIImage(named: "ic_truck_details")
        markerView2.layoutSubviews()
        
        self.TruckMarker?.iconView = markerView2
        self.TruckMarker?.map = self.MapViewForLocation
        
        
        let camera = GMSCameraPosition.camera(withLatitude: SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude, longitude: SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude, zoom: 17)
        self.MapViewForLocation.animate(to: camera)
        fetchRoute(currentlat: "", currentlong: "", droplat: "", droplog: "", isStatic: true)
        
    }
    func setupPickupRoute(){
       print("ATdebug for live track \(#function)")
        self.MapViewForLocation.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
        
        let currentLat = SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude
        let currentLon = SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude
        
        let PickLocLat = SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLat ?? ""
        let PickLocLong = SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLng ?? ""
        
        self.MapSetup(currentlat: "\(currentLat)", currentlong: "\(currentLon)", droplat: PickLocLat, droplog: PickLocLong)
    }
    
    func MapSetup(currentlat: String, currentlong:String, droplat: String, droplog:String)
    {
        print("ATdebug for live track \(#function)")
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0, right: 0.0)
        self.MapViewForLocation.padding = mapInsets
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(currentlat) ?? 0.0, longitude:  Double(currentlong) ?? 0.0, zoom: 10)
        self.MapViewForLocation.camera = camera
        
        //Drop Location pin setup
        self.Point2Marker = GMSMarker()
        self.Point2Marker?.position = CLLocationCoordinate2D(latitude: Double(droplat) ?? 0.0, longitude: Double(droplog) ?? 0.0)
        
        
        let markerView = MarkerPinView()
        markerView.markerImage = UIImage(named: "ic_PickUp")
        markerView.layoutSubviews()
        
        self.Point2Marker?.iconView = markerView
        self.Point2Marker?.map = self.MapViewForLocation
        
        //Current Location pin setup
        self.TruckMarker = GMSMarker()
        self.TruckMarker?.position = CLLocationCoordinate2D(latitude: Double(currentlat) ?? 0.0, longitude: Double(currentlong) ?? 0.0)
        self.TruckMarker?.snippet = "Your Location"
        
        let markerView2 = MarkerPinView()
        markerView2.markerImage = UIImage(named: "ic_truck_details")
        markerView2.layoutSubviews()
        
        self.TruckMarker?.iconView = markerView2
        self.TruckMarker?.map = self.MapViewForLocation
        //self.MapViewForLocation.selectedMarker = self.DropLocMarker
        

        self.fetchRoute(currentlat: currentlat, currentlong: currentlong, droplat: droplat, droplog: droplog, isStatic: false)
    }
    
    func fetchRoute(currentlat: String, currentlong:String, droplat: String, droplog:String,isStatic:Bool) {
       print("ATdebug for live track \(#function)")
        
        if isStatic {
            let start = CLLocationCoordinate2D(latitude: LoadDetails?.trucks?.locations?.first?.dropLat?.toDouble() ?? 0.0, longitude: LoadDetails?.trucks?.locations?.first?.dropLng?.toDouble() ?? 0.0)


            let sessionManager = SessionManager()
           
            var endPoints : [CLLocationCoordinate2D] = []
             LoadDetails?.trucks?.locations?.forEach({ (element) in
                let endLocation = CLLocationCoordinate2D(latitude: element.dropLat?.toDouble() ?? 0.0, longitude: element.dropLng?.toDouble() ?? 0.0)
                endPoints.append(endLocation)
            })
            
            sessionManager.requestDirections(from: start, to: endPoints, completionHandler: { (path, error) in
                
                if let error = error {
                    print("Something went wrong, abort drawing!\nError: \(error)")
                } else {
                    self.drawPath(from: path, isStatic: isStatic)
                     
                }
            })
            for data in endPoints{
                let location = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
                print("location: \(location)")
                let marker = GMSMarker()
                marker.position = location
                marker.icon = UIImage(named: "ic_PickUp")
                marker.map = self.MapViewForLocation
            }
        } else {
              let start = CLLocationCoordinate2D(latitude: currentlat.toDouble(), longitude: currentlong.toDouble())
         
              let end = CLLocationCoordinate2D(latitude: droplat.toDouble(), longitude: droplog.toDouble())


            let sessionManager = SessionManager()


          
            sessionManager.requestDirections(from: start, to: [end], completionHandler: { (path, error) in
                
                if let error = error {
                    print("Something went wrong, abort drawing!\nError: \(error)")
                } else {
                    self.drawPath(from: path, isStatic: isStatic)
                     
                }
            })
        }
        
      
    }
    
    func drawPath(from path: GMSPath?,isStatic:Bool){
       print("ATdebug for live track \(#function)")
        if let Path = path {
            self.path = Path
        }
        self.polyline = GMSPolyline(path: path)
        self.polyline.strokeWidth = 3.0
        self.polyline.strokeColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        self.polyline.map = self.MapViewForLocation
        let bounds = GMSCoordinateBounds(path: path ?? GMSPath())
        let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 50, bottom: 10, right: 50))
        self.MapViewForLocation.animate(with: cameraUpdate)
        if !isStatic {
            self.setupTrackingMarker()
        }
       //
    }
    
    func setupTrackingMarker(){
       print("ATdebug for live track \(#function)")
        if(self.path.count() <= 0) {
            return
        }
        

        if(self.oldCoordinate == nil){
            self.oldCoordinate = CLLocationCoordinate2DMake(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude, SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)
            
        }
        if(self.TruckMarker == nil){
            self.TruckMarker = GMSMarker(position: self.oldCoordinate ?? SingletonClass.sharedInstance.userCurrentLocation.coordinate)
            self.TruckMarker?.icon = UIImage(named: "ic_truck_details")
            self.TruckMarker?.map = self.MapViewForLocation
        }
        UpdatePath()
        let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude, SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: newCoordinate.latitude, longitude: newCoordinate.longitude, zoom: 17)
        self.MapViewForLocation.animate(to: camera)
        
    }
    func UpdatePath() {
        print("ATdebug for live track \(#function)")
        let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude, SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)
        self.moveMent?.arCarMovement(marker: self.TruckMarker!, oldCoordinate: self.oldCoordinate ?? SingletonClass.sharedInstance.userCurrentLocation.coordinate, newCoordinate: newCoordinate, mapView: self.MapViewForLocation, bearing: Float(0))
        self.oldCoordinate = newCoordinate
        self.updateTravelledPath(currentLoc: newCoordinate)
    }
    
    //MARK: - update TravelledPath Methods
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
       print("ATdebug for live track \(#function)")
        var index = 0
        self.coordinates = []
        //  print("---------- Polyline Array ----------")
        if self.path.count() != 0 {
            for i in 0..<self.path.count(){
                let pathLat = Double(self.path.coordinate(at: i).latitude).rounded(toPlaces: 5)
                let pathLong = Double(self.path.coordinate(at: i).longitude).rounded(toPlaces: 5)
                // print(" pathLat - \(pathLat) : pathLong - \(pathLong)")
                
                self.newPoint = CLLocation(latitude: pathLat, longitude: pathLong)
                if(self.oldPoint == nil){
                    self.oldPoint = self.newPoint
                }
                self.getAllCoordinate(startPoint: self.oldPoint, endPoint: self.newPoint)
                self.oldPoint = self.newPoint
                
                let coord = CLLocation(latitude: pathLat, longitude: pathLong)
                self.coordinates.append(coord)
            }
            
            let userLocation = CLLocation(latitude: Double(currentLoc.latitude).rounded(toPlaces: 5), longitude: Double(currentLoc.longitude).rounded(toPlaces: 5))
            let closest = self.coordinates.min(by:{ $0.distance(from: userLocation) < $1.distance(from: userLocation) })
            index = self.coordinates.firstIndex{$0 === closest}!
            
            let Meters = closest?.distance(from: userLocation) ?? 0
            //  print("Distance from closest point---------- \(Meters.rounded(toPlaces: 2)) meters")
            if(Meters > 300){
                // print("New route ---***---***---**--**--**--**----*****")
                self.oldPoint = nil
                self.newPoint = nil
                self.oldCoordinate = nil
                self.setupPickupRoute()
                return
            }
            
            //Creating new path from the current location to the destination
            let newPath = GMSMutablePath()
            for i in index..<Int(self.coordinates.count){
                newPath.add(CLLocationCoordinate2D(latitude: self.coordinates[i].coordinate.latitude, longitude: self.coordinates[i].coordinate.longitude))
            }
            if (self.polyline != nil){
                polyline.map = nil
            }
            self.polyline = GMSPolyline(path: newPath)
            self.polyline.strokeColor = UIColor.black
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.MapViewForLocation
            
        }
      
       
        
    }
    
    func getAllCoordinate(startPoint:CLLocation, endPoint:CLLocation){
    //   print("ATdebug for live track \(#function)")
        let yourTotalCoordinates = Double(5) //1 number of coordinates, change it as per your uses
        let latitudeDiff = startPoint.coordinate.latitude - endPoint.coordinate.latitude //2
        
        let longitudeDiff = startPoint.coordinate.longitude - endPoint.coordinate.longitude //3
        let latMultiplier = latitudeDiff / (yourTotalCoordinates + 1) //4
        let longMultiplier = longitudeDiff / (yourTotalCoordinates + 1) //5
        
        for index in 1...Int(yourTotalCoordinates) { //7
            let lat  = startPoint.coordinate.latitude - (latMultiplier * Double(index)) //8
            let long = startPoint.coordinate.longitude - (longMultiplier * Double(index)) //9
            let point = CLLocation(latitude: lat.rounded(toPlaces: 5), longitude: long.rounded(toPlaces: 5)) //10
            //   print(" pathLat - \(point.coordinate.latitude) : pathLong - \(point.coordinate.longitude)")
            self.coordinates.append(point) //11
        }
    }
}
extension Double {
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
class MarkerPinView: UIView {
    @IBInspectable var markerImage: UIImage?
//    @IBInspectable var imageview: UIImageView!
    override func awakeFromNib() {
           super.awakeFromNib()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let imageview = UIImageView()
//        if markerImage != nil{
            imageview.image = markerImage
//        }else{
//            imageview.image = UIImage(named: "profile_placeholder_2")
//        }
        
        imageview.frame = self.frame
        imageview.contentMode = .scaleAspectFit
//        imageview.cornerRadius = self.frame.size.height / 2
//        imageview.borderWidth = 3
//        imageview.borderColor = .white
        imageview.clipsToBounds = true
//        self.cornerRadius = self.frame.size.height / 2
//        self.borderWidth = 2
//        self.borderColor = ThemeColor.primary
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(imageview)
    }
}
//MARK:- ARCarMovementDelegate
extension SchedualLoadDetailsViewController : ARCarMovementDelegate{
    func arCarMovementMoved(_ marker: GMSMarker) {
        
        self.TruckMarker = nil
        self.TruckMarker = marker
        self.TruckMarker?.map = self.MapViewForLocation
    }
    
}

