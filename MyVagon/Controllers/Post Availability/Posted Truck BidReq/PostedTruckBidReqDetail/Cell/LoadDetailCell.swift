//
//  LoadDetailCell.swift
//  MyVagon
//
//  Created by Apple on 07/09/21.
//

import UIKit
import UIView_Shimmer
import FittedSheets

class LoadDetailCell: UITableViewCell,ShimmeringViewProtocol {
    
    //MARK: - Propertise
    @IBOutlet weak var ViewForSavingTree: UIView!
    @IBOutlet weak var ViewDottedTop: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var ViewDottedbottom: UIView!
    @IBOutlet weak var ViewForHeader: UIView!
    @IBOutlet weak var vwShimmer: UIView!
    @IBOutlet weak var PickUpDropOffImageView: UIImageView!
    @IBOutlet weak var lblPickupDropOff: themeLabel!
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblDate: themeLabel!
    @IBOutlet weak var viewContents: UIView!
    @IBOutlet weak var TblLoadDetails: UITableView!
    @IBOutlet weak var ConHeightTblLoadDetails: NSLayoutConstraint!
    @IBOutlet weak var vWHorizontalDotLine: DottedLineView!
    @IBOutlet weak var btnNotes: UIButton!
    
    var sizeForTableview : ((CGFloat) -> ())?
    var btnNoteClick : (()->())?
    var LoadDetails : [SearchProduct]?
    var showStatus = false
    var shimmeringAnimatedItems: [UIView]{
        [
            PickUpDropOffImageView,
            vwShimmer,
            lblName,
            lblAddress,
            lblDate
        ]
    }
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewContents.layoutIfNeeded()
        TblLoadDetails.layer.cornerRadius = 15
        TblLoadDetails.clipsToBounds = true
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
      }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.ConHeightTblLoadDetails.constant = newsize.height
                if let getHeight  = sizeForTableview {
                    self.TblLoadDetails.layoutIfNeeded()
                    getHeight(self.TblLoadDetails.contentSize.height)
                }
            }
        }
    }
    
    //MARK: - Custom method
    func setUpUI(){
        self.vWHorizontalDotLine.isHidden = true
        if TblLoadDetails.observationInfo != nil {
            self.TblLoadDetails.removeObserver(self, forKeyPath: "contentSize")
        }
        self.TblLoadDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.TblLoadDetails.dataSource = self
        self.TblLoadDetails.delegate = self
        self.TblLoadDetails.rowHeight = UITableView.automaticDimension
        self.TblLoadDetails.estimatedRowHeight = 100
        self.TblLoadDetails.register(UINib(nibName: "PickLoadCell", bundle: nil), forCellReuseIdentifier: "PickLoadCell")
        self.btnNotes.setTitle("Notes".localized, for: .normal)
        let radius = viewStatus.frame.height / 2
        self.viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
    }
    
    func setValue(data: SearchLocation?,bookingType:String){
        self.ViewForSavingTree.isHidden = true
        self.btnNotes.isHidden = (data?.note ?? "" == "")
        self.lblName.text = data?.companyName ?? ""
        self.lblAddress.text = data?.dropLocation ?? ""
        self.lblDate.text = data?.companyName ?? ""
        if (data?.deliveryTimeFrom ?? "") == (data?.deliveryTimeTo ?? "") {
            self.lblDate.text =  "\(data?.deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.deliveryTimeFrom ?? ""))"
        } else {
            self.lblDate.text =  "\(data?.deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "") \((data?.deliveryTimeFrom ?? ""))-\(data?.deliveryTimeTo ?? "")"
        }
        var picUp = 0
        if bookingType == "multiple_shipment"{
            if data?.products?.count ?? 0 > 1{
                self.showStatus = true
            }else{
                picUp = data?.products?.first?.isPickup ?? 0
            }
        }else{
            picUp = data?.isPickup ?? 0
        }
        if self.showStatus{
            self.lblPickupDropOff.text = ""
            self.lblPickupDropOff.superview?.backgroundColor = .clear
        }else{
            self.lblPickupDropOff.text = picUp == 0 ? "DROP".localized : "PICKUP".localized
            self.lblPickupDropOff.superview?.backgroundColor = (picUp == 0) ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        }
        self.LoadDetails = data?.products
        self.TblLoadDetails.reloadData()
        self.selectionStyle = .none
    }
    
    //MARK: - IBAction method
    @IBAction func btnNotesClicked(_ sender: UIButton) {
        if let click = btnNoteClick{
            click()
        }
    }
}

//MARK: - tableview dataSource and delegate
extension LoadDetailCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ConHeightTblLoadDetails.constant = TblLoadDetails.contentSize.height
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PickLoadCell", for: indexPath) as! PickLoadCell
        cell.btnNotes.isHidden = ((LoadDetails?[indexPath.row].note ?? "") == "") ? true : false
        cell.viewNotesClosour = {
            self.openNote(self.LoadDetails?[indexPath.row].note ?? "")
        }
        if showStatus{
            cell.viewStatus.backgroundColor = LoadDetails?[indexPath.row].isPickup ?? 0 == 0 ? #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1) : #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            cell.lblStatus.text = LoadDetails?[indexPath.row].isPickup ?? 0 == 0 ? "DROP".localized : "PICKUP".localized
        }else{
            cell.viewStatus.backgroundColor = .clear
            cell.lblStatus.text = ""
        }
        cell.lblProductName.text = LoadDetails?[indexPath.row].productId?.name ?? ""
        cell.weight = "\(LoadDetails?[indexPath.row].weight ?? "") \(LoadDetails?[indexPath.row].unit?.name ?? ""),"
        cell.capecity = "\(LoadDetails?[indexPath.row].qty ?? "0") x \(LoadDetails?[indexPath.row].productType?.name ?? "")"
        if LoadDetails?[indexPath.row].isFragile == 0 && LoadDetails?[indexPath.row].isSensetive == 0 {
        } else {
            if (LoadDetails?[indexPath.row].isFragile == 1) && (LoadDetails?[indexPath.row].isSensetive == 1) {
                cell.type = "\("Fragile".localized), \("Sensetive to odour".localized)"
            } else {
                cell.type = (LoadDetails?[indexPath.row].isFragile == 1) ? "Fragile".localized : "Sensetive to odour".localized
            }
        }
        cell.setText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func openNote(_ text: String){
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
        controller.noteString = text
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280) + appDel.GetSafeAreaHeightFromBottom())])
        sheetController.allowPullingPastMaxHeight = false
        UIApplication.topViewController()?.present(sheetController, animated: true, completion:  {
        })
    }
}
