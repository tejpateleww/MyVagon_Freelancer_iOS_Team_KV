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
extension UILabel: ShimmeringViewProtocol { }
extension UISwitch: ShimmeringViewProtocol { }
extension UIProgressView: ShimmeringViewProtocol { }
extension UITextView: ShimmeringViewProtocol { }
extension UIStepper: ShimmeringViewProtocol { }
extension UISlider: ShimmeringViewProtocol { }
extension UIImageView: ShimmeringViewProtocol { }
extension UIButton : ShimmeringViewProtocol { }

class LoadDetailsVC: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
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
    
    @IBOutlet weak var btnBidNow: themeButton!
    @IBOutlet weak var lblShipperName: themeLabel!
    @IBOutlet weak var lblShipperRatting: themeLabel!
    @IBOutlet weak var imgShipperProfile: UIImageView!
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
        
        LoadDetails?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,true))
        })
        ColTypes.reloadData()
        
       
        
        MapViewForLocation.isUserInteractionEnabled = false
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
        self.viewStatus.isHidden = true
        self.scrollViewHide.isUserInteractionEnabled = false
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func SetValue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.setTemplateWithSubviews(false)
            self.viewStatus.isHidden = false
            self.scrollViewHide.isUserInteractionEnabled = true
        }
        
        viewStatus.backgroundColor = (LoadDetails?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
      
        btnViewNotes.isHidden = ((LoadDetails?.trucks?.note ?? "") == "") ? true : false
        let radius = viewStatus.frame.height / 2
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
        lblBookingID.text = "#\(LoadDetails?.id ?? 0)"
        
        lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (LoadDetails?.amount ?? "") : ""
        
        lblBookingStatus.text = LoadDetails?.status
        
        lblTruckType.text = LoadDetails?.trucks?.truckType?.name ?? ""
       
        lbljourney.text = "\(LoadDetails?.journey ?? "")"
        lblJourneyType.text = "\(LoadDetails?.journeyType ?? "")"
        
        lblTotalMiles.text = "\(LoadDetails?.distance ?? "")"
            lblDeadHead.text = (LoadDetails?.trucks?.locations?.first?.deadhead ?? "" == "0") ? LoadDetails?.trucks?.truckType?.name ?? "" : "\(LoadDetails?.trucks?.locations?.first?.deadhead ?? "") : \(LoadDetails?.trucks?.truckType?.name ?? "")"
        
        lblShipperName.text = LoadDetails?.shipperDetails?.name ?? ""
        
        let strUrl = "\(APIEnvironment.ShipperImageURL.rawValue)\(LoadDetails?.shipperDetails?.profile ?? "")"
        imgShipperProfile.isCircle()
        imgShipperProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgShipperProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "ic_userIcon"))
        lblShipperRatting.text = ""
        
        
        
        if (LoadDetails?.isBid ?? 0) == 1 {
            btnBidNow.setTitle(  bidStatus.BidNow.Name , for: .normal)
            lblBookingStatus.text = bidStatus.BidNow.Name
            
            if SingletonClass.sharedInstance.UserProfileData?.permissions?.allowBid ?? 0 == 1 {
                self.btnBidNow.superview?.isHidden = false
            } else {
                self.btnBidNow.superview?.isHidden = true
            }
            viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        } else {
            btnBidNow.setTitle(  bidStatus.BookNow.Name , for: .normal)
            
            lblBookingStatus.text = bidStatus.BookNow.Name
            viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        }
        
       
        
        
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
    @IBAction func btnBidNowClick(_ sender: themeButton) {
        switch sender.titleLabel?.text {
        case bidStatus.BookNow.Name:
            
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: CommonAcceptRejectPopupVC.storyboardID) as! CommonAcceptRejectPopupVC
            controller.loadDetailsVc = self
            controller.loadDetailsModel = loadDetailViewModel
            controller.bookingID = "\(LoadDetails?.id ?? 0)"
            controller.availabilityId = "\(LoadDetails?.availabilityId ?? 0)"
            let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(22)] as [NSAttributedString.Key : Any]
            
            let DescriptionAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
            
            
            
            controller.TitleAttributedText = NSAttributedString(string: "Booking Confirmation", attributes: TitleAttribute)
            controller.DescriptionAttributedText = NSAttributedString(string: "Do you want to confirm the booking?", attributes: DescriptionAttribute)
            controller.IsHideImage = true
            controller.LeftbtnTitle = "Cancel"
            controller.RightBtnTitle = "Book"
          
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
            self.present(controller, animated: false, completion:  {

                
                controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

            })
            
            break
        case bidStatus.BidNow.Name:
            
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: BidNowPopupViewController.storyboardID) as! BidNowPopupViewController
            controller.MinimumBidAmount = LoadDetails?.amount ?? ""
            controller.BookingId = "\(LoadDetails?.id ?? 0)"
            controller.AvailabilityId = "\(LoadDetails?.availabilityId ?? 0)"
          
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .coverVertical
           
            self.present(controller, animated: false, completion:  {

                
                controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

            })
            
        case bidStatus.Bidded.Name:
            break
       
        case .none:
            break
        case .some(_):
            break
        }
       
       
        
    }
    @IBAction func btnNotesClick(_ sender: themeButton) {
        if (LoadDetails?.trucks?.note ?? "") != "" {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
           
            controller.noteString = LoadDetails?.trucks?.note ?? ""
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .coverVertical
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280))])
            self.present(sheetController, animated: true, completion:  {
            })
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: "No Notes Available")
        }
        
       
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
   
   
    
}
// ----------------------------------------------------
// MARK: - --------- Tableview Methods ---------
// ----------------------------------------------------
extension LoadDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadDetails?.trucks?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainData.dequeueReusableCell(withIdentifier: "LoadDetailCell") as! LoadDetailCell
        cell.ViewForSavingTree.isHidden = true
        
        
        cell.PickUpDropOffImageView.image =  (LoadDetails?.trucks?.locations?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
        cell.lblName.text = LoadDetails?.trucks?.locations?[indexPath.row].companyName ?? ""
        cell.lblAddress.text = LoadDetails?.trucks?.locations?[indexPath.row].dropLocation ?? ""
        cell.lblDate.text = LoadDetails?.trucks?.locations?[indexPath.row].companyName ?? ""
        
        if (LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "") == (LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "") {
            cell.lblDate.text =  "\(LoadDetails?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
        } else {
            cell.lblDate.text =  "\(LoadDetails?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
        }
        
        cell.lblPickupDropOff.text = (LoadDetails?.trucks?.locations?[indexPath.row].isPickup == 0) ? "Drop" : "Pick"
        
        cell.lblPickupDropOff.superview?.backgroundColor = (LoadDetails?.trucks?.locations?[indexPath.row].isPickup == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        
        cell.LoadDetails = LoadDetails?.trucks?.locations?[indexPath.row].products
        
        
//        if indexPath.row == 1 {
//            cell.TblLoadDetails.isHidden = true
//            cell.ViewForSavingTree.isHidden = false
//            cell.ViewForHeader.isHidden = true
//
//        } else {
//            cell.TblLoadDetails.isHidden = false
//
//            cell.ViewForSavingTree.isHidden = true
//            cell.ViewForHeader.isHidden = false
//        }
       
        
       
        
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
        cell.TblLoadDetails.reloadData()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
  
}
// ----------------------------------------------------
// MARK: - --------- Collectionview Methods ---------
// ----------------------------------------------------
extension LoadDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.isLoading = false
        }
    }
}
//MARK: - Draw Root Line
extension LoadDetailsVC {
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
extension LoadDetailsVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}
enum bidStatus {
    case BookNow
    case BidNow
    case Bidded
    
    var Name:String {
        switch self {
        case .BookNow:
            return "Book Now"
        case .BidNow:
            return "Bid Now"
        case .Bidded:
            return "Bidded"
        }
    }
}

