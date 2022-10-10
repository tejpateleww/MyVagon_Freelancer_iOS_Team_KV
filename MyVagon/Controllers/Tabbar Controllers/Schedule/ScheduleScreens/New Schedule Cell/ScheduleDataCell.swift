//
//  ScheduleDataCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 02/02/22.
//

import UIKit

class ScheduleDataCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var vWContents: UIView!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblAmount: themeLabel!
    @IBOutlet weak var lblLoadId: themeLabel!
    @IBOutlet weak var lblTonMiles: themeLabel!
    @IBOutlet weak var lblDeadhead: themeLabel!
    @IBOutlet weak var tblSearchLocation: UITableView!
    @IBOutlet weak var tblSearchLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var vWStatus: UIView!
    @IBOutlet weak var lblStatus: themeLabel!
    @IBOutlet weak var lblScheduleType: UILabel!
    @IBOutlet weak var viewScheduleType: UIView!
    @IBOutlet weak var lblSubStatus: UILabel!
    @IBOutlet weak var btnMatches: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var arrLocations : [MyLoadsNewLocation] = []
    var tblData :MyLoadsNewDatum?
    var tblHeight:((CGFloat)->())?
    var btnMatchTapCousure :(() -> ())?
    var btnDeleteTap :(() -> ())?
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func layoutSubviews() {
        self.vWStatus.roundCornerssingleSide(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblSearchLocationHeight.constant = newsize.height
                if let getHeight  = tblHeight.self {
                    self.tblSearchLocation.layoutSubviews()
                    self.tblSearchLocation.layoutIfNeeded()
                    getHeight(self.tblSearchLocation.contentSize.height)
                }
            }
        }
    }
    
    //MARK: - Custom method
    func setupUI(){
        self.vWContents.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.vWContents.layer.masksToBounds = false
        self.vWContents.layer.shadowRadius = 4
        self.vWContents.layer.borderColor = UIColor.black.cgColor
        self.vWContents.layer.cornerRadius = 15
        self.vWContents.layer.shadowOpacity = 0.1
        viewScheduleType.layer.cornerRadius = viewScheduleType.frame.height / 2
        viewScheduleType.layer.backgroundColor = UIColor.lightGray.cgColor
        self.tblSearchLocation.delegate = self
        self.tblSearchLocation.dataSource = self
        self.tblSearchLocation.separatorStyle = .none
        self.tblSearchLocation.isScrollEnabled = false
        self.tblSearchLocation.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.btnMatches.isUserInteractionEnabled = false
        self.tblSearchLocation.isUserInteractionEnabled = false
        self.registerNib()
    }
    
    func getStatusColor(status: String,paymentStatus: String){
        lblStatus.text = status.localized.capitalized
        var color = UIColor()
        switch status{
        case MyLoadesStatus.pending.Name:
            color = #colorLiteral(red: 0.8352941176, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
        case MyLoadesStatus.inprocess.Name:
            color = #colorLiteral(red: 0.1753416657, green: 0.388015449, blue: 0.8075901866, alpha: 1)
        case MyLoadesStatus.completed.Name:
            color = #colorLiteral(red: 0.09411764706, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
            if (paymentStatus != "pending"){
                color = #colorLiteral(red: 0.5529411765, green: 0.1254901961, blue: 1, alpha: 1)
                lblStatus.text = "Paid".localized
            }
        case MyLoadesStatus.past.Name:
            color = #colorLiteral(red: 0.8352941176, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
        case MyLoadesStatus.canceled.Name:
            color = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.662745098, alpha: 1)
        case MyLoadesStatus.scheduled.Name:
            color = #colorLiteral(red: 0.8977488875, green: 0.6361243129, blue: 0.01851113513, alpha: 1)
        default:
            color = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.662745098, alpha: 1)
        }
        vWStatus.backgroundColor = color
        lblSubStatus.textColor = color
        self.btnDelete.tintColor = vWStatus.backgroundColor
    }
    
    func setPostedTruck(lodeData: MyLoadsNewPostedTruck?){
        if (lodeData?.bookingInfo?.trucks?.locations?.count ?? 0) != 0{
            lblCompanyName.text = lodeData?.bookingInfo?.shipperDetails?.name ?? ""
            if SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1{
                let amount = (lodeData?.bidAmount == "" || lodeData?.bidAmount == nil) ? lodeData?.bookingInfo?.amount : lodeData?.bidAmount
                lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + "\(amount ?? "")" : ""
                lblAmount.isHidden = false
            }else{
                lblAmount.isHidden = true
            }
            lblLoadId.text = "#\(lodeData?.bookingInfo?.id ?? 0)"
            lblTonMiles.text =   "\(lodeData?.bookingInfo?.totalWeight ?? ""), \(lodeData?.bookingInfo?.distance ?? "") Km"
            let DeadheadValue = lodeData?.bookingInfo?.trucks?.truckType?.name ?? ""
            lblDeadhead.text = DeadheadValue
            getStatusColor(status: lodeData?.bookingInfo?.status ?? "", paymentStatus: lodeData?.bookingInfo?.paymentStatus ?? "")
            arrLocations = lodeData?.bookingInfo?.trucks?.locations ?? []
            relodeTable()
            btnMatches.isHidden = true
            btnDelete.isHidden = true
        }else{
            lblCompanyName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
            getStatusColor(status: MyLoadesStatus.pending.Name, paymentStatus: "")
            if SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1{
                lblAmount.text = Currency + (lodeData?.bidAmount ?? "")
                lblAmount.isHidden = false
            }else{
                lblAmount.isHidden = true
            }
            btnDelete.isHidden = false
            lblLoadId.text = "#\(lodeData?.id ?? 0)"
            arrLocations = []
            relodeTable()
            if let truck = SingletonClass.sharedInstance.TruckTypeList?.first(where: {$0.id == lodeData?.truckTypeId}){
                lblDeadhead.text = truck.getName()
            }else{
                lblDeadhead.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.getName()
            }
            lblDeadhead.isHidden = false
            lblTonMiles.isHidden = true
            btnMatches.isHidden = false
            btnMatches.borderWidth = 1
            if (tblData?.postedTruck?.bookingRequestCount ?? 0) != 0 {
                btnMatches.isUserInteractionEnabled = true
                let totalCount = (tblData?.postedTruck?.bookingRequestCount ?? 0)
                btnMatches.layer.borderColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1).cgColor
                btnMatches.backgroundColor = .clear
                btnMatches.setTitleColor(#colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), for: .normal)
                btnDelete.isHidden = true
                if (tblData?.postedTruck?.isBid ?? 0) == 1 {
                    btnMatches.setTitle("\("View".localized) \(totalCount) \("Bid_Request".localized)", for: .normal)
                } else {
                    let TimeToCancel = (30*60)-(tblData?.postedTruck?.time_difference ?? 0)
                    btnMatches.setTitle("\(TimeToCancel / 60) \("minutes remaining to cancel".localized)", for: .normal)
                }
            }else{
                if tblData?.postedTruck?.matchesCount ?? 0 == 0{
                    btnMatches.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1)
                    btnMatches.setTitleColor(hexStringToUIColor(hex: "#FFFFFF"), for: .normal)
                    btnMatches.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1).cgColor
                    btnMatches.setTitle("No Matches Found".localized, for: .normal)
                }else{
                    btnMatches.isUserInteractionEnabled = true
                    let totalCount = (tblData?.postedTruck?.matchesCount ?? 0)
                    btnMatches.setTitleColor(#colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), for: .normal)
                    btnMatches.layer.borderColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1).cgColor
                    btnMatches.backgroundColor = .clear
                    btnMatches.setTitle("\("load_found".localized)\(totalCount) \("Matches Load Found".localized)", for: .normal)
                }
            }
        }
        lblSubStatus.text = lodeData?.displayStatusMessage ?? ""
    }
    
    func setData(data : MyLoadsNewBid?){
        lblDeadhead.isHidden = false
        lblTonMiles.isHidden = false
        lblCompanyName.text = data?.shipperDetails?.companyName ?? ""
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1{
            let amount = (data?.bookingBidAmount != "" && data?.bookingBidAmount != nil) ? data?.bookingBidAmount : data?.amount
            lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + "\(amount ?? "")" : ""
            lblAmount.isHidden = false
        }else{
            lblAmount.isHidden = true
        }
        lblLoadId.text = "#\(data?.id ?? 0)"
        lblTonMiles.text =   "\(data?.totalWeight ?? ""), \(data?.distance ?? "") Km"
        let DeadheadValue = data?.trucks?.truckType?.name ?? ""
        lblDeadhead.text = DeadheadValue
        btnMatches.isHidden = true
        getStatusColor(status: data?.status ?? "", paymentStatus: data?.paymentStatus ?? "")
        arrLocations = data?.trucks?.locations ?? []
        relodeTable()
        lblSubStatus.text = data?.displayStatusMessage ?? ""//getMsg(status: data?.status ?? "", bid: data?.isBid ?? 0)
    }
    
    func relodeTable(){
        tblSearchLocation.reloadData()
        tblSearchLocation.layoutIfNeeded()
        tblSearchLocation.layoutSubviews()
    }
    
    func registerNib(){
        let nib = UINib(nibName: SearchLocationCell.className, bundle: nil)
        self.tblSearchLocation.register(nib, forCellReuseIdentifier: SearchLocationCell.className)
    }
    
    //MARK: - IBAction method
    @IBAction func btnMatchAction(_ sender: Any) {
        if let obj = btnMatchTapCousure{
            obj()
        }
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        if let obj = btnDeleteTap{
            obj()
        }
    }
}

//MARK: - UITableView Delegate and Data Source Methods
extension ScheduleDataCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tblData?.type == MyLoadType.PostedTruck.Name{
            if ((tblData?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) == 0) {
                return 2
            }
        }
        return self.arrLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSearchLocation.dequeueReusableCell(withIdentifier: SearchLocationCell.className) as! SearchLocationCell
        cell.selectionStyle = .none
        if tblData?.type == MyLoadType.PostedTruck.Name{
            if ((tblData?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) == 0){
                if indexPath.row == 0{
                    var StringForDateTime = ""
                    StringForDateTime.append("\(tblData?.postedTruck?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
                    StringForDateTime.append(" ")
                    if (tblData?.postedTruck?.time ?? "") != "" {
                        StringForDateTime.append("\(tblData?.postedTruck?.time ?? "")")
                    }
                    cell.lblDateTime.text = StringForDateTime
                    cell.lblCompanyName.text = tblData?.postedTruck?.fromAddress ?? ""
                    cell.imgLocation.image = UIImage(named: "ic_PickUp")
                    cell.viewLine.isHidden = false
                }else{
                    cell.lblDateTime.isHidden = false
                    cell.lblDateTime.text = "N/A"
                    cell.lblCompanyName.text = (tblData?.postedTruck?.toAddress != nil || tblData?.postedTruck?.toAddress ?? "" != "") ? tblData?.postedTruck?.toAddress ?? "" : "N/A"
                    cell.imgLocation.image = UIImage(named: "ic_DropOff")
                    cell.viewLine.isHidden = true
                }
                cell.lblAddress.isHidden = true
                return cell
            }
        }
        cell.lblAddress.isHidden = false
        self.setCellData(data: self.arrLocations[indexPath.row], cell: cell)
        if(indexPath.row == (self.arrLocations.count - 1)){
            cell.viewLine.isHidden = true
        }
        if(indexPath.row == 0){
            cell.imgLocation.image = UIImage(named: "ic_PickUp")
        }else if(indexPath.row == (self.arrLocations.count) - 1){
            cell.imgLocation.image = UIImage(named: "ic_DropOff")
        }else{
            cell.imgLocation.image = UIImage(named: "ic_pickDrop")
            cell.viewHorizontalLine.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setCellData(data: MyLoadsNewLocation?,cell:SearchLocationCell){
        selectionStyle = .none
        cell.viewLine.isHidden = false
        cell.viewHorizontalLine.isHidden = true
        cell.lblCompanyName.text = data?.companyName
        cell.lblAddress.text = data?.dropLocation
        var StringForDateTime = ""
        StringForDateTime.append("\(data?.deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
        StringForDateTime.append(" ")
        if (data?.deliveryTimeTo ?? "") == (data?.deliveryTimeFrom ?? "") {
            StringForDateTime.append("\(data?.deliveryTimeTo ?? "")")
        } else {
            StringForDateTime.append("\(data?.deliveryTimeFrom ?? "")-\(data?.deliveryTimeTo ?? "")")
        }
        cell.lblDateTime.text = StringForDateTime
    }
    
}
