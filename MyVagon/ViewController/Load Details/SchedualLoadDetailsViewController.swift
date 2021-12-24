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


class SchedualLoadDetailsViewController: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
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
    @IBOutlet weak var MapViewWithTwoLocation: MKMapView!
@IBOutlet weak var vwShimmer: UIView!
    @IBOutlet weak var scrollViewHide: UIScrollView!
    @IBOutlet weak var btnViewNotes: themeButton!
    @IBOutlet weak var imgMapDistance: UIImageView!
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
    
    @IBOutlet weak var btnViewPOD: themeButton!

    
    @IBOutlet weak var btnStartTrip: themeButton!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        
       
        
        MapViewForLocation.isUserInteractionEnabled = true
        
        
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
        
        let data = LoadDetails
        let arrLocation = data?.trucks?.locations
        for i in 0...((arrLocation?.count ?? 0) - 1) {
            if ((arrLocation?[i].arrivedAt ?? "") == "") || ((arrLocation?[i].StartLoading ?? "") == "") || ((arrLocation?[i].startJourney ?? "") == "") {
                
                SingletonClass.sharedInstance.CurrentTripSecondLocation = arrLocation?[i]
               
                
                break
            }
        }
       
       
        SingletonClass.sharedInstance.CurrentTripShipperID = "\(data?.shipperDetails?.id ?? 0)"
        let DateOfPickup = "\(data?.date ?? "") \(data?.pickupTimeTo ?? "")"
        
        let DateFromatChange = DateOfPickup.StringToDate(Format: "yyyy-MM-dd h:m a")
        
        let serverDate =  SingletonClass.sharedInstance.SystemDate.StringToDate(Format: "yyyy-MM-dd hh:mm:ss")
        print(serverDate)
        print(DateFromatChange)
        
        var daysLeft:(String,Int,OffSetType) = ("0 second",0,.Second)
        if DateFromatChange.seconds(from: serverDate) > 0 {
            daysLeft = DateFromatChange.offset(from: serverDate)
            
       
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
       
        lblShipperName.text = data?.shipperDetails?.name ?? ""
        
        let strUrl = "\(APIEnvironment.ShipperImageURL)\(data?.shipperDetails?.profile ?? "")"
        imgShipperProfile.isCircle()
        imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
        lblShipperRatting.text = ""
        self.btnViewPOD.superview?.isHidden = true
        lblDaysToGo.superview?.isHidden = true
     
        self.btnStartTrip.superview?.isHidden = true
        switch data?.status {
        case MyLoadesStatus.pending.Name:
            lblBookingStatus.text =  MyLoadesStatus.pending.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            lblDaysToGo.superview?.backgroundColor = UIColor(hexString: "#F9F1DF")
            lblDaysToGo.fontColor = UIColor(hexString: "#000000")
            lblDaysToGo.layoutSubviews()
            self.btnStartTrip.superview?.isHidden = ( daysLeft.2 == .Second && daysLeft.1 <= 0) ? false : true
            lblDaysToGo.superview?.isHidden = ( daysLeft.2 == .Second && daysLeft.1 <= 0) ? true : false

            lblBookingStatus.text =  MyLoadesStatus.scheduled.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        case MyLoadesStatus.inprocess.Name:
            lblDaysToGo.superview?.isHidden = false
            lblDaysToGo.superview?.backgroundColor = UIColor(hexString: "#1F1F41")
            lblDaysToGo.fontColor = UIColor(hexString: "#FFFFFF")
            lblDaysToGo.layoutSubviews()
            
            if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.arrivedAt ?? "") == "" {
                self.lblDaysToGo.text = "Enroute to \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                self.btnStartTrip.superview?.isHidden = false
                self.btnStartTrip.setTitle(TripStatus.ClicktoStartTrip.Name, for: .normal)
            } else if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.StartLoading ?? "") == "" {
                if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                    self.btnStartTrip.setTitle(TripStatus.StartLoading.Name, for: .normal)
                } else {
                    self.btnStartTrip.setTitle(TripStatus.StartOffLoad.Name, for: .normal)
                }
                
                self.lblDaysToGo.text =  "Arrived at \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                self.btnStartTrip.superview?.isHidden = false
            } else if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.startJourney ?? "") == "" {
                if (SingletonClass.sharedInstance.CurrentTripSecondLocation?.isPickup ?? 0) == 1 {
                    self.lblDaysToGo.text =  "Loading at \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                } else {
                    self.lblDaysToGo.text =  "Off Loading at \(SingletonClass.sharedInstance.CurrentTripSecondLocation?.companyName ?? "")"
                }
                if self.LoadDetails?.trucks?.locations?.last?.id == SingletonClass.sharedInstance.CurrentTripSecondLocation?.id {
                    self.btnStartTrip.setTitle(TripStatus.CompleteTrip.Name, for: .normal)
                } else {
                    self.btnStartTrip.setTitle(TripStatus.StartJourney.Name, for: .normal)
                }
               
                self.btnStartTrip.superview?.isHidden = false
            }
            
            lblBookingStatus.text =  MyLoadesStatus.inprocess.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
        case MyLoadesStatus.completed.Name:
            self.btnViewPOD.superview?.isHidden = ((data?.podURL ?? "") != "") ? false : true
            if (data?.podURL ?? "") == "" {
                self.btnStartTrip.setTitle(TripStatus.UploadPOD.Name, for: .normal)

                self.btnStartTrip.superview?.isHidden = false

            } else if (data?.shipperRate ?? "") == "" {
                self.btnStartTrip.setTitle(TripStatus.RateShipper.Name, for: .normal)
                self.btnStartTrip.superview?.isHidden = false
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
        
        
       
        updateMap()
        
       
    
    }
   
   
    func updateMap() {
        let start : CLLocationCoordinate2D?
        let end : CLLocationCoordinate2D?
        
        let StartMaker = GMSMarker();
        
        let DestinationMarker = GMSMarker();
    
        StartMaker.position = SingletonClass.sharedInstance.userCurrentLocation.coordinate
        
        DestinationMarker.position = CLLocationCoordinate2D(latitude: SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLat?.toDouble() ?? 0.0, longitude: SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLng?.toDouble() ?? 0.0)
    
        start = SingletonClass.sharedInstance.userCurrentLocation.coordinate
        end = CLLocationCoordinate2D(latitude: SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLat?.toDouble() ?? 0.0, longitude: SingletonClass.sharedInstance.CurrentTripSecondLocation?.dropLng?.toDouble() ?? 0.0)
        
        let sessionManager = SessionManager()
        print()

        sessionManager.requestDirections(from: start!, to: end!, completionHandler: { (path, error) in

               if let error = error {
                   print("Something went wrong, abort drawing!\nError: \(error)")
               } else {
                   // Create a GMSPolyline object from the GMSPath

                   let polyline = GMSPolyline(path: path)
                polyline.strokeColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
                polyline.strokeWidth = 3
                   // Add the GMSPolyline object to the mapView
                   polyline.map = self.MapViewForLocation

                   // Move the camera to the polyline
                let bounds = GMSCoordinateBounds(path: path ?? GMSPath())
                   let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 50, bottom: 10, right: 50))
                   self.MapViewForLocation.animate(with: cameraUpdate)
              
               
            
                StartMaker.icon = #imageLiteral(resourceName: "ic_PickUp")
                StartMaker.map = self.MapViewForLocation;

              
                DestinationMarker.icon = #imageLiteral(resourceName: "ic_truck_details") //self.setUserImageInMarker()// #imageLiteral(resourceName: "ic_ChatProfile")
                DestinationMarker.map = self.MapViewForLocation;

               }

           })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            if collObj == self.tblMainData{
                self.tblMainDataHeight.constant = tblMainData.contentSize.height
            }
        }
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
        if sender.titleLabel?.text == TripStatus.ClicktoStartTrip.Name {
           EmitForStartTrip(BookingID: "\(LoadDetails?.id ?? 0)", LocationID: "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)", ShipperID: "\(LoadDetails?.shipperDetails?.id ?? 0)")
       } else if sender.titleLabel?.text == TripStatus.Arrivedatpickuplocation.Name {
            CallAPIForArriveAtLocation()
        } else if sender.titleLabel?.text == TripStatus.StartLoading.Name {
            CallAPIForStartLoading()
        } else if sender.titleLabel?.text == TripStatus.StartJourney.Name {
            CallAPIForStartJourney()
        } else if sender.titleLabel?.text == TripStatus.ArrivedatDroplocation.Name {
            CallAPIForArriveAtLocation()
        }  else if sender.titleLabel?.text == TripStatus.CompleteTrip.Name {
            CallAPIForCompleteTrip()
        } else if sender.titleLabel?.text == TripStatus.StartOffLoad.Name {
            CallAPIForStartLoading()
        } else if sender.titleLabel?.text == TripStatus.UploadPOD.Name {
            AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
            AttachmentHandler.shared.imagePickedBlock = { (image) in
                self.ImageUploadAPI(arrImages: [image])
            }
        } else if sender.titleLabel?.text == TripStatus.RateShipper.Name {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ReviewShipperVC.storyboardID) as! ReviewShipperVC
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
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
        cell.PickUpDropOffImageView.image =  (data?.trucks?.locations?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
        cell.lblName.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        cell.lblAddress.text = data?.trucks?.locations?[indexPath.row].dropLocation ?? ""
        cell.lblDate.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        
        if (data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "") == (data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "") {
            cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
        } else {
            cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
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
//                cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
//            } else {
//                cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
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
//MARK: - Draw Root Line
extension SchedualLoadDetailsViewController {
    func createPath(sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D) {
          let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
          let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
          
          
          let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
          let destinationItem = MKMapItem(placemark: destinationPlaceMark)
          
          
          let sourceAnotation = MKPointAnnotation()
          sourceAnotation.title = "Delhi"
          sourceAnotation.subtitle = "The Capital of INIDA"
          if let location = sourcePlaceMark.location {
              sourceAnotation.coordinate = location.coordinate
          }
          
          let destinationAnotation = MKPointAnnotation()
          destinationAnotation.title = "Gurugram"
          destinationAnotation.subtitle = "The HUB of IT Industries"
          if let location = destinationPlaceMark.location {
              destinationAnotation.coordinate = location.coordinate
          }
          
          self.MapViewWithTwoLocation.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
          
          let directionRequest = MKDirections.Request()
          directionRequest.source = sourceMapItem
          directionRequest.destination = destinationItem
          directionRequest.transportType = .automobile
          
          let direction = MKDirections(request: directionRequest)
          
          
          direction.calculate { (response, error) in
              guard let response = response else {
                  if let error = error {
                      print("ERROR FOUND : \(error.localizedDescription)")
                  }
                  return
              }
              
              let route = response.routes[0]
              self.MapViewWithTwoLocation.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
              
              let rect = route.polyline.boundingMapRect
              
              self.MapViewWithTwoLocation.setRegion(MKCoordinateRegion(rect), animated: true)
              
          }
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
        }
    }
}
extension SchedualLoadDetailsViewController {
//    func drowPolyline(doctorLocation: CLLocation, patientLocation: CLLocation){
//        print("patientLocation>>>>>>",patientLocation)
//        let doctorLatLng = "\(doctorLocation.coordinate.latitude),\(doctorLocation.coordinate.longitude)"
//        let patientLatLng = "\(patientLocation.coordinate.latitude),\(patientLocation.coordinate.longitude)"
//        
//        WebServiceSubClass.googleDirectionApi(origin: doctorLatLng, destination: patientLatLng) { [self] (json, status, response) in
//            print(json)
//            // let json = try? JSON(data: response.data!)
//            let routes = json["routes"].arrayValue
//            for route in routes{
//                self.isDrawPolyline = true
//                let routeOverviewPolyline = route["overview_polyline"].dictionary
//                let points = routeOverviewPolyline?["points"]?.stringValue
//                let path = GMSPath.init(fromEncodedPath: points ?? "")
//                
//                self.polyline.path = path
//                self.polyline.strokeColor = colors.appColor.value
//                self.polyline.strokeWidth = 5.0
//                self.polyline.map = self.PatientLocationMapView
//                
//                let bounds = GMSCoordinateBounds(path: path!)
//                PatientLocationMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80))
//            }
//        }
//    }
//    func tracingLocation(currentLocation: CLLocation) {
//        print("ATDebug :: currentLocationcurrentLocationLocation>>>>>>",currentLocation)
//        SingletonClass.sharedInstance.userCurrentLocation = currentLocation
//        setupMarker(marker: self.doctorMarker, coordinatePosition: currentLocation.coordinate, isfromDoctor: true)
//        self.emitTracking(location: currentLocation)
//        carAnimator = CarAnimator(carMarker: self.doctorMarker, mapView: PatientLocationMapView)
//        
//        self.carAnimator.animate(from: CLLocationCoordinate2D(latitude: SingletonClass.sharedInstance.userpreviousLocation.coordinate.latitude, longitude: SingletonClass.sharedInstance.userpreviousLocation.coordinate.longitude), to: CLLocationCoordinate2D(latitude: SingletonClass.sharedInstance.userLastLocation.coordinate.latitude, longitude: SingletonClass.sharedInstance.userLastLocation.coordinate.longitude))
//        
//        if isDrawPolyline  == false{
//            self.drowPolyline(doctorLocation: currentLocation, patientLocation: patientLocation)
//        }
//    }
}
