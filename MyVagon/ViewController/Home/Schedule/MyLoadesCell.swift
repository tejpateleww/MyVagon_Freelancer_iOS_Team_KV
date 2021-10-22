//
//  PiclUpDropOffCell.swift
//  MyVagon
//
//  Created by Admin on 29/07/21.
//

import UIKit


class MyLoadesCell: UITableViewCell {
    
    //MARK:- ====== Outlets ========
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!
  //  var PickUpDropOffData : [TotalLoadsInDates]?
    
    var myloadDetails : MyLoadsLoadsDatum?
    
    var PickUpDropOffData : [MyLoadsLocation]?
    
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
        //tblMultipleLocation.register(UINib(nibName: "BidRequestTblCell", bundle: nil), forCellReuseIdentifier: "BidRequestTblCell")
        
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
        //self.tblMultipleLocation.contentInset = UIEdgeInsets(top: -11, left: 0, bottom: 0, right: 0)
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
                
               
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil, userInfo: TblDataDict)
                
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
        header.LblShipperName.text = myloadDetails?.shipperDetails?.name ?? ""
            header.lblBidStatus.isHidden = false
            header.viewStatusBid.isHidden = false
        
        header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (myloadDetails?.amount ?? "") : ""
        
        header.lblbookingID.text = "#\(myloadDetails?.id ?? 0)"
        header.viewStatus.backgroundColor = (myloadDetails?.isBid == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        header.lblWeightAndDistance.text = "\(myloadDetails?.totalWeight ?? ""), \(myloadDetails?.distance ?? "") Km"
        header.lblDeadheadWithTruckType.text = (myloadDetails?.trucks?.locations?.first?.deadhead ?? "" == "0") ? myloadDetails?.trucks?.truckType?.name ?? "" : "\(myloadDetails?.trucks?.locations?.first?.deadhead ?? "") : \(myloadDetails?.trucks?.truckType?.name ?? "")"
        
        
        switch myloadDetails?.status {
        case MyLoadesStatus.pending.Name:
            header.ViewStatusBidText.text =  MyLoadesStatus.pending.Name
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            header.ViewStatusBidText.text =  MyLoadesStatus.scheduled.Name
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        case MyLoadesStatus.inprocess.Name:
            header.ViewStatusBidText.text =  MyLoadesStatus.inprocess.Name
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3882352941, blue: 0.8078431373, alpha: 1)
        case MyLoadesStatus.completed.Name:
            header.ViewStatusBidText.text =  MyLoadesStatus.completed.Name
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
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130 
//        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    

}


