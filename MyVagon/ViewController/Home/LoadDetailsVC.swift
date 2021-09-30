//
//  LoadDetailsVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 27/08/21.
//

import UIKit
import CoreLocation
import GoogleMaps
class LoadDetailsVC: BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var LoadDetails : HomeBidsDatum?
    var arrTypes:[(HomeTruckTypeCategory,Bool)] = []
  
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MapViewForLocation: GMSMapView!

    
    @IBOutlet weak var imgMapDistance: UIImageView!
    @IBOutlet weak var lblBookingID: themeLabel!
    @IBOutlet weak var lblDeadHead: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblTotalMiles: themeLabel!
    @IBOutlet weak var lbljourney: themeLabel!
    @IBOutlet weak var lblBookingStatus: themeLabel!
    
    @IBOutlet weak var lblTruckType: themeLabel!
    
    
    @IBOutlet weak var tblMainData: UITableView!
    @IBOutlet weak var tblMainDataHeight: NSLayoutConstraint!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var viewStatus: UIView!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetValue()
        tblMainData.delegate = self
        tblMainData.dataSource = self
        tblMainData.reloadData()
        setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "Load Details", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        tblMainData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        tblMainData.register(UINib(nibName: "LoadDetailCell", bundle: nil), forCellReuseIdentifier: "LoadDetailCell")
        
        LoadDetails?.trucks?.truckTypeCategory?.forEach({ element in
            arrTypes.append((element,false))
        })
        
        
        viewStatus.backgroundColor = (LoadDetails?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        lblBookingStatus.text = (LoadDetails?.isBid == 0) ? "Book Now" : "Bidding"
        
       
        ColTypes.reloadData()
        let radius = viewStatus.frame.height / 2
        //headerView.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
        MapViewForLocation.isUserInteractionEnabled = false
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func SetValue() {
        lblBookingID.text = "#\(LoadDetails?.id ?? 0)"
        lblPrice.text = Currency + (LoadDetails?.amount ?? "")
        lblTotalMiles.text = "500"
        lbljourney.text = "48h"
        lblBookingStatus.text = LoadDetails?.status
        
        lblTruckType.text = LoadDetails?.trucks?.truckType?.name ?? ""
        
        let sessionManager = SessionManager()
        print()
        
           let start = CLLocationCoordinate2D(latitude: Double(LoadDetails?.trucks?.locations?.first?.dropLat ?? "") ?? 0.0, longitude: Double(LoadDetails?.trucks?.locations?.first?.dropLng ?? "") ?? 0.0)
           let end = CLLocationCoordinate2D(latitude: Double(LoadDetails?.trucks?.locations?.last?.dropLat ?? "") ?? 0.0, longitude: Double(LoadDetails?.trucks?.locations?.last?.dropLng ?? "") ?? 0.0)

           sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in

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
                   let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
                   self.MapViewForLocation.animate(with: cameraUpdate)
                
                let StartMaker = GMSMarker();
                StartMaker.position = CLLocationCoordinate2D(latitude: Double(self.LoadDetails?.trucks?.locations?.first?.dropLat ?? "") ?? 0.0, longitude: Double(self.LoadDetails?.trucks?.locations?.first?.dropLng ?? "") ?? 0.0)
                StartMaker.icon = #imageLiteral(resourceName: "ic_PickUp")
                StartMaker.map = self.MapViewForLocation;

                let DestinationMarker = GMSMarker();
                DestinationMarker.position = CLLocationCoordinate2D(latitude: Double(self.LoadDetails?.trucks?.locations?.last?.dropLat ?? "") ?? 0.0, longitude: Double(self.LoadDetails?.trucks?.locations?.last?.dropLng ?? "") ?? 0.0)
                DestinationMarker.icon = #imageLiteral(resourceName: "ic_ChatProfile")
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
            cell.lblDate.text =  "\(LoadDetails?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd hh:mm:ss", ToFormat: "dd MMMM, yyyy") ?? "") \((LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))"
        } else {
            cell.lblDate.text =  "\(LoadDetails?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd hh:mm:ss", ToFormat: "dd MMMM, yyyy") ?? "") \((LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? ""))-\(LoadDetails?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")"
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
            if arrTypes[indexPath.row].1 {
                print("Here come with index :: \(indexPath.row)")
                cell.BGView.layer.borderWidth = 0
                cell.BGView.backgroundColor = UIColor.appColor(.themeColorForButton).withAlphaComponent(0.5)
                cell.BGView.layer.borderColor = UIColor.appColor(.themeColorForButton).cgColor
               
            } else {
               
                cell.BGView.layer.borderWidth = 1
                cell.BGView.backgroundColor = .clear
                
                cell.BGView.layer.borderColor = UIColor.appColor(.themeLightBG).cgColor
                cell.lblTypes.textColor = UIColor.appColor(.themeButtonBlue)
            }
            
            
            return cell
        }
        return UICollectionViewCell()
    }
   
    
    
   
   
}
