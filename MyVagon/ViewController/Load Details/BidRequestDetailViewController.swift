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

class BidRequestDetailViewController: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    let postTruckBidsViewModel = PostTruckBidsViewModel()

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

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
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
    
    @IBOutlet weak var btnReject: themeButton!
    @IBOutlet weak var btnAccept: themeButton!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        SetValue()
        tblMainData.delegate = self
        tblMainData.dataSource = self
        tblMainData.reloadData()
        setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "Load Details", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        tblMainData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        tblMainData.register(UINib(nibName: "LoadDetailCell", bundle: nil), forCellReuseIdentifier: "LoadDetailCell")
        
        LoadDetails?.bookingInfo?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,true))
        })
        
        ColTypes.reloadData()
        
       
        
        MapViewForLocation.isUserInteractionEnabled = false
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.viewStatus.isHidden = true
//        self.scrollViewHide.isUserInteractionEnabled = false
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func SetValue() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.view.setTemplateWithSubviews(false)
//            self.viewStatus.isHidden = false
//            self.scrollViewHide.isUserInteractionEnabled = true
//        }
        
        
        
        
        let data = LoadDetails?.bookingInfo
        
//        let DateOfPickup = "\(LoadDetails?.bookingInfo?.date ?? "") \(LoadDetails?.bookingInfo?.pickupTimeTo ?? "")"
//
//        let DateFromatChange = DateOfPickup.StringToDate(Format: "yyyy-MM-dd h:m a")
//
//
//        let serverDate = SingletonClass.sharedInstance.SystemDate.StringToDate(Format: "yyyy-MM-dd hh:mm:ss")
//        let daysLeft = DateFromatChange.offset(from: serverDate)
//
//        self.lblDaysToGo.text = daysLeft
       
        
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
        
        lblDeadHead.text = "\(Double(data?.trucks?.locations?.first?.deadhead ?? "") ?? 0.0) Km Deadhead"
       
        lblShipperName.text = data?.shipperDetails?.companyName ?? ""
        
        let strUrl = "\(APIEnvironment.ShipperImageURL)\(data?.shipperDetails?.profile ?? "")"
        imgShipperProfile.isCircle()
        imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
        lblShipperRatting.text = ""
        
     
        
        switch data?.status {
        case MyLoadesStatus.pending.Name:
            lblBookingStatus.text =  MyLoadesStatus.pending.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            lblBookingStatus.text =  MyLoadesStatus.scheduled.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        case MyLoadesStatus.inprocess.Name:
            lblBookingStatus.text =  MyLoadesStatus.inprocess.Name.capitalized
            viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
        case MyLoadesStatus.completed.Name:
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
        btnAccept.isHidden = ((data?.isBid ?? 0) == 1) ? false : true
        let TimeToCancel = (30*60)-(LoadDetails?.time_difference ?? 0)
        btnReject.setTitle(((data?.isBid ?? 0) == 1) ? "Reject" : "\( TimeToCancel / 60) minutes remaining to cancel", for: .normal)
        
       
        
        
//        let sessionManager = SessionManager()
//        print()
//
//           let start = CLLocationCoordinate2D(latitude: Double(LoadDetails?.trucks?.locations?.first?.dropLat ?? "") ?? 0.0, longitude: Double(LoadDetails?.trucks?.locations?.first?.dropLng ?? "") ?? 0.0)
//           let end = CLLocationCoordinate2D(latitude: Double(LoadDetails?.trucks?.locations?.last?.dropLat ?? "") ?? 0.0, longitude: Double(LoadDetails?.trucks?.locations?.last?.dropLng ?? "") ?? 0.0)
//
//           sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in
//
//               if let error = error {
//                   print("Something went wrong, abort drawing!\nError: \(error)")
//               } else {
//                   // Create a GMSPolyline object from the GMSPath
//
//                   let polyline = GMSPolyline(path: path)
//                polyline.strokeColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
//                polyline.strokeWidth = 3
//                   // Add the GMSPolyline object to the mapView
//                   polyline.map = self.MapViewForLocation
//
//                   // Move the camera to the polyline
//                let bounds = GMSCoordinateBounds(path: path ?? GMSPath())
//                   let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
//                   self.MapViewForLocation.animate(with: cameraUpdate)
//
//                let StartMaker = GMSMarker();
//                StartMaker.position = CLLocationCoordinate2D(latitude: Double(self.LoadDetails?.trucks?.locations?.first?.dropLat ?? "") ?? 0.0, longitude: Double(self.LoadDetails?.trucks?.locations?.first?.dropLng ?? "") ?? 0.0)
//                StartMaker.icon = #imageLiteral(resourceName: "ic_PickUp")
//                StartMaker.map = self.MapViewForLocation;
//
//                let DestinationMarker = GMSMarker();
//                DestinationMarker.position = CLLocationCoordinate2D(latitude: Double(self.LoadDetails?.trucks?.locations?.last?.dropLat ?? "") ?? 0.0, longitude: Double(self.LoadDetails?.trucks?.locations?.last?.dropLng ?? "") ?? 0.0)
//                DestinationMarker.icon = #imageLiteral(resourceName: "ic_ChatProfile")
//                DestinationMarker.map = self.MapViewForLocation;
//
//               }
//
//           })
        
        
    
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
        
        let data = LoadDetails?.bookingInfo
        
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC

        controller.noteString = (data?.trucks?.note ?? "")
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280 + appDel.GetSafeAreaHeightFromBottom()))])
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
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    func callAPIForAcceptReject(Accepted:Bool,bookingID:String,loadDetails:MyLoadsNewPostedTruck?,isForBook:Bool) {
        
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: BidAcceptRejectViewController.storyboardID) as! BidAcceptRejectViewController
        controller.bidRequestDetailViewController = self
        controller.LoadDetails = loadDetails
            controller.isAccept = Accepted
        controller.isForBook = isForBook
        controller.isFromDetails = true
        let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(22)] as [NSAttributedString.Key : Any]
        
        if isForBook {
           
            let AttributedStringFinal = "Are you sure you want to ".Medium(color: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), FontSize: 16)
          
                AttributedStringFinal.append("decline".Medium(color: #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), FontSize: 16))
           
            AttributedStringFinal.append(" the book request?".Medium(color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), FontSize: 16))
            
            controller.TitleAttributedText = AttributedStringFinal
            
            controller.TitleAttributedText = NSAttributedString(string: "Book Request", attributes: TitleAttribute)
            controller.DescriptionAttributedText = AttributedStringFinal
            
            
            
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
//    func callAPIForAcceptReject(Accepted:Bool,bookingID:String) {
//        self.postTruckBidsViewModel.bidRequestDetailViewController =  self
//
//        let reqModel = BidAcceptRejectReqModel()
//        reqModel.booking_request_id = bookingID
//        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
//        reqModel.status = (Accepted == true) ? "accept" : "reject"
//        self.postTruckBidsViewModel.AcceptReject(ReqModel: reqModel,isFromDetail: true)
//    }
   
    
}
// ----------------------------------------------------
// MARK: - --------- Tableview Methods ---------
// ----------------------------------------------------
extension BidRequestDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadDetails?.bookingInfo?.trucks?.locations?.count ?? 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainData.dequeueReusableCell(withIdentifier: "LoadDetailCell") as! LoadDetailCell
        cell.ViewForSavingTree.isHidden = true
        
        let data = LoadDetails?.bookingInfo
        
        
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
extension BidRequestDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
//    func createPath(sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D) {
//          let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
//          let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
//
//
//          let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
//          let destinationItem = MKMapItem(placemark: destinationPlaceMark)
//
//
//          let sourceAnotation = MKPointAnnotation()
//          sourceAnotation.title = "Delhi"
//          sourceAnotation.subtitle = "The Capital of INIDA"
//          if let location = sourcePlaceMark.location {
//              sourceAnotation.coordinate = location.coordinate
//          }
//
//          let destinationAnotation = MKPointAnnotation()
//          destinationAnotation.title = "Gurugram"
//          destinationAnotation.subtitle = "The HUB of IT Industries"
//          if let location = destinationPlaceMark.location {
//              destinationAnotation.coordinate = location.coordinate
//          }
//
//          self.MapViewWithTwoLocation.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
//
//          let directionRequest = MKDirections.Request()
//          directionRequest.source = sourceMapItem
//          directionRequest.destination = destinationItem
//          directionRequest.transportType = .automobile
//
//          let direction = MKDirections(request: directionRequest)
//
//
//          direction.calculate { (response, error) in
//              guard let response = response else {
//                  if let error = error {
//                      print("ERROR FOUND : \(error.localizedDescription)")
//                  }
//                  return
//              }
//
//              let route = response.routes[0]
//              self.MapViewWithTwoLocation.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
//
//              let rect = route.polyline.boundingMapRect
//
//              self.MapViewWithTwoLocation.setRegion(MKCoordinateRegion(rect), animated: true)
//
//          }
//      }
}
extension BidRequestDetailViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}
