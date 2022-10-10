//
//  TrackingVC.swift
//  MyVagon
//
//  Created by Tej P on 20/05/22.
//

import UIKit
import GoogleMaps
import FittedSheets
import GoogleMaps
import SwiftMessages

class TrackingVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var btnLocTracking: themeButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var clnTracking: UICollectionView!
    @IBOutlet weak var lblTrackStatus: themeLabel!
    @IBOutlet weak var viewRecenter: UIView!
    @IBOutlet weak var btnRecenter: UIButton!
    @IBOutlet weak var viewGoToMaps: UIView!
    @IBOutlet weak var btnGoToMaps: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    private var totalLocations : Int = 0
    private var currentLocation : Int = 1
    private var currentState = TrackStates.Starttrip
    private var arrLocations : [String] = []
    var TripDetails : MyLoadsNewBid?
    let trackingViewModel = TrackingViewModel()
    
    var path = GMSPath()
    var polyline : GMSPolyline!
    var DriverLocMarker: GMSMarker?
    var DropLocMarker: GMSMarker?
    var arrMarkers: [GMSMarker] = []
    var moveMent: ARCarMovement?
    var oldCoordinate: CLLocationCoordinate2D!
    var oldPoint:CLLocation!
    var newPoint:CLLocation!
    var coordinates : [CLLocation] = []
    var isZoomEnable = true
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
        self.allSocketOffMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.SocketOnMethods()
    }
    
    //MARK: - Custom methods
    private func prepareView() {
        mapView.tag = 200
        self.startTimer()
        self.setupUI()
    }
    
    private func setupUI() {
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Live Tracking".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.clnTracking.dataSource = self
        self.clnTracking.delegate = self
        self.clnTracking.showsHorizontalScrollIndicator = false
        self.clnTracking.showsVerticalScrollIndicator = false
        
        self.btnLocTracking.layer.cornerRadius = 5
        self.viewRecenter.layer.cornerRadius = 5
        self.viewGoToMaps.layer.cornerRadius = 5
        self.mapView.layer.cornerRadius = 5
        self.mapView.layer.borderWidth = 1
        self.mapView.layer.borderColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2470588235, alpha: 1)
        self.mapView.delegate = self
        self.btnGoToMaps.setTitle("Open_in_Google_Maps".localized, for: .normal)
        
        self.moveMent = ARCarMovement()
        self.moveMent?.delegate = self
        
        self.registerNib()
    }
    
    private func registerNib() {
        let nib = UINib(nibName: TrackingCell.className, bundle: nil)
        self.clnTracking.register(nib, forCellWithReuseIdentifier: TrackingCell.className)
        self.getTripData()
    }
    
    func setupData() {
        self.arrLocations = []
        let locations = self.TripDetails?.trucks?.locations ?? nil
        for location in locations ?? [] {
            self.arrLocations.append(location.companyName ?? "")
        }
        self.setupCollData()
    }
    
    private func setupCollData(){
        let locCount = self.TripDetails?.trucks?.locations?.count ?? 0
        let locations = self.TripDetails?.trucks?.locations ?? nil
        self.totalLocations = locCount
        var index = 0
        
        if(locCount > 0) {
            for location in locations ?? [] {
                if(location.startJourney == "" || location.arrivedAt == "" || location.StartLoading == ""){
                    self.currentLocation = index + 1
                    break
                }else{
                    index += 1
                }
            }
            self.setupPickupRoute()
            if(index == locCount){
                self.hideHeader()
                self.currentState = .CompleteTrip
            }else{
                self.showHeader()
                if(locations?[index].startJourney == ""){
                    self.currentState = .Starttrip
                }else if(locations?[index].arrivedAt == ""){
                    self.currentState = .EntrouteTo
                    if(self.path.count() == 0){
                        self.drawRoute()
                    }
                }else{
                    if self.TripDetails?.bookingType == "multiple_shipment" && locations?[index].products?.count ?? 0 > 1{
                        var pickup = locations?[index].products?[0].isPickup ?? 0
                        for product in locations?[index].products ?? []{
                            if product.isPickup != pickup{
                                pickup = 3
                            }
                        }
                        if pickup == 1{
                            self.currentState = .StartLoading
                        }else if pickup == 0{
                            self.currentState = .StartUnloding
                        }else{
                            self.currentState = .LodingUnloding
                        }
                    }else{
                        if locations?[index].isPickup == 1{
                            self.currentState = .StartLoading
                        }else{
                            self.currentState = .StartUnloding
                        }
                    }
                }
            }
            self.renameBtnName(currentState: self.currentState)
        }
        self.clnTracking.reloadData()
    }
    
    private func drawRoute() {
        self.mapView.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
        self.oldPoint = nil
        self.newPoint = nil
        self.oldCoordinate = nil
        self.setupPickupRoute()
    }
    
    private func hideHeader() {
        self.viewHeader.isHidden = true
        self.viewHeaderHeight.constant = 0
        self.view.updateConstraintsIfNeeded()
    }
    
    private func showHeader() {
        self.viewHeader.isHidden = false
        self.viewHeaderHeight.constant = 70
        self.view.updateConstraintsIfNeeded()
    }
    
    private func openTripCompAlert(){
        Utilities.showAlertWithTitleFromVC(vc: self, title: "Complete Shipment", message: "CompleteTripAlert".localized, buttons: ["NO".localized,"YES".localized], isOkRed: false) { (ind) in
             if ind == 1{
                 self.compTripConfirm()
             }
         }
     }
    
    private func renameBtnName(currentState : TrackStates) {
        switch currentState {
        case .Starttrip:
            self.lblTrackStatus.text = TrackStates.Starttrip.rawValue.localized
            self.btnLocTracking.setTitle("\(TrackStates.EntrouteTo.rawValue.localized) \(self.arrLocations[currentLocation - 1])", for: .normal)
        case .EntrouteTo:
            self.lblTrackStatus.text = "\(TrackStates.EntrouteTo.rawValue.localized) \(self.arrLocations[currentLocation - 1])"
            self.btnLocTracking.setTitle("\(TrackStates.ArrivedAt.rawValue.localized) \(self.arrLocations[currentLocation - 1])", for: .normal)
        case .ArrivedAt:
            self.lblTrackStatus.text = "\(TrackStates.StartLoading.rawValue.localized) \(self.arrLocations[currentLocation - 1])"
            self.btnLocTracking.setTitle("\(TrackStates.StartLoading.rawValue.localized)", for: .normal)
        case .StartLoading:
            self.lblTrackStatus.text = "\(TrackStates.StartLoading.rawValue.localized) \(self.arrLocations[currentLocation - 1])"
            self.btnLocTracking.setTitle("\(TrackStates.CompleteLoading.rawValue.localized)", for: .normal)
        case .StartUnloding:
            self.lblTrackStatus.text = "\(TrackStates.StartUnloding.rawValue.localized) \(self.arrLocations[currentLocation - 1])"
            self.btnLocTracking.setTitle("\(TrackStates.CompleteUnloding.rawValue.localized)", for: .normal)
        case .LodingUnloding:
            self.lblTrackStatus.text = "\(TrackStates.LodingUnloding.rawValue.localized) \(self.arrLocations[currentLocation - 1])"
            self.btnLocTracking.setTitle("\(TrackStates.CompletelodingUnloding.rawValue.localized)", for: .normal)
        case TrackStates.CompleteTrip:
            self.btnLocTracking.setTitle("\(TrackStates.CompleteTrip.rawValue.localized)", for: .normal)
        default:
            break
        }
        self.clnTracking.reloadData()
    }
    
    private func compTripConfirm() {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ConfirmPopupVC.storyboardID) as! ConfirmPopupVC
        let DescriptionAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
        let AttributedStringFinal = "Shipment completed Successfully".localized.Medium(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), FontSize: 18)
        controller.IsHideImage = false
        controller.ShownImage = #imageLiteral(resourceName: "ic_truck_completed")
        controller.TitleAttributedText = AttributedStringFinal
        controller.DescriptionAttributedText = NSAttributedString(string: "", attributes: DescriptionAttribute)
        controller.LeftbtnTitle = "Not Now".localized
        controller.RightBtnTitle = "Upload POD".localized
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        
        controller.LeftbtnClosour = {
            controller.dismiss(animated: true) {
                self.completeTrip()
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
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(300) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func completeTrip() {
        self.CallAPIForCompleteTrip()
    }
    
    func popToScheduleScreen() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: NewScheduleVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    private func findDistance() -> Bool {
        let currentLat = appDel.locationManager.CurrentLocation?.coordinate.latitude ?? 0.0
        let currentLng = appDel.locationManager.CurrentLocation?.coordinate.longitude ?? 0.0
        let pickLat = Double(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLat ?? "0.0") ?? 0.0
        let pickLng = Double(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLng ?? "0.0") ?? 0.0
        let coordinate = CLLocation(latitude: currentLat, longitude: currentLng)
        let coordinate1 = CLLocation(latitude: pickLat, longitude: pickLng)
        let distanceInMeters = coordinate.distance(from: coordinate1)
        if distanceInMeters < 300 {
            return true
        }else {
            return false
        }
    }
    
    //MARK: - Action methods
    @IBAction func btnRecenterAction(_ sender: Any) {
        let camera = GMSCameraPosition.camera(withLatitude: appDel.locationManager.CurrentLocation?.coordinate.latitude ?? 0.0, longitude:  appDel.locationManager.CurrentLocation?.coordinate.longitude ?? 0.0, zoom: 17)
        self.mapView.animate(to: camera)
    }
    
    @IBAction func btnGoToMapsAction(_ sender: Any) {
        let currentLat = appDel.locationManager.CurrentLocation?.coordinate.latitude ?? 0.0
        let currentLng = appDel.locationManager.CurrentLocation?.coordinate.longitude ?? 0.0
        let pickLat = self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLat ?? "0.0"
        let pickLng = self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLng ?? "0.0"
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)){
            if("\(currentLat)" == "0.0" && "\(currentLng)" == "0.0"){
                UIApplication.shared.open((NSURL(string:"https://maps.google.com/maps?saddr=&daddr=\(pickLat),\(pickLng)")! as URL), options: [:], completionHandler: nil)
            }
            else{
                UIApplication.shared.open((NSURL(string:"https://maps.google.com/maps?saddr=\(currentLat),\(currentLng)&daddr=\(pickLat),\(pickLng)")! as URL), options: [:], completionHandler: nil)
            }
        }else{
            if("\(currentLat)" == "0.0" && "\(currentLng)" == "0.0"){
                UIApplication.shared.open((NSURL(string:"https://maps.google.com/maps?saddr=&daddr=\(pickLat),\(pickLng)")! as URL), options: [:], completionHandler: nil)
            }
            else{
                UIApplication.shared.open((NSURL(string:"https://maps.google.com/maps?saddr=\(currentLat),\(currentLng)&daddr=\(pickLat),\(pickLng)")! as URL), options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func btnLocTrackingAction(_ sender: Any) {
        if(self.currentState == .EntrouteTo){
            if(findDistance()){
                self.CallAPIForArriveAtLocation()
            }else{
                Utilities.ShowAlertOfInfo(OfMessage: "locationerrormsg".localized)
            }
        }else if(self.currentState == .StartLoading || self.currentState == .StartUnloding || self.currentState == .LodingUnloding || self.currentState == .StartUnloding){
            if(self.currentLocation < self.TripDetails?.trucks?.locations?.count ?? 0){
                self.path = GMSPath()
            }
            self.CallAPIForCompLoading()
        }else if(self.currentState == .CompleteTrip) {
            self.openTripCompAlert()
        }
    }
}

//MARK: - collectionView DataSource-Delegate  Methods
extension TrackingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalLocations
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackingCell.className, for: indexPath) as! TrackingCell
        
        cell.imgTruck.isHidden = true
        cell.imgRadioWidth.constant = 15
        
        if(indexPath.row == currentLocation - 1){
            if(self.currentState == .EntrouteTo || self.currentState == .Starttrip){
                cell.imgTruck.isHidden = false
                cell.imgRadio.image = UIImage(named: "ic_GrayRadio")
            }else if(self.currentState == .ArrivedAt || self.currentState == .StartLoading || self.currentState == .CompleteLoading || self.currentState == .StartUnloding||self.currentState == .LodingUnloding) {
                cell.imgRadio.image = UIImage(named: "ic_TrackTruck")
                cell.imgRadioWidth.constant = 25
            }else{
                cell.imgRadio.image = UIImage(named: "ic_GrayRadio")
            }
        }else{
            cell.imgTruck.isHidden = true
            cell.imgRadio.image = UIImage(named: "ic_GrayRadio")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) / CGFloat(self.totalLocations) , height: collectionView.frame.size.height)
    }
}

//MARK: - API calls
extension TrackingVC {
    
    func getTripData() {
        self.trackingViewModel.VC = self
        let reqModel = LoadDetailsReqModel()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.TripDetails?.id ?? 0)"
        self.trackingViewModel.GetLoadDetails(ReqModel: reqModel)
    }
    
    func CallAPIForArriveAtLocation() {
        self.trackingViewModel.VC = self
        let reqModel = ArraivedAtLocationReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.TripDetails?.id ?? 0)"
        reqModel.location_id = "\(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].id ?? 0)"
        self.trackingViewModel.ArrivedAtLocation(ReqModel: reqModel)
    }
    
    func CallAPIForCompLoading() {
        self.trackingViewModel.VC = self
        let reqModel = StartLoadingReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.TripDetails?.id ?? 0)"
        reqModel.location_id = "\(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].id ?? 0)"
        self.trackingViewModel.StartLoading(ReqModel: reqModel)
    }
    
    func CallAPIForCompleteTrip(podImage:String = "") {
        self.trackingViewModel.VC = self
        let reqModel = CompleteTripReqModel()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.booking_id = "\(self.TripDetails?.id ?? 0)"
        reqModel.location_id = "\(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].id ?? 0)"
        reqModel.pod_image = podImage
        self.trackingViewModel.CompleteTrip(ReqModel: reqModel)
    }
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        self.trackingViewModel.VC = self
        self.trackingViewModel.WebServiceImageUpload(images: arrImages)
    }
    
}

//MARK: - Live-Tracking Methods
extension TrackingVC {
    
    func startTimer() {
        if(appDel.timerLocUpdate == nil){
            appDel.timerLocUpdate = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
                if  SocketIOManager.shared.socket.status == .connected {
                    self.emitSocket_UpdateLocation(lat: Double(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLat ?? "0.0") ?? 0.0,
                                                   long: Double(self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLng ?? "0.0") ?? 0.0)
                } else {
                    print("socket not connected")
                    self.SocketOnMethods()
                }
                self.setupTrackingMarker()
            })
        }
    }
    
    func stopTimer(){
        if(appDel.timerLocUpdate != nil){
            appDel.timerLocUpdate?.invalidate()
            appDel.timerLocUpdate = nil
        }
    }
    
    //MARK:- Setup Route methods
    func setupPickupRoute(){
        self.mapView.clear()
        self.path = GMSPath()
        self.polyline = GMSPolyline()
        let CurrentLocLat = String(appDel.locationManager.CurrentLocation?.coordinate.latitude ?? 0.0)
        let CurrentLocLong = String(appDel.locationManager.CurrentLocation?.coordinate.longitude ?? 0.0)
        let PickLocLat =  self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLat ?? "0.0"
        let PickLocLong = self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLng ?? "0.0"
        self.MapSetup(currentlat: CurrentLocLat, currentlong: CurrentLocLong, droplat: PickLocLat, droplog: PickLocLong)
    }
    
    func MapSetup(currentlat: String, currentlong:String, droplat: String, droplog:String){
        let camera = GMSCameraPosition.camera(withLatitude: Double(currentlat) ?? 0.0, longitude:  Double(currentlong) ?? 0.0, zoom: 17)
        self.mapView.camera = camera
        //Drop Location pin setup
        self.DropLocMarker = GMSMarker()
        self.DropLocMarker?.position = CLLocationCoordinate2D(latitude: Double(droplat) ?? 0.0, longitude: Double(droplog) ?? 0.0)
        self.DropLocMarker?.snippet = self.TripDetails?.trucks?.locations?[self.currentLocation - 1].dropLocation ?? ""
        let markerView = MarkerPinView()
        markerView.markerImage = UIImage(named: "ic_DropOff")
        markerView.layoutSubviews()
        self.DropLocMarker?.iconView = markerView
        self.DropLocMarker?.map = self.mapView
        
        //Current Location pin setup
        self.DriverLocMarker = GMSMarker()
        self.DriverLocMarker?.position = CLLocationCoordinate2D(latitude: Double(currentlat) ?? 0.0, longitude: Double(currentlong) ?? 0.0)
        self.DriverLocMarker?.snippet = "Your Location".localized
        let markerView2 = MarkerCarView()
        markerView2.markerImage = UIImage(named: "ic_Car")
        markerView2.layoutSubviews()
        self.DriverLocMarker?.iconView = markerView2
        self.DriverLocMarker?.map = self.mapView
        
        //For Displaying both markers in screen centered
        self.arrMarkers.append(self.DriverLocMarker!)
        self.arrMarkers.append(self.DropLocMarker!)
        var bounds = GMSCoordinateBounds()
        for marker in self.arrMarkers
        {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 80)
        self.mapView.animate(with: update)
        
        self.fetchRoute(currentlat: currentlat, currentlong: currentlong, droplat: droplat, droplog: droplog)
    }
    
    func fetchRoute(currentlat: String, currentlong:String, droplat: String, droplog:String) {
        
        let CurrentLatLong = "\(currentlat),\(currentlong)"
        let DestinationLatLong = "\(droplat),\(droplog)"
        let param = "origin=\(CurrentLatLong)&destination=\(DestinationLatLong)&mode=driving&key=\(AppInfo.Google_API_Key)"
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?\(param)")!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
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
                DispatchQueue.main.async {
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
            
            // For Duration & Distance
            guard let legs = route["legs"] as? [Any] else {
                return
            }
            
            guard let leg = legs[0] as? [String: Any] else {
                return
            }
            
            guard let distanceDict = leg["distance"] as? [String: Any] else {
                return
            }
            
            guard let distance = distanceDict["text"] as? String else {
                return
            }
            
            guard let durationDict = leg["duration"] as? [String: Any] else {
                return
            }
            
            guard let duration = durationDict["text"] as? String else {
                return
            }
            
            print(duration)
            print(distance)
            
            // For polyline
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
        self.path = GMSPath(fromEncodedPath: polyStr)!
        self.polyline = GMSPolyline(path: path)
        self.polyline.strokeWidth = 3.0
        self.polyline.strokeColor = #colorLiteral(red: 0.6117647059, green: 0.2901960784, blue: 0.8901960784, alpha: 1)
        self.polyline.map = self.mapView
        
        if(appDel.timerLocUpdate == nil){
            if(appDel.timerLocUpdate == nil){
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.startTimer()
                }
            }
        }
    }
    
    func setupTrackingMarker(){
        if(self.path.count() <= 0) {
            return
        }
        SingletonClass.sharedInstance.latitude = appDel.locationManager.CurrentLocation?.coordinate.latitude ?? 0.0
        SingletonClass.sharedInstance.longitude = appDel.locationManager.CurrentLocation?.coordinate.longitude ?? 0.0
        if(self.oldCoordinate == nil){
            self.oldCoordinate = CLLocationCoordinate2DMake(SingletonClass.sharedInstance.latitude, SingletonClass.sharedInstance.longitude)
        }
        if(self.DriverLocMarker == nil){
            self.DriverLocMarker = GMSMarker(position: self.oldCoordinate)
            self.DriverLocMarker?.icon = UIImage(named: "ic_Car")
            self.DriverLocMarker?.map = self.mapView
        }
        let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(SingletonClass.sharedInstance.latitude), CLLocationDegrees(SingletonClass.sharedInstance.longitude))
        if oldCoordinate != nil {
            CATransaction.begin()
            CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        }
        if isZoomEnable{
            let camera = GMSCameraPosition.camera(withLatitude: newCoordinate.latitude, longitude: newCoordinate.longitude, zoom: 17)
            print("mapview tag = ",mapView.tag)
            mapView.tag = 200
            mapView.animate(to: camera)
        }
        self.moveMent?.arCarMovement(marker: DriverLocMarker!, oldCoordinate: oldCoordinate ?? newCoordinate, newCoordinate: newCoordinate, mapView: self.mapView)
        if oldCoordinate != nil {
            CATransaction.commit()
        }
        oldCoordinate = newCoordinate
        self.updateTravelledPath(currentLoc: newCoordinate)
    }
    
    //MARK: - update TravelledPath Methods
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
        var index = 0
        self.coordinates = []
        for i in 0..<self.path.count(){
            let pathLat = Double(self.path.coordinate(at: i).latitude).rounded(toPlaces: 5)
            let pathLong = Double(self.path.coordinate(at: i).longitude).rounded(toPlaces: 5)
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
        if(Meters > 500){
            self.oldPoint = nil
            self.newPoint = nil
            self.oldCoordinate = nil
            self.polyline.map = nil
            self.stopTimer()
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
        self.polyline.strokeColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        self.polyline.strokeWidth = 3.0
        self.polyline.map = self.mapView
    }
    
    func getAllCoordinate(startPoint:CLLocation, endPoint:CLLocation){
        let yourTotalCoordinates = Double(5)
        let latitudeDiff = startPoint.coordinate.latitude - endPoint.coordinate.latitude
        let longitudeDiff = startPoint.coordinate.longitude - endPoint.coordinate.longitude
        let latMultiplier = latitudeDiff / (yourTotalCoordinates + 1)
        let longMultiplier = longitudeDiff / (yourTotalCoordinates + 1)
        for index in 1...Int(yourTotalCoordinates) {
            let lat  = startPoint.coordinate.latitude - (latMultiplier * Double(index))
            let long = startPoint.coordinate.longitude - (longMultiplier * Double(index))
            let point = CLLocation(latitude: lat.rounded(toPlaces: 5), longitude: long.rounded(toPlaces: 5))
            self.coordinates.append(point)
        }
    }
}

//MARK:- ARCarMovementDelegate
extension TrackingVC : ARCarMovementDelegate{
    func arCarMovementMoved(_ marker: GMSMarker) {
        self.DriverLocMarker = nil
        self.DriverLocMarker = marker
        self.DriverLocMarker?.map = self.mapView
    }
}
extension TrackingVC : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mapView.tag != 200{
            isZoomEnable = false
        }
        self.mapView.tag = 100
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if mapView.tag != 200{
            isZoomEnable = false
        }
    }
}
