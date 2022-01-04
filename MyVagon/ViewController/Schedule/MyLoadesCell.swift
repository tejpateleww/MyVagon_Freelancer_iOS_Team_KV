//
//  PiclUpDropOffCell.swift
//  MyVagon
//
//  Created by Admin on 29/07/21.
//

import UIKit


class MyLoadesCell: UITableViewCell {
    
    //MARK: - ====== Outlets ========
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!

    //MARK: - ====== Variables ========
    var isShowFooter : Bool = false
    var isLoading : Bool = false
    var myloadDetails : MyLoadsNewDatum?
    
    var btnViewMatchFoundClick:((IndexPath)->())?
    var tblHeight:((CGFloat)->())?
  
    //MARK: - ====== Default Methods ========
    override func awakeFromNib() {
        super.awakeFromNib()

        if tblMultipleLocation.observationInfo != nil {
            self.tblMultipleLocation.removeObserver(self, forKeyPath: "contentSize")
        }
        self.tblMultipleLocation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblMultipleLocation.dataSource = self
        tblMultipleLocation.delegate = self
        tblMultipleLocation.rowHeight = UITableView.automaticDimension
        tblMultipleLocation.estimatedRowHeight = 100
        tblMultipleLocation.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
         
        tblMultipleLocation.register(UINib(nibName: "HeaderOfLocationsTbl", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderOfLocationsTbl")
        ReloadAllData()
        
    }
    func ReloadAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tblMultipleLocation.layoutIfNeeded()
            self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()//reloadDataWithAutoSizingCellWorkAround()
        })
     
       
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
       
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

        
        self.viewContents.backgroundColor = nil
        self.viewContents.layer.backgroundColor =  UIColor.white.cgColor
        tblMultipleLocation.tableFooterView?.isHidden = true

      }

    //MARK: - ====== Observer methods ========
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
      
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.conHeightOfTbl.constant = newsize.height
               
                
                if let getHeight  = tblHeight.self {
                    self.tblMultipleLocation.layoutSubviews()
                    self.tblMultipleLocation.layoutIfNeeded()
                    getHeight(self.tblMultipleLocation.contentSize.height)
                    
                  

                }
              
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MyLoadesCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 2
        }
        switch myloadDetails?.type {
        case MyLoadType.Bid.Name:
            return myloadDetails?.bid?.trucks?.locations?.count ?? 0
            
        case MyLoadType.Book.Name:
            return myloadDetails?.book?.trucks?.locations?.count ?? 0
            
        case MyLoadType.PostedTruck.Name:
            if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0 {
                return myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0
            }
            return 2
            
        default:
            break
        }
       
       return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if !isLoading {
        
        switch myloadDetails?.type {
        case MyLoadType.Bid.Name:
            let PickUpDropOffData = myloadDetails?.bid?.trucks?.locations
            cell.lblAddress.isHidden = false
            
            if PickUpDropOffData?[indexPath.row].isPickup == 0 && (indexPath.row != 0 || indexPath.row != PickUpDropOffData?.count) {
                cell.imgLocation.image = UIImage(named: "ic_pickDrop")
            } else {
                cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
            }
            
          
            cell.lblAddress.text = PickUpDropOffData?[indexPath.row].dropLocation
            
            cell.BtnShowMore.superview?.isHidden = true
            cell.lblCompanyName.text = PickUpDropOffData?[indexPath.row].companyName
            
            if (PickUpDropOffData?.count ?? 0) == 1 {
                cell.viewLine.isHidden = true
            } else {
                
                cell.viewLine.isHidden = (indexPath.row == ((PickUpDropOffData?.count ?? 0) - 1)) ? true : false
            }
            
            
            var StringForDateTime = ""
            StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
            StringForDateTime.append(" ")
            
            if (PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "") == (PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? "") {
                StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "")")
            } else {
                StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? "")-\(PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "")")
            }
            cell.lblDateTime.text = StringForDateTime
            
            
            break
        case MyLoadType.Book.Name:
            let PickUpDropOffData = myloadDetails?.book?.trucks?.locations
            cell.lblAddress.isHidden = false
            
            if PickUpDropOffData?[indexPath.row].isPickup == 0 && (indexPath.row != 0 || indexPath.row != PickUpDropOffData?.count) {
                cell.imgLocation.image = UIImage(named: "ic_pickDrop")
            } else {
                cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
            }
            
            
          
            
            cell.lblAddress.text = PickUpDropOffData?[indexPath.row].dropLocation
            
            cell.BtnShowMore.superview?.isHidden = true
            cell.lblCompanyName.text = PickUpDropOffData?[indexPath.row].companyName
            
            if (PickUpDropOffData?.count ?? 0) == 1 {
                cell.viewLine.isHidden = true
            } else {
                
                cell.viewLine.isHidden = (indexPath.row == ((PickUpDropOffData?.count ?? 0) - 1)) ? true : false
            }
            
            
            var StringForDateTime = ""
            StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
            StringForDateTime.append(" ")
            
            if (PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "") == (PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? "") {
                StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "")")
            } else {
                StringForDateTime.append("\(PickUpDropOffData?[indexPath.row].deliveryTimeFrom ?? "")-\(PickUpDropOffData?[indexPath.row].deliveryTimeTo ?? "")")
            }
            cell.lblDateTime.text = StringForDateTime
            
            
            
           
            break
        case MyLoadType.PostedTruck.Name:
            if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0 {
                 cell.lblAddress.isHidden = false
                
                let PickUpDropOffData = myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations
                if PickUpDropOffData?[indexPath.row].isPickup == 0 && (indexPath.row != 0 || indexPath.row != PickUpDropOffData?.count) {
                    cell.imgLocation.image = UIImage(named: "ic_pickDrop")
                } else {
                    cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
                }
                
           
                
                cell.lblAddress.text = myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].dropLocation
                
                cell.BtnShowMore.superview?.isHidden = true
                cell.lblCompanyName.text = myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].companyName
                
                if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) == 1 {
                    cell.viewLine.isHidden = true
                } else {
                    
                    cell.viewLine.isHidden = (indexPath.row == ((myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) - 1)) ? true : false
                }
                var StringForDateTime = ""
                StringForDateTime.append("\(myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
                StringForDateTime.append(" ")
                
                if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "") == (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "") {
                    StringForDateTime.append("\(myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")")
                } else {
                    StringForDateTime.append("\(myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].deliveryTimeTo ?? "")-\(myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?[indexPath.row].deliveryTimeFrom ?? "")")
                }
                cell.lblDateTime.text = StringForDateTime
                
             
                
                
                break
            } else {
                if indexPath.row == 0 {
                    cell.lblDateTime.text = "\(myloadDetails?.postedTruck?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")"
                    
                    cell.lblDateTime.isHidden = false
                    cell.lblCompanyName.text = myloadDetails?.postedTruck?.fromAddress ?? ""
                    cell.imgLocation.image = UIImage(named: "ic_PickUp")
                    cell.viewLine.isHidden = false
                } else {
                    cell.lblDateTime.text = ""
                    cell.lblDateTime.isHidden = true
                    cell.lblCompanyName.text = myloadDetails?.postedTruck?.toAddress ?? ""
                    cell.imgLocation.image = UIImage(named: "ic_DropOff")
                    cell.viewLine.isHidden = true
                }
                cell.BtnShowMore.superview?.isHidden = true
                cell.lblAddress.isHidden = true
            }
            
           
            
            
            break
        default:
            break
        }
        
        
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
  
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !isLoading {
        switch myloadDetails?.type {
        case MyLoadType.Bid.Name:
            break
        case MyLoadType.Book.Name:
            break
        case MyLoadType.PostedTruck.Name:
            if !isLoading {
                if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0 {
                  
                    break
                } else {
                    let headerView = UIView.init(frame: CGRect.init(x: 0, y: 12, width: tableView.frame.width, height: 66))
                    let btnViewMatchFound = UIButton()
                    btnViewMatchFound.frame = CGRect(x: 20, y: 12, width: headerView.frame.size.width - 20, height: headerView.frame.size.height - 24)
                    btnViewMatchFound.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(FontSize.size16.rawValue)
                    btnViewMatchFound.layer.borderWidth = 1
                    btnViewMatchFound.layer.cornerRadius = 0
                    btnViewMatchFound.clipsToBounds = true
                    
                    btnViewMatchFound.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
                    
             //       if (myloadDetails?.postedTruck?.isBid ?? 0) == 1 {
                   
                        if (myloadDetails?.postedTruck?.bookingRequestCount ?? 0) != 0 {
                            let totalCount = (myloadDetails?.postedTruck?.bookingRequestCount ?? 0)
                            if (myloadDetails?.postedTruck?.isBid ?? 0) == 1 {
                                btnViewMatchFound.setTitleColor(#colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), for: .normal)
                               
                                btnViewMatchFound.layer.borderColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1).cgColor
                                btnViewMatchFound.backgroundColor = .clear
                                btnViewMatchFound.setTitle("View \(totalCount) Bid Request", for: .normal)
                            } else {
                                let TimeToCancel = (30*60)-(myloadDetails?.postedTruck?.time_difference ?? 0)

                               
                                
                                btnViewMatchFound.setTitleColor(#colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), for: .normal)
                               
                                btnViewMatchFound.layer.borderColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1).cgColor
                                btnViewMatchFound.backgroundColor = .clear
                                btnViewMatchFound.setTitle("\(TimeToCancel / 60) minutes remaining to cancel", for: .normal)
                            }
                        }  else {
                            if (myloadDetails?.postedTruck?.matchesCount ?? 0) != 0 {
                                let totalCount = (myloadDetails?.postedTruck?.matchesCount ?? 0)

                                if (myloadDetails?.postedTruck?.isBid ?? 0) == 1 {
                                    btnViewMatchFound.setTitleColor(#colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), for: .normal)
                                   
                                    btnViewMatchFound.layer.borderColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1).cgColor
                                    btnViewMatchFound.backgroundColor = .clear
                                    btnViewMatchFound.setTitle("\(totalCount) Matches Load Found", for: .normal)
                                } else {
                                    let TimeToCancel = (30*60)-(myloadDetails?.postedTruck?.time_difference ?? 0)
                                    btnViewMatchFound.setTitleColor(#colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), for: .normal)
                                   
                                    btnViewMatchFound.layer.borderColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1).cgColor
                                    btnViewMatchFound.backgroundColor = .clear
                                    btnViewMatchFound.setTitle("\(TimeToCancel / 60) minutes remaining to cancel", for: .normal)
                                }
                            } else {
                                btnViewMatchFound.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1)
                                btnViewMatchFound.setTitleColor(hexStringToUIColor(hex: "#FFFFFF"), for: .normal)
                               
                                btnViewMatchFound.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1).cgColor
                                btnViewMatchFound.setTitle("No Matches Found", for: .normal)
                            }

                         
                        }

//                    } else {
////                        btnViewMatchFound.setTitleColor(hexStringToUIColor(hex: "#D56969"), for: .normal)
////
////                        btnViewMatchFound.layer.borderColor = hexStringToUIColor(hex: "#D56969").cgColor
////                        btnViewMatchFound.backgroundColor = .clear
////                        btnViewMatchFound.setTitle("25 minutes remaining to cancel", for: .normal)
//                    }
//
                    btnViewMatchFound.layoutIfNeeded()
                    btnViewMatchFound.layoutSubviews()
                    headerView.addSubview(btnViewMatchFound)
                    
                    return headerView
                }
                
            } else {
                return UIView()
            }
           
            
        default:
            break
        }
        
        }
     
        return UIView()
    }
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderOfLocationsTbl") as! HeaderOfLocationsTbl
        if isLoading {
         return header
        }
        
        switch myloadDetails?.type {
        case MyLoadType.Bid.Name:
            header.lblStatus.isHidden = false
            header.viewStatus.isHidden = false
            header.lblWeightAndDistance.isHidden = false
            
            header.lblDeadheadWithTruckType.isHidden = false
            header.LblShipperName.text = myloadDetails?.bid?.shipperDetails?.name ?? ""
            header.lblBidStatus.isHidden = false
            header.viewStatusBid.isHidden = false
            
            header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (myloadDetails?.bid?.amount ?? "") : ""
            
            header.lblbookingID.text = "#\(myloadDetails?.bid?.id ?? 0)"
            header.viewStatus.backgroundColor = (myloadDetails?.bid?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            header.lblWeightAndDistance.text = "\(myloadDetails?.bid?.totalWeight ?? ""), \(myloadDetails?.bid?.distance ?? "") Km"
            header.lblDeadheadWithTruckType.text = (myloadDetails?.bid?.trucks?.locations?.first?.deadhead ?? "" == "0") ? myloadDetails?.bid?.trucks?.truckType?.name ?? "" : "\(myloadDetails?.bid?.trucks?.locations?.first?.deadhead ?? "") : \(myloadDetails?.bid?.trucks?.truckType?.name ?? "")"
            header.lblStatus.text = "Bid"
            
            switch myloadDetails?.bid?.status {
            case MyLoadesStatus.pending.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.pending.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
            case MyLoadesStatus.scheduled.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.scheduled.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
            case MyLoadesStatus.inprocess.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.inprocess.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
            case MyLoadesStatus.completed.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.completed.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            case MyLoadesStatus.canceled.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.canceled.Name
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
                
            case .none:
                break
            case .some(_):
                break
            }
            return header
            
        case MyLoadType.Book.Name:
            header.lblStatus.isHidden = false
            header.viewStatus.isHidden = false
            header.lblWeightAndDistance.isHidden = false
            
            header.lblDeadheadWithTruckType.isHidden = false
            header.lblStatus.text = "Book"
            header.LblShipperName.text = myloadDetails?.book?.shipperDetails?.name ?? ""
            header.lblBidStatus.isHidden = false
            header.viewStatusBid.isHidden = false
            
            header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (myloadDetails?.book?.amount ?? "") : ""
            
            header.lblbookingID.text = "#\(myloadDetails?.book?.id ?? 0)"
            header.viewStatus.backgroundColor = (myloadDetails?.book?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            header.lblWeightAndDistance.text = "\(myloadDetails?.book?.totalWeight ?? ""), \(myloadDetails?.book?.distance ?? "") Km"
            header.lblDeadheadWithTruckType.text = (myloadDetails?.book?.trucks?.locations?.first?.deadhead ?? "" == "0") ? myloadDetails?.book?.trucks?.truckType?.name ?? "" : "\(myloadDetails?.book?.trucks?.locations?.first?.deadhead ?? "") : \(myloadDetails?.book?.trucks?.truckType?.name ?? "")"
            
            switch myloadDetails?.book?.status {
            case MyLoadesStatus.pending.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.pending.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
            case MyLoadesStatus.scheduled.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.scheduled.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
            case MyLoadesStatus.inprocess.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.inprocess.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
            case MyLoadesStatus.completed.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.completed.Name.capitalized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            case MyLoadesStatus.canceled.Name:
                header.ViewStatusBidText.text =  MyLoadesStatus.canceled.Name
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
                
            case .none:
                break
            case .some(_):
                break
            }
            
            return header
            
        case MyLoadType.PostedTruck.Name:
            
            if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0 {
                
              
                header.lblStatus.isHidden = false
                header.viewStatus.isHidden = false
                header.lblWeightAndDistance.isHidden = false
                
                header.lblDeadheadWithTruckType.isHidden = false
                header.lblStatus.text = "Posted Truck"
                header.LblShipperName.text = myloadDetails?.postedTruck?.bookingInfo?.shipperDetails?.name ?? ""
                header.lblBidStatus.isHidden = false
                header.viewStatusBid.isHidden = false
                
                header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (myloadDetails?.postedTruck?.bookingInfo?.amount ?? "") : ""
                
                header.lblbookingID.text = "#\(myloadDetails?.postedTruck?.bookingInfo?.id ?? 0)"
              
                header.lblWeightAndDistance.text = "\(myloadDetails?.postedTruck?.bookingInfo?.totalWeight ?? ""), \(myloadDetails?.postedTruck?.bookingInfo?.distance ?? "") Km"
                header.lblDeadheadWithTruckType.text = (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.first?.deadhead ?? "" == "0") ? myloadDetails?.postedTruck?.bookingInfo?.trucks?.truckType?.name ?? "" : "\(myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.first?.deadhead ?? "") : \(myloadDetails?.postedTruck?.bookingInfo?.trucks?.truckType?.name ?? "")"

                switch myloadDetails?.postedTruck?.bookingInfo?.status {
                case MyLoadesStatus.pending.Name:
                    header.ViewStatusBidText.text =  MyLoadesStatus.pending.Name.capitalized
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
                case MyLoadesStatus.scheduled.Name:
                    header.ViewStatusBidText.text =  MyLoadesStatus.scheduled.Name.capitalized
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
                case MyLoadesStatus.inprocess.Name:
                    header.ViewStatusBidText.text =  MyLoadesStatus.inprocess.Name.capitalized
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
                case MyLoadesStatus.completed.Name:
                    header.ViewStatusBidText.text =  MyLoadesStatus.completed.Name.capitalized
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
                case MyLoadesStatus.canceled.Name:
                    header.ViewStatusBidText.text =  MyLoadesStatus.canceled.Name.capitalized
                    header.viewStatus.backgroundColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
                    
                case .none:
                    break
                case .some(_):
                    break
                }
                
                return header
            } else {
             
                header.LblShipperName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
                header.lblBidStatus.isHidden = true
                header.viewStatusBid.isHidden = true

                header.lblStatus.isHidden = false
                header.viewStatus.isHidden = true
                header.lblStatus.text = "Posted Truck"
                header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (myloadDetails?.postedTruck?.bidAmount ?? "") : ""

                header.lblbookingID.text = "#\(myloadDetails?.postedTruck?.id ?? 0)"

                header.lblWeightAndDistance.isHidden = true

                header.lblDeadheadWithTruckType.isHidden = true
                return header
                
            }
            
      
        default:
            break
        }
        
       return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 130
        }
        switch myloadDetails?.type {
        
        case MyLoadType.Bid.Name:
            return 130
            
        case MyLoadType.Book.Name:
            return 130
            
        case MyLoadType.PostedTruck.Name:
            
            if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0 {
                return 130
            } else {
                return 80
            }
          
            
        default:
            break
        }
        return 0
        
//        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch myloadDetails?.type {
        case MyLoadType.Bid.Name:
            return 0
            
        case MyLoadType.Book.Name:
            return 0
            
        case MyLoadType.PostedTruck.Name:
            if !isLoading {
                if (myloadDetails?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0 {
                  return 0
                    
                }
                return 66
            }
            return 0
            
            
        default:
            break
        }
        return 0
       
    }
    

}
extension MyLoadesCell {
  
  
}

enum MyLoadType  {
    case Bid,Book,PostedTruck
    var Name : String {
        switch self {
        case .Bid:
            return "bid"
        case .Book:
            return  "book"
        case .PostedTruck:
            return "posted_truck"
       
        }
       
    }
}
