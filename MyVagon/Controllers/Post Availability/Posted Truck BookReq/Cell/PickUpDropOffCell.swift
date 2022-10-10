//
//  PiclUpDropOffCell.swift
//  MyVagon
//
//  Created by Admin on 29/07/21.
//

import UIKit

class PickUpDropOffCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!
    
    var isLoading : Bool = false
    var BookingDetails : SearchLoadsDatum?
    var PickUpDropOffData : [SearchLocation]?
    var tblHeight:((CGFloat)->())?
    
    //MARK: - Life cycle method
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
        tblMultipleLocation.register(UINib(nibName: SearchLocationCell.className, bundle: nil), forCellReuseIdentifier: SearchLocationCell.className)
        tblMultipleLocation.register(UINib(nibName: "ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        tblMultipleLocation.register(UINib(nibName: "HeaderOfLocationsTbl", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderOfLocationsTbl")
        ReloadAllData()
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.conHeightOfTbl.constant = newsize.height - 40
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
    }
    
    //MARK: - Custom method
    func ReloadAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tblMultipleLocation.layoutIfNeeded()
            self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()//reloadDataWithAutoSizingCellWorkAround()
        })
    }
}

//MARK: - Tableview datasource and delegate
extension PickUpDropOffCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  isLoading {
            return 2
        }
        return PickUpDropOffData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
        let cell =  tableView.dequeueReusableCell(withIdentifier: SearchLocationCell.className, for: indexPath) as! SearchLocationCell
        if !isLoading {
            if(indexPath.row == 0){
                cell.imgLocation.image = UIImage(named: "ic_PickUp")
            }else if(indexPath.row == (PickUpDropOffData?.count ?? 0) - 1){
                cell.imgLocation.image = UIImage(named: "ic_DropOff")
            }else{
                cell.imgLocation.image = UIImage(named: "ic_pickDrop")
            }
            cell.lblAddress.text = PickUpDropOffData?[indexPath.row].dropLocation
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderOfLocationsTbl") as! HeaderOfLocationsTbl
        if !isLoading {
            header.LblShipperName.text = BookingDetails?.shipperDetails?.companyName ?? ""
            header.lblBidStatus.isHidden = true
            header.viewStatusBid.isHidden = true
            header.lblPrice.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (BookingDetails?.amount ?? "") : ""
            header.lblbookingID.text = "#\(BookingDetails?.id ?? 0)"
            header.lblWeightAndDistance.text = "\(BookingDetails?.totalWeight ?? ""), \(BookingDetails?.distance ?? "") Km"
            header.lblDeadheadWithTruckType.text = (BookingDetails?.trucks?.locations?.first?.deadhead ?? "" == "0") ? BookingDetails?.trucks?.truckType?.name ?? "" : "\(BookingDetails?.trucks?.locations?.first?.deadhead ?? "") : \(BookingDetails?.trucks?.truckType?.name ?? "")"
            let radius = header.viewStatus.frame.height / 2
            header.viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
            if (BookingDetails?.isBid ?? 0) == 1 {
                header.ViewStatusBidText.text = bidStatus.BidNow.Name.localized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            } else {
                header.ViewStatusBidText.text =  bidStatus.BookNow.Name.localized
                header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 150
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

