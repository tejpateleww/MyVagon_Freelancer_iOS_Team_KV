//
//  PostedTruckBidReqCell.swift
//  MyVagon
//
//  Created by Tej P on 09/06/22.
//

import UIKit
import Cosmos
import SDWebImage
class PostedTruckBidReqCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblOfferPrice: themeLabel!
    @IBOutlet weak var lblRatting: themeLabel!
    @IBOutlet weak var lblWeightAndMiles: themeLabel!
    @IBOutlet weak var lblTruckType: themeLabel!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var viewCosoms: CosmosView!
    @IBOutlet weak var btnAccept: themeButton!
    @IBOutlet weak var btnReject: themeButton!
    @IBOutlet weak var tblMultipleLocation: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var viewContents: UIView!
    @IBOutlet weak var lblOffer: themeLabel!
    var acceptRejectClosour:((Bool)->())?
    var PickUpDropOffData : [MyLoadsNewLocation]?
    var tblHeight:((CGFloat)->())?

    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
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
                self.conHeightOfTbl.constant = newsize.height
                if let getHeight  = tblHeight.self {
                    self.tblMultipleLocation.layoutSubviews()
                    self.tblMultipleLocation.layoutIfNeeded()
                    getHeight(self.tblMultipleLocation.contentSize.height)
                }
            }
        }
    }
    
    //MARK: - Custom method
    func setUpUI(){
        self.tblMultipleLocation.isUserInteractionEnabled = false
        if tblMultipleLocation.observationInfo != nil {
            self.tblMultipleLocation.removeObserver(self, forKeyPath: "contentSize")
        }
        self.tblMultipleLocation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMultipleLocation.dataSource = self
        self.tblMultipleLocation.delegate = self
        self.tblMultipleLocation.rowHeight = UITableView.automaticDimension
        self.tblMultipleLocation.estimatedRowHeight = 100
        self.tblMultipleLocation.register(UINib(nibName: SearchLocationCell.className, bundle: nil), forCellReuseIdentifier: SearchLocationCell.className)
        self.ReloadAllData()
        self.setLocalization()
    }
    
    func setData(data: MyLoadsNewPostedTruck?) {
        let BookingDetails = data?.bookingInfo
        let TimeToCancel = (30*60)-(data?.time_difference ?? 0)
        self.btnAccept.layer.borderWidth = 1
        self.btnReject.layer.borderWidth = 1
        self.lblPrice.text = Currency + (BookingDetails?.amount ?? "")
        self.lblCompanyName.text = BookingDetails?.shipperDetails?.companyName ?? ""
        if(data?.offerPrice == ""){
            self.lblOfferPrice.isHidden = true
        }else{
            self.lblOfferPrice.isHidden = false
            let price = Int(Double(data?.offerPrice ?? "") ?? 0)
            let value = (price < 0) ? "% ↓" : "% ↑"
            self.lblOfferPrice.fontColor = ((price < 0) ? colors.red.value : UIColor(named: "ThemeGreenColor")) ?? .green
            self.lblOfferPrice.text = "\(price)" + value
        }
        self.lblRatting.text = "(\(BookingDetails?.shipperDetails?.noOfShipperRated ?? 0))"
        self.lblWeightAndMiles.text = "\(BookingDetails?.totalWeight ?? "0 KG"), \(BookingDetails?.distance ?? "") Km"
        self.lblTruckType.text = BookingDetails?.trucks?.truckType?.name ?? "Truck type"
        let StringURLForProfile = "\(APIEnvironment.ShipperImageURL)\(BookingDetails?.shipperDetails?.profile ?? "")"
        self.imgCompany.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgCompany.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
        self.viewCosoms.settings.fillMode = .precise
        self.viewCosoms.rating = Double(BookingDetails?.shipperDetails?.shipperRating ?? "") ?? 0.0
        self.viewCosoms.isHidden = false
        self.PickUpDropOffData = BookingDetails?.trucks?.locations
        self.btnAccept.isHidden = ((BookingDetails?.isBid ?? 0) == 1) ? false : true
        self.btnReject.setTitle(((BookingDetails?.isBid ?? 0) == 1) ? "Decline".localized : "\( TimeToCancel / 60) minutes remaining to cancel", for: .normal)
        self.tblMultipleLocation.reloadData()
        self.tblMultipleLocation.layoutIfNeeded()
        self.tblMultipleLocation.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLocalization() {
        self.lblOffer.text = "Offer price".localized
        self.btnAccept.setTitle("Accept".localized, for: .normal)
        self.btnReject.setTitle("Decline".localized, for: .normal)
    }
    func ReloadAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tblMultipleLocation.layoutIfNeeded()
            self.tblMultipleLocation.reloadDataWithAutoSizingCellWorkAround()
        })
    }
    
    //MARK: - IBAction method
    @IBAction func btnAcceptClick(_ sender: themeButton) {
        if let click = self.acceptRejectClosour{
            click(true)
        }
    }
    
    @IBAction func btnRejectClick(_ sender: themeButton) {
        if let click = self.acceptRejectClosour{
            click(false)
        }
    }

}

//MARK: - TableView datasource and delegate
extension PostedTruckBidReqCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PickUpDropOffData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: SearchLocationCell.className, for: indexPath) as! SearchLocationCell
        if PickUpDropOffData?[indexPath.row].isPickup == 0 && (indexPath.row != 0 || indexPath.row != PickUpDropOffData?.count) {
            cell.imgLocation.image = UIImage(named: "ic_pickDrop")
        } else {
            cell.imgLocation.image = (PickUpDropOffData?[indexPath.row].isPickup == 0) ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
