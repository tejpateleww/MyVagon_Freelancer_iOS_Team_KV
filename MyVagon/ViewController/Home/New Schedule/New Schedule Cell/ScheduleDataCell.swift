//
//  ScheduleDataCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 02/02/22.
//

import UIKit

class ScheduleDataCell: UITableViewCell {

    
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
    
    
    var arrLocations : [MyLoadsNewLocation] = []
    var tblData :MyLoadsNewDatum?
    var tblHeight:((CGFloat)->())?
    var btnMatchTapCousure :(() -> ())?
    //MARK: - ====== Observer methods ========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        btnMatches.isUserInteractionEnabled = false
        self.tblSearchLocation.isUserInteractionEnabled = false
        self.registerNib()
    }
    override func layoutSubviews() {
        let radius = self.vWStatus.frame.height / 2
        self.vWStatus.roundCorners(corners: [.topLeft,.bottomLeft    ], radius: radius)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
   
    @IBAction func btnMatchAction(_ sender: Any) {
        if let obj = btnMatchTapCousure{
            obj()
        }
    }

//MARK: - Coustom function
    
    func getStatusColor(status: String,paymentStatus: String){
        lblStatus.text = status.capitalized
        switch status{
        case NewScheduleStatus.pending.Name:
            vWStatus.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
        case NewScheduleStatus.inprocess.Name:
            vWStatus.backgroundColor = #colorLiteral(red: 0.1753416657, green: 0.388015449, blue: 0.8075901866, alpha: 1)
        case NewScheduleStatus.completed.Name:
            if (paymentStatus == "pending"){
                vWStatus.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
            }else{
                vWStatus.backgroundColor = #colorLiteral(red: 0.5529411765, green: 0.1254901961, blue: 1, alpha: 1)
                lblStatus.text = "Paid"
            }
        case NewScheduleStatus.past.Name:
            vWStatus.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            return
        case NewScheduleStatus.canceled.Name:
            vWStatus.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.662745098, alpha: 1)
            return
        case NewScheduleStatus.scheduled.Name:
            vWStatus.backgroundColor = #colorLiteral(red: 0.8977488875, green: 0.6361243129, blue: 0.01851113513, alpha: 1)
            return
        default:
            vWStatus.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.662745098, alpha: 1)
            return
        }
    }
    func getMsg(status: String,bid:Int) -> String{
        if bid == 1{
            switch status{
            case NewScheduleStatus.pending.Name:
                return "Bid Confirmation Pending"
            case NewScheduleStatus.inprocess.Name:
                return ""
            case NewScheduleStatus.completed.Name:
                return ""
            case NewScheduleStatus.past.Name:
                return ""
            case NewScheduleStatus.canceled.Name:
                return ""
            case NewScheduleStatus.scheduled.Name:
                return ""
            default:
                return ""
            }
        }else{
            return ""
        }
    }
    func setPostedTruck(lodeData: MyLoadsNewPostedTruck?){
        
        if (lodeData?.bookingInfo?.trucks?.locations?.count ?? 0) != 0{
            lblCompanyName.text = lodeData?.bookingInfo?.shipperDetails?.name ?? ""
            let amount = (lodeData?.bookingInfo?.bookingBidAmount != nil) ? lodeData?.bookingInfo?.bookingBidAmount : lodeData?.bookingInfo?.amount
            lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + "\(amount ?? "")" : ""
            lblLoadId.text = "#\(lodeData?.bookingInfo?.id ?? 0)"
            lblTonMiles.text =   "\(lodeData?.bookingInfo?.totalWeight ?? ""), \(lodeData?.bookingInfo?.distance ?? "") Km"
            let DeadheadValue = (lodeData?.bookingInfo?.trucks?.locations?.first?.deadhead ?? "" == "0") ? lodeData?.bookingInfo?.trucks?.truckType?.name ?? "" : "\(lodeData?.bookingInfo?.trucks?.locations?.first?.deadhead ?? "") : \(lodeData?.bookingInfo?.trucks?.truckType?.name ?? "")"
            lblDeadhead.text = DeadheadValue
            getStatusColor(status: lodeData?.bookingInfo?.status ?? "", paymentStatus: lodeData?.bookingInfo?.paymentStatus ?? "")
            arrLocations = lodeData?.bookingInfo?.trucks?.locations ?? []
            lblSubStatus.text = getMsg(status: lodeData?.bookingInfo?.status ?? "", bid: lodeData?.bookingInfo?.isBid ?? 0)
        }else{
            
            lblCompanyName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
            getStatusColor(status: MyLoadesStatus.pending.Name, paymentStatus: "")
            lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (lodeData?.bidAmount ?? "" ) : ""
            lblLoadId.text = "#\(lodeData?.id ?? 0)"
            arrLocations = []
            lblDeadhead.isHidden = true
            lblTonMiles.isHidden = true
            btnMatches.isHidden = false
            btnMatches.borderWidth = 1
            if (tblData?.postedTruck?.bookingRequestCount ?? 0) != 0 {
                btnMatches.isUserInteractionEnabled = true
                let totalCount = (tblData?.postedTruck?.bookingRequestCount ?? 0)
                btnMatches.layer.borderColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1).cgColor
                btnMatches.backgroundColor = .clear
                btnMatches.setTitleColor(#colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), for: .normal)
                if (tblData?.postedTruck?.isBid ?? 0) == 1 {
                    btnMatches.setTitle("View \(totalCount) Bid Request", for: .normal)
                } else {
                    let TimeToCancel = (30*60)-(tblData?.postedTruck?.time_difference ?? 0)
                    btnMatches.setTitle("\(TimeToCancel / 60) minutes remaining to cancel", for: .normal)
                }
            }else{
                if tblData?.postedTruck?.matchesCount ?? 0 == 0{
                    btnMatches.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1)
                    btnMatches.setTitleColor(hexStringToUIColor(hex: "#FFFFFF"), for: .normal)
                    btnMatches.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8509803922, alpha: 1).cgColor
                    btnMatches.setTitle("No Matches Found", for: .normal)
                }else{
                    btnMatches.isUserInteractionEnabled = true
                    let totalCount = (tblData?.postedTruck?.matchesCount ?? 0)
                    btnMatches.setTitleColor(#colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), for: .normal)
                    btnMatches.layer.borderColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1).cgColor
                    btnMatches.backgroundColor = .clear
                    btnMatches.setTitle("\(totalCount) Matches Load Found", for: .normal)
                    if (tblData?.postedTruck?.isBid ?? 0) == 0{
                        let TimeToCancel = (30*60)-(tblData?.postedTruck?.time_difference ?? 0)
                        btnMatches.setTitleColor(#colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1), for: .normal)
                        btnMatches.layer.borderColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1).cgColor
                        btnMatches.setTitle("\(TimeToCancel / 60) minutes remaining to cancel", for: .normal)
                    }
                }
            }
        }
    }
    
    func setData(data : MyLoadsNewBid?){
        lblDeadhead.isHidden = false
        lblTonMiles.isHidden = false
        lblCompanyName.text = data?.shipperDetails?.companyName ?? ""
        let amount = (data?.bookingBidAmount != nil) ? data?.bookingBidAmount : data?.amount
        lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + "\(amount ?? "")" : ""
        lblLoadId.text = "#\(data?.id ?? 0)"
        lblTonMiles.text =   "\(data?.totalWeight ?? ""), \(data?.distance ?? "") Km"
        let DeadheadValue = (data?.trucks?.locations?.first?.deadhead ?? "" == "0") ? data?.trucks?.truckType?.name ?? "" : "\(data?.trucks?.locations?.first?.deadhead ?? "") : \(data?.trucks?.truckType?.name ?? "")"
        lblDeadhead.text = DeadheadValue
        btnMatches.isHidden = true
        getStatusColor(status: data?.status ?? "", paymentStatus: data?.paymentStatus ?? "")
        arrLocations = data?.trucks?.locations ?? []
        lblSubStatus.text = getMsg(status: data?.status ?? "", bid: data?.isBid ?? 0)
    }
   
    func registerNib(){
        let nib = UINib(nibName: SearchLocationCell.className, bundle: nil)
        self.tblSearchLocation.register(nib, forCellReuseIdentifier: SearchLocationCell.className)
    }
    
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension ScheduleDataCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tblData?.type == MyLoadType.PostedTruck.Name{
            if !((tblData?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0) {
                return 2
            }
        }
        return self.arrLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblSearchLocation.dequeueReusableCell(withIdentifier: SearchLocationCell.className) as! SearchLocationCell
        cell.selectionStyle = .none
        if tblData?.type == MyLoadType.PostedTruck.Name{
            if !((tblData?.postedTruck?.bookingInfo?.trucks?.locations?.count ?? 0) != 0){
                if indexPath.row == 0{
                    cell.lblDateTime.text = "\(tblData?.postedTruck?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")"
                    cell.lblCompanyName.text = tblData?.postedTruck?.fromAddress ?? ""
                    cell.imgLocation.image = UIImage(named: "ic_PickUp")
                    cell.viewLine.isHidden = false
                }else{
                    cell.lblDateTime.isHidden = false
                    cell.lblDateTime.text = "\(tblData?.postedTruck?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")"
                    cell.lblCompanyName.text = (tblData?.postedTruck?.toAddress != nil || tblData?.postedTruck?.toAddress ?? "" != "") ? tblData?.postedTruck?.toAddress ?? "" : "N/A"
                    cell.imgLocation.image = UIImage(named: "ic_DropOff")
                    cell.viewLine.isHidden = true
                }
                cell.lblAddress.isHidden = true
                return cell
            }
        }
        cell.viewLine.isHidden = false
        cell.viewHorizontalLine.isHidden = true
        cell.lblCompanyName.text = self.arrLocations[indexPath.row].companyName
//        cell.lblDateTime.text = self.arrLocations[indexPath.row].createdAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: DateFormatForDisplay)
        var StringForDateTime = ""
        StringForDateTime.append("\(self.arrLocations[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
        StringForDateTime.append(" ")
        
        if (self.arrLocations[indexPath.row].deliveryTimeTo ?? "") == (self.arrLocations[indexPath.row].deliveryTimeFrom ?? "") {
            StringForDateTime.append("\(self.arrLocations[indexPath.row].deliveryTimeTo ?? "")")
        } else {
            StringForDateTime.append("\(self.arrLocations[indexPath.row].deliveryTimeTo ?? "")-\(self.arrLocations[indexPath.row].deliveryTimeFrom ?? "")")
        }
        cell.lblDateTime.text = StringForDateTime
        
        cell.lblAddress.text = self.arrLocations[indexPath.row].dropLocation
        
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
    
}
