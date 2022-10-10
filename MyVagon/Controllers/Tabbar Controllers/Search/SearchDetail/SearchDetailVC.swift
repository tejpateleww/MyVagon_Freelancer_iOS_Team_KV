//
//  LoadDetailsVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 27/08/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import SDWebImage
import UIView_Shimmer
import MapKit
import FittedSheets
import Cosmos
import CoreMIDI

extension UILabel: ShimmeringViewProtocol { }
extension UISwitch: ShimmeringViewProtocol { }
extension UIProgressView: ShimmeringViewProtocol { }
extension UITextView: ShimmeringViewProtocol { }
extension UIStepper: ShimmeringViewProtocol { }
extension UISlider: ShimmeringViewProtocol { }
extension UIImageView: ShimmeringViewProtocol { }
extension UIButton : ShimmeringViewProtocol { }

class SearchDetailVC: BaseViewController {
    
    // MARK: - Propertise
    @IBOutlet weak var MapViewForLocation: GMSMapView!
    @IBOutlet weak var vwShimmer: UIView!
    @IBOutlet weak var scrollViewHide: UIScrollView!
    @IBOutlet weak var btnViewNotes: themeButton!
    @IBOutlet weak var viewShipperDetail: UIView!
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
    @IBOutlet weak var btnBidNow: themeButton!
    @IBOutlet weak var lblShipperName: themeLabel!
    @IBOutlet weak var lblShipperRatting: themeLabel!
    @IBOutlet weak var imgShipperProfile: UIImageView!
    @IBOutlet weak var viewRatting: CosmosView!
    @IBOutlet weak var lblTotalKM: themeLabel!
    @IBOutlet weak var lblJourney: themeLabel!
    @IBOutlet weak var lblShipperDetails: UILabel!
    
    var loadDetailViewModel = LoadDetailViewModel()
    var LoadDetails : SearchLoadsDatum?
    var arrTypes:[(SearchTruckTypeCategory,Bool)] = []
    var isLoading = false {
        didSet {
            tblMainData.isUserInteractionEnabled = !isLoading
            tblMainData.reloadData()
        }
    }
    var customTabBarController: CustomTabBarVC?
    var isFromRelated = false
    var startLocIndex : Int = 0
    var CurrentLocMarker: GMSMarker?
    var DropLocMarker: GMSMarker?
    var arrMarkers: [GMSMarker] = []
    var path = GMSPath()
    var polyline : GMSPolyline!
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.setValue()
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
    func addNotificationObs(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: .backToLoadDeatil, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backToLoadDeatil), name: .backToLoadDeatil, object: nil)
    }
    
    @objc func backToLoadDeatil() {
        NotificationCenter.default.post(name: .reloadDataForSearch, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.lblJourney.text = "\("Journey".localized) : "
        self.lblTotalKM.text = "\("Total Km".localized) :"
        self.lblShipperDetails.text = "\("Shipper Details".localized) : "
        self.btnViewNotes.setTitle("Notes".localized, for: .normal)
    }
    
    func setValue() {
        LoadDetails?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,true))
        })
        ColTypes.reloadData()
        addNotificationObs()
        setupMap()
        self.setUpUI()
        self.setData()
        self.setUpTableView()
    }
    
    func setUpTableView(){
        tblMainData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblMainData.register(UINib(nibName: "LoadDetailCell", bundle: nil), forCellReuseIdentifier: "LoadDetailCell")
        tblMainData.delegate = self
        tblMainData.dataSource = self
        tblMainData.reloadData()
    }
    
    func setUpUI(){
        setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "Load Details".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        viewStatus.backgroundColor = (LoadDetails?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        btnViewNotes.isHidden = ((LoadDetails?.trucks?.note ?? "") == "") ? true : false
        let radius = viewStatus.frame.height / 2
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        let strUrl = "\(APIEnvironment.ShipperImageURL)\(LoadDetails?.shipperDetails?.profile ?? "")"
        imgShipperProfile.isCircle()
        imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
        if (LoadDetails?.isBid ?? 0) == 1 {
            btnBidNow.setTitle(  bidStatus.BidNow.Name.localized , for: .normal)
            lblBookingStatus.text = bidStatus.BidNow.Name.localized
            if SingletonClass.sharedInstance.UserProfileData?.permissions?.allowBid ?? 0 == 1 {
                self.btnBidNow.superview?.isHidden = false
            } else {
                self.btnBidNow.superview?.isHidden = true
            }
            viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        } else {
            btnBidNow.setTitle(  bidStatus.BookNow.Name.localized , for: .normal)
            lblBookingStatus.text = bidStatus.BookNow.Name.localized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(reviewGesture(_:)))
        self.viewShipperDetail.addGestureRecognizer(gesture)
    }
    
    func setData(){
        lblBookingID.text = "#\(LoadDetails?.id ?? 0)"
        lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (LoadDetails?.amount ?? "") : ""
        lblTruckType.text = LoadDetails?.trucks?.truckType?.name ?? ""
        lbljourney.text = "\(LoadDetails?.journey ?? "")"
        lblJourneyType.text = "\(LoadDetails?.journeyType ?? "")"
        lblTotalMiles.text = "\(LoadDetails?.distance ?? "")"
        lblDeadHead.text = "\(Double(LoadDetails?.trucks?.locations?.first?.deadhead ?? "") ?? 0.0) Km Deadhead"
        lblDeadHead.isHidden = true
        lblShipperName.text = LoadDetails?.shipperDetails?.companyName ?? ""
        lblShipperRatting.attributedText = "(\(LoadDetails?.shipperDetails?.noOfShipperRated ?? 0))".underLine()
        viewRatting.settings.fillMode = .precise
        viewRatting.rating = Double(LoadDetails?.shipperDetails?.shipperRating ?? "0.0") ?? 0.0
    }
    
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
        self.mapSetup(currentlat: sourcelat, currentlong: sourcelng, droplat: destinationlat, droplog: destinationLong)
    }
    
    func mapSetup(currentlat: String, currentlong:String, droplat: String, droplog:String){
        DispatchQueue.main.async {
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
            //Call this method to draw path on map
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
            for marker in self.arrMarkers{
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 80)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.MapViewForLocation.animate(with: update)
            }
        }
    }
    
    func openReloadView(strTitle : String,isFromRelode: Bool = false){
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewReloadVC.storyboardID) as! ViewReloadVC
        controller.strTitle = strTitle
        controller.isFromRelode = isFromRelode
        controller.bookingId = "\(LoadDetails?.id ?? 0)"
        controller.driverId = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @objc func reviewGesture(_ sender: UITapGestureRecognizer){
        let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: shipperDetailsVC.storyboardID) as! shipperDetailsVC
        controller.shipperId = "\(LoadDetails?.shipperDetails?.id ?? 0)"
        UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func bookNow(){
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ConfirmPopupVC.storyboardID) as! ConfirmPopupVC
        controller.loadDetailsVc = self
        controller.loadDetailsModel = loadDetailViewModel
        controller.bookingID = "\(LoadDetails?.id ?? 0)"
        controller.availabilityId = "\(LoadDetails?.availabilityId ?? 0)"
        controller.isForBook = true
        let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(22)] as [NSAttributedString.Key : Any]
        let DescriptionAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
        controller.TitleAttributedText = NSAttributedString(string: "Booking Confirmation".localized, attributes: TitleAttribute)
        controller.DescriptionAttributedText = NSAttributedString(string: "Do you want to confirm the booking?".localized, attributes: DescriptionAttribute)
        controller.IsHideImage = true
        controller.LeftbtnTitle = "Cancel".localized
        controller.RightBtnTitle = "Book".localized
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
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(210) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func bidNow(){
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ConfirmBidPopupVC.storyboardID) as! ConfirmBidPopupVC
        controller.MinimumBidAmount = LoadDetails?.amount ?? ""
        controller.BookingId = "\(LoadDetails?.id ?? 0)"
        controller.AvailabilityId = "\(LoadDetails?.availabilityId ?? 0)"
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let height = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0) == 0 ? 190 : 280
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(height) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func openNotes(text: String){
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
        controller.noteString = text
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion:  {
        })
    }
    
    // MARK: - IBAction methods
    @IBAction func btnBidNowClick(_ sender: themeButton) {
        switch sender.titleLabel?.text {
        case bidStatus.BookNow.Name.localized:
            self.bookNow()
            break
        case bidStatus.BidNow.Name.localized:
            self.bidNow()
        default:
            break
        }
    }
    
    @IBAction func btnNotesClick(_ sender: themeButton) {
        if (LoadDetails?.trucks?.note ?? "") != "" {
            self.openNotes(text: LoadDetails?.trucks?.note ?? "")
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: "No Notes Available".localized)
        }
    }
}

// MARK: -Tableview dataSource and delegate
extension SearchDetailVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadDetails?.trucks?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainData.dequeueReusableCell(withIdentifier: "LoadDetailCell") as! LoadDetailCell
        cell.setValue(data: LoadDetails?.trucks?.locations?[indexPath.row], bookingType: LoadDetails?.bookingType ?? "")
        var pickupArray = LoadDetails?.trucks?.locations?.compactMap({$0.isPickup})
        pickupArray = pickupArray?.uniqued()
        if(indexPath.row == 0){
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_PickUp")
        }else if(indexPath.row == (LoadDetails?.trucks?.locations?.count ?? 0) - 1){
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_DropOff")
        }else{
            cell.PickUpDropOffImageView.image = UIImage(named: "ic_pickDrop")
            cell.vWHorizontalDotLine.isHidden = false
        }
        cell.btnNoteClick = {
            self.openNotes(text: self.LoadDetails?.trucks?.locations?[indexPath.row].note ?? "")
        }
        if indexPath.row == 0 {
            cell.ViewDottedTop.isHidden = true
        } else if indexPath.row == ((LoadDetails?.trucks?.locations?.count ?? 0) - 1) {
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
}

// MARK: - Collectionview dataSource and delegate
extension SearchDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
