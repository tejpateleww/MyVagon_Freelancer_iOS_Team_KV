//
//  BidRequestDetailViewController.swift
//  MyVagon
//
//  Created by Apple on 20/12/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import SDWebImage
import UIView_Shimmer
import MapKit
import FittedSheets
import Cosmos

class PostedTruckBidReqDetailVC: BaseViewController {
    
    //MARK: - Propertise
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
    @IBOutlet weak var viewRatting: CosmosView!
    @IBOutlet weak var lblShipperName: themeLabel!
    @IBOutlet weak var lblShipperRatting: themeLabel!
    @IBOutlet weak var imgShipperProfile: UIImageView!
    @IBOutlet weak var viewShipperDetail: UIView!
    @IBOutlet weak var btnReject: themeButton!
    @IBOutlet weak var btnAccept: themeButton!
    @IBOutlet weak var lblTotalKM: themeLabel!
    @IBOutlet weak var lblJourney: themeLabel!
    @IBOutlet weak var lblShipperDetails: UILabel!
    @IBOutlet weak var btnNotes: themeButton!
    
    var loadDetailViewModel = LoadDetailViewModel()
    var LoadDetails : MyLoadsNewPostedTruck?
    var arrTypes:[(MyLoadsNewTruckTypeCategory,Bool)] = []
    var isLoading = false {
        didSet {
            tblMainData.isUserInteractionEnabled = !isLoading
            tblMainData.reloadData()
        }
    }
    var customTabBarController: CustomTabBarVC?
    var startLocIndex : Int = 0
    var CurrentLocMarker: GMSMarker?
    var DropLocMarker: GMSMarker?
    var arrMarkers: [GMSMarker] = []
    var path = GMSPath()
    var polyline : GMSPolyline!
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            if collObj == self.tblMainData{
                self.tblMainDataHeight.constant = tblMainData.contentSize.height
            }
        }
    }
    
    //MARK: - Custom method
    func setUpUI(){
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.SetValue()
        self.tblMainData.delegate = self
        self.tblMainData.dataSource = self
        self.tblMainData.reloadData()
        self.setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "Load Details".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.tblMainData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMainData.register(UINib(nibName: "LoadDetailCell", bundle: nil), forCellReuseIdentifier: "LoadDetailCell")
        self.LoadDetails?.bookingInfo?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,true))
        })
        self.ColTypes.reloadData()
        self.MapViewForLocation.isUserInteractionEnabled = false
        self.setupMap()
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
        self.btnAccept.setTitle("Accept".localized, for: .normal)
    }
    
    func SetValue() {
        let data = LoadDetails?.bookingInfo
        let gesture = UITapGestureRecognizer(target: self, action: #selector(reviewGesture(_:)))
        self.viewShipperDetail.addGestureRecognizer(gesture)
        self.viewStatus.backgroundColor = (data?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        self.btnViewNotes.isHidden = ((data?.trucks?.note ?? "") == "") ? true : false
        let radius = viewStatus.frame.height / 2
        self.viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        self.lblBookingID.text = "#\(data?.id ?? 0)"
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1{
            self.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (data?.amount ?? "") : ""
            self.lblPrice.isHidden = false
        }else{
            self.lblPrice.isHidden = true
        }
        self.lblBookingStatus.text = data?.status
        self.lblTruckType.text = data?.trucks?.truckType?.name ?? ""
        self.lbljourney.text = "\(data?.journey ?? "")"
        self.lblJourneyType.text = "\(data?.journeyType ?? "")"
        self.lblTotalMiles.text = "\(data?.distance ?? "")"
        self.lblShipperName.text = data?.shipperDetails?.companyName ?? ""
        let strUrl = "\(APIEnvironment.ShipperImageURL)\(data?.shipperDetails?.profile ?? "")"
        self.imgShipperProfile.isCircle()
        self.imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
        self.viewRatting.settings.fillMode = .precise
        self.viewRatting.rating = Double(data?.shipperDetails?.shipperRating ?? "0.0") ?? 0.0
        self.lblShipperRatting.text = "(\(data?.shipperDetails?.noOfShipperRated ?? 0))"
        self.setStatus(status: data?.status ?? "")
        self.btnAccept.isHidden = ((data?.isBid ?? 0) == 1) ? false : true
        let TimeToCancel = (30*60)-(LoadDetails?.time_difference ?? 0)
        self.btnReject.setTitle(((data?.isBid ?? 0) == 1) ? "Decline".localized : "\( TimeToCancel / 60) minutes remaining to cancel", for: .normal)
        self.btnReject.layer.cornerRadius = ((data?.isBid ?? 0) == 1) ? 0 : 5
        if data?.isBid == 1{
            self.btnReject.setTitle("Decline".localized, for: .normal)
        }else{
            self.setRejectBtn(TimeToCancel)
        }
    }
    
    func setRejectBtn(_ TimeToCancel:Int){
        let attrStri = NSMutableAttributedString.init(string:"\("Decline".localized) (\( TimeToCancel / 60) \("minutes remaining".localized)) ")
        let nsRange = NSString(string: "\("Decline".localized) (\( TimeToCancel / 60) \("minutes remaining".localized)) ").range(of: "Decline".localized, options: String.CompareOptions.caseInsensitive)
        let scRange = NSString(string: "Decline (\( TimeToCancel / 60) \("minutes remaining".localized)) ").range(of: "(\( TimeToCancel / 60) \("minutes remaining".localized)) ", options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14) as Any], range: nsRange)
        attrStri.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.6) as Any], range: scRange)
        self.btnReject.setAttributedTitle(attrStri, for: .normal)
    }
    
    func setStatus(status: String){
        switch status {
        case MyLoadesStatus.pending.Name:
            self.lblBookingStatus.text =  MyLoadesStatus.pending.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.4078431373, blue: 0.4039215686, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            self.lblBookingStatus.text =  MyLoadesStatus.scheduled.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        case MyLoadesStatus.inprocess.Name:
            self.lblBookingStatus.text =  MyLoadesStatus.inprocess.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
        case MyLoadesStatus.completed.Name:
            self.lblBookingStatus.text =  MyLoadesStatus.completed.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        case MyLoadesStatus.canceled.Name.capitalized:
            self.lblBookingStatus.text =  MyLoadesStatus.canceled.Name.localized.capitalized
            self.viewStatus.backgroundColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
        default:
            break
        }
    }
    
    @objc func reviewGesture(_ sender: UITapGestureRecognizer){
        let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: shipperDetailsVC.storyboardID) as! shipperDetailsVC
        controller.shipperId = "\(LoadDetails?.shipperId ?? 0)"
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
        }
    
    //MARK: - IBAction method
    @IBAction func btnNotesClick(_ sender: themeButton) {
        let data = LoadDetails?.bookingInfo
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
        controller.noteString = (data?.trucks?.note ?? "")
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280 + appDel.GetSafeAreaHeightFromBottom()))])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion:  {
        })
    }
    
    @IBAction func btnAcceptClick(_ sender: themeButton) {
        self.callAPIForAcceptReject(Accepted: true, bookingID: "\(LoadDetails?.id ?? 0)", loadDetails: LoadDetails, isForBook: false)
    }
    
    @IBAction func btnRejectClick(_ sender: themeButton) {
        if (LoadDetails?.isBid ?? 0) == 1 {
            self.callAPIForAcceptReject(Accepted: false, bookingID: "\(LoadDetails?.id ?? 0)", loadDetails: LoadDetails, isForBook: false)
        } else {
            self.callAPIForAcceptReject(Accepted: false, bookingID: "\(LoadDetails?.id ?? 0)", loadDetails: LoadDetails, isForBook: true)
        }
    }
   
}

//MARK: - Tableview DataSource and delegate
extension PostedTruckBidReqDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadDetails?.bookingInfo?.trucks?.locations?.count ?? 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainData.dequeueReusableCell(withIdentifier: "LoadDetailCell") as! LoadDetailCell
        cell.ViewForSavingTree.isHidden = true
        let data = LoadDetails?.bookingInfo
        if(indexPath.row == 0){
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_PickUp")
        }else if(indexPath.row == (data?.trucks?.locations?.count ?? 0) - 1){
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_DropOff")
        }else{
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_pickDrop")
            cell.vWHorizontalDotLine.isHidden = false
        }
        cell.lblName.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        cell.lblAddress.text = data?.trucks?.locations?[indexPath.row].dropLocation ?? ""
        cell.lblDate.text = data?.trucks?.locations?[indexPath.row].companyName ?? ""
        if (data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "") == (data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "") {
            cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
        } else {
            cell.lblDate.text =  "\(data?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(data?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
        }
        cell.btnNotes.isHidden = (data?.trucks?.locations?[indexPath.row].note ?? "" == "")
        cell.btnNoteClick = {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
            controller.noteString = data?.trucks?.locations?[indexPath.row].note ?? ""//self.LoadDetails?.note ?? ""
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .coverVertical
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280) + appDel.GetSafeAreaHeightFromBottom())])
            sheetController.allowPullingPastMaxHeight = false
            UIApplication.topViewController()?.present(sheetController, animated: true, completion:  {
            })
        }
        var picUp = 0
        if data?.bookingType == "multiple_shipment"{
            if data?.trucks?.locations?[indexPath.row].products?.count ?? 0 > 1{
                cell.showStatus = true
            }else{
                picUp = data?.trucks?.locations?[indexPath.row].products?.first?.isPickup ?? 0
            }
        }else{
            picUp = data?.trucks?.locations?[indexPath.row].isPickup ?? 0
        }
        if cell.showStatus{
            cell.lblPickupDropOff.text = ""
            cell.lblPickupDropOff.superview?.backgroundColor = .clear
        }else{
            cell.lblPickupDropOff.text = picUp == 0 ? "DROP".localized : "PICKUP".localized
            cell.lblPickupDropOff.superview?.backgroundColor = (picUp == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SearchLocationVC.storyboardID) as! SearchLocationVC
        controller.locationId = "\(self.LoadDetails?.bookingInfo?.trucks?.locations?[indexPath.row].id ?? 0)"
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
  
}

//MARK: - CollectionView DataSource and delegate
extension PostedTruckBidReqDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
}

//MARK: - MKMapView delegate
extension PostedTruckBidReqDetailVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        return rendere
    }
}

//MARK: - MapView method
extension PostedTruckBidReqDetailVC {
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
        sourcelat = LoadDetails?.bookingInfo?.trucks?.locations?[startLocIndex].dropLat ?? "0.0"
        sourcelng = LoadDetails?.bookingInfo?.trucks?.locations?[startLocIndex].dropLng ?? "0.0"
        destinationlat = LoadDetails?.bookingInfo?.trucks?.locations?[startLocIndex + 1].dropLat ?? "0.0"
        destinationLong = LoadDetails?.bookingInfo?.trucks?.locations?[startLocIndex + 1].dropLng ?? "0.0"
        self.MapSetup(currentlat: sourcelat, currentlong: sourcelng, droplat: destinationlat, droplog: destinationLong)
    }
    
    func MapSetup(currentlat: String, currentlong:String, droplat: String, droplog:String){
        DispatchQueue.main.async {
            //Drop Location pin setup
            self.DropLocMarker = GMSMarker()
            self.DropLocMarker?.position = CLLocationCoordinate2D(latitude: Double(droplat) ?? 0.0, longitude: Double(droplog) ?? 0.0)
            self.DropLocMarker?.snippet = self.LoadDetails?.bookingInfo?.trucks?.locations?[self.startLocIndex + 1].dropLocation ?? ""
            let markerView = MarkerPinView()
            markerView.markerImage = (self.startLocIndex == (self.LoadDetails?.bookingInfo?.trucks?.locations?.count ?? 0) - 2) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_pickDrop")
            markerView.layoutSubviews()
            self.DropLocMarker?.iconView = markerView
            DispatchQueue.main.async {
                self.DropLocMarker?.map = self.MapViewForLocation
            }
            //Current Location pin setup
            self.CurrentLocMarker = GMSMarker()
            self.CurrentLocMarker?.position = CLLocationCoordinate2D(latitude: Double(currentlat) ?? 0.0, longitude: Double(currentlong) ?? 0.0)
            self.CurrentLocMarker?.snippet = self.LoadDetails?.bookingInfo?.trucks?.locations?[self.startLocIndex].dropLocation ?? ""
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
        
        if(LoadDetails?.bookingInfo?.trucks?.locations?.count ?? 0 > 2 && LoadDetails?.bookingInfo?.trucks?.locations?.count != (startLocIndex + 2)){
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
extension PostedTruckBidReqDetailVC{
    func callAPIForAcceptReject(Accepted:Bool,bookingID:String,loadDetails:MyLoadsNewPostedTruck?,isForBook:Bool) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: PostedTruckBidReqActionVC.storyboardID) as! PostedTruckBidReqActionVC
        controller.bidRequestDetailViewController = self
        controller.LoadDetails = loadDetails
        controller.isAccept = Accepted
        controller.isForBook = isForBook
        controller.isFromDetails = true
        let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(22)] as [NSAttributedString.Key : Any]
        if isForBook {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: PostedTruckCancelReqVC.storyboardID) as! PostedTruckCancelReqVC
            controller.hidesBottomBarWhenPushed = true
            let TimeToCancel = (30*60)-(loadDetails?.time_difference ?? 0)
            let remainingsMinute = TimeToCancel / 60
            controller.remainingsMinute = remainingsMinute
            controller.booking_id = "\(loadDetails?.bookingInfo?.id ?? 0)"
            controller.booking_request_id = "\(loadDetails?.id ?? 0)"
            controller.shipper_id = "\(LoadDetails?.shipperId ?? 0)"
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(((SingletonClass.sharedInstance.cancellationReasons?.count ?? 0) * 50) + 120) + appDel.GetSafeAreaHeightFromBottom())])
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
}
