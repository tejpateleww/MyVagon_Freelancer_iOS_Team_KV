//
//  PiclUpDropOffCell.swift
//  MyVagon
//
//  Created by Admin on 29/07/21.
//

import UIKit


class PickUpDropOffCell: UITableViewCell {
    
    //MARK:- ====== Outlets ========
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!
  //  var PickUpDropOffData : [TotalLoadsInDates]?
    
    var BookingDetails : HomeBidsDatum?
    
    var PickUpDropOffData : [HomeLocation]?
    
    var tblHeight:((CGFloat)->())?
  
    override func awakeFromNib() {
        super.awakeFromNib()

       
       // tblMultipleLocation.backgroundColor = .clear
        
        if tblMultipleLocation.observationInfo != nil {
            self.tblMultipleLocation.removeObserver(self, forKeyPath: "contentSize")
        }
        self.tblMultipleLocation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblMultipleLocation.dataSource = self
        tblMultipleLocation.delegate = self
        tblMultipleLocation.rowHeight = UITableView.automaticDimension
        tblMultipleLocation.estimatedRowHeight = 100
        tblMultipleLocation.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblMultipleLocation.register(UINib(nibName: "BidRequestTblCell", bundle: nil), forCellReuseIdentifier: "BidRequestTblCell")
        
       // tblMultipleLocation.reloadData()
        
          
//        tblMultipleLocation.register(UINib(nibName: "HeaderTblViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTblViewCell")
        
        tblMultipleLocation.register(UINib(nibName: "HeaderOfLocationsTbl", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderOfLocationsTbl")
        ReloadAllData()
        //self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()
    }
    func ReloadAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tblMultipleLocation.layoutIfNeeded()
            self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()//reloadDataWithAutoSizingCellWorkAround()
        })
     
       
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        //viewContainer is the parent of viewContents
        //viewContents contains all the UI which you want to show actually.
        self.viewContents.layoutIfNeeded()
        tblMultipleLocation.layer.cornerRadius = 15
        tblMultipleLocation.clipsToBounds = true
        self.viewContents.layer.cornerRadius = 15
        self.viewContents.layer.masksToBounds = true

        let bezierPath = UIBezierPath.init(roundedRect: self.viewContents.bounds, cornerRadius: 15)
        self.viewContents.layer.shadowPath = bezierPath.cgPath
        self.viewContents.layer.masksToBounds = false
        self.viewContents.layer.shadowColor = UIColor.black.cgColor
        self.viewContents.layer.shadowRadius = 3.0
        self.viewContents.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.viewContents.layer.shadowOpacity = 0.3

        // sending viewContainer color to the viewContents.
       // let backgroundCGColor =
        //You can set your color directly if you want by using below two lines. In my case I'm copying the color.
        self.viewContents.backgroundColor = nil
        self.viewContents.layer.backgroundColor =  UIColor.white.cgColor
        tblMultipleLocation.tableFooterView?.isHidden = true
       // self.tblMultipleLocation.contentInset = UIEdgeInsets(top: -11, left: 0, bottom: 0, right: 0)
      }


//    override func layoutSubviews() {
//        super.layoutSubviews()
//
////        tblMultipleLocation.addShadow()
////        tblMultipleLocation.layer.cornerRadius = 20
////        tblMultipleLocation.clipsToBounds = true
////        tblMultipleLocation.backgroundColor = .clear
////        tblMultipleLocation.layer.shadowColor = UIColor.gray.cgColor
////        tblMultipleLocation.layer.shadowOpacity = 0.5
////        tblMultipleLocation.layer.shadowRadius = 3.0
////        tblMultipleLocation.layer.shadowOffset = CGSize(width: 1, height: 2)
//
//
//        self.tblMultipleLocation.addShadow()
//        self.tblMultipleLocation.addCorner()
//
//
//        tblMultipleLocation.updateHeaderViewHeight()
//
//    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
      
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.conHeightOfTbl.constant = newsize.height
                print("ATDebug :: height \(newsize.height)")
                
                if let getHeight  = tblHeight.self {
                    self.tblMultipleLocation.layoutSubviews()
                    self.tblMultipleLocation.layoutIfNeeded()
                    getHeight(self.tblMultipleLocation.contentSize.height)
                    
                    print("ATDebug :: getHeight \(self.tblMultipleLocation.contentSize.height)")

                }
                
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PickUpDropOffCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return PickUpDropOffData?.count ?? 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
       
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            
            cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
            
            cell.lblAddress.text = PickUpDropOffData?[indexPath.row].dropLocation
            
            cell.BtnShowMore.superview?.isHidden = true
            cell.lblCompanyName.text = PickUpDropOffData?[indexPath.row].companyName
            
            if (PickUpDropOffData?.count ?? 0) == 1 {
                cell.viewLine.isHidden = true
            } else {
                
                cell.viewLine.isHidden = (indexPath.row == ((PickUpDropOffData?.count ?? 0) - 1)) ? true : false
            }
            
            cell.lblDateTime.text = "\(PickUpDropOffData?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy") ?? "") \((PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? ""))"
          
            return cell
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderOfLocationsTbl") as! HeaderOfLocationsTbl
            header.LblShipperName.text = BookingDetails?.shipperDetails?.name ?? ""
                header.lblBidStatus.isHidden = true
                header.viewStatusBid.isHidden = true
            
            header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (BookingDetails?.amount ?? "") : ""
            
            header.lblbookingID.text = "#\(BookingDetails?.id ?? 0)"
            header.viewStatus.backgroundColor = (BookingDetails?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
          //  header.ViewStatusBidText.text = (BookingDetails?.isBid == 0) ? "Book Now" : "Bidding"
            header.lblWeightAndDistance.text = "\(BookingDetails?.totalWeight ?? ""), \(BookingDetails?.distance ?? "") Km"
            header.lblDeadheadWithTruckType.text = (BookingDetails?.trucks?.locations?.first?.deadhead ?? "" == "0") ? BookingDetails?.trucks?.truckType?.name ?? "" : "\(BookingDetails?.trucks?.locations?.first?.deadhead ?? "") : \(BookingDetails?.trucks?.truckType?.name ?? "")"
            
            
            if BookingDetails?.isBid == 0 {
                header.ViewStatusBidText.text =  bidStatus.BookNow.Name
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
               
            } else {
                if BookingDetails?.driverBid == 1 {
                    header.ViewStatusBidText.text = bidStatus.Bidded.Name
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
                } else {
                    header.ViewStatusBidText.text = bidStatus.BidNow.Name
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
                }
                
            }
            
            return header
     
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
//        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

extension UITableView {
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
    func addCorner(){
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
}

extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
