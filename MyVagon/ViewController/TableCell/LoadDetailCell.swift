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
    var sizeForTableview : ((CGFloat) -> ())?
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
    
    var LoadDetails : [SearchProduct]?
  
    var shimmeringAnimatedItems: [UIView]{
        [
            PickUpDropOffImageView,
            vwShimmer,
            lblName,
            lblAddress,
            lblDate
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if TblLoadDetails.observationInfo != nil {
            self.TblLoadDetails.removeObserver(self, forKeyPath: "contentSize")
        }
        self.TblLoadDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        TblLoadDetails.dataSource = self
        TblLoadDetails.delegate = self
        TblLoadDetails.rowHeight = UITableView.automaticDimension
        TblLoadDetails.estimatedRowHeight = 100
       
        TblLoadDetails.register(UINib(nibName: "PickLoadCell", bundle: nil), forCellReuseIdentifier: "PickLoadCell")
        
       
        let radius = viewStatus.frame.height / 2
        //headerView.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //viewContainer is the parent of viewContents
        //viewContents contains all the UI which you want to show actually.
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

        // sending viewContainer color to the viewContents.
       // let backgroundCGColor =
        //You can set your color directly if you want by using below two lines. In my case I'm copying the color.
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
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil, userInfo: TblDataDict)
                
            }
        }
    }
}
extension LoadDetailCell : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return LoadDetails?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ConHeightTblLoadDetails.constant = TblLoadDetails.contentSize.height
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PickLoadCell", for: indexPath) as! PickLoadCell
        cell.btnNotes.isHidden = ((LoadDetails?[indexPath.row].note ?? "") == "") ? true : false
        cell.viewNotesClosour = {
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: ViewNotesPopupVC.storyboardID) as! ViewNotesPopupVC
           
            controller.noteString = self.LoadDetails?[indexPath.row].note ?? ""
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .coverVertical
            let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(280) + appDel.GetSafeAreaHeightFromBottom())])
            UIApplication.topViewController()?.present(sheetController, animated: true, completion:  {
            })
        }
        
        cell.lblProductName.text = LoadDetails?[indexPath.row].productId?.name ?? ""
        cell.lblWeight.text = "\(LoadDetails?[indexPath.row].weight ?? "") \(LoadDetails?[indexPath.row].unit?.name ?? "")"
        cell.lblCapacity.text = "\(LoadDetails?[indexPath.row].qty ?? "0") x \(LoadDetails?[indexPath.row].productType?.name ?? "")"
        
        if LoadDetails?[indexPath.row].isFragile == 0 && LoadDetails?[indexPath.row].isSensetive == 0 {
            cell.lblType.isHidden = true
        } else {
            if (LoadDetails?[indexPath.row].isFragile == 1) && (LoadDetails?[indexPath.row].isSensetive == 1) {
                cell.lblType.isHidden = false
                cell.lblType.text = "Fragile, Sensetive to odour"
            } else {
                cell.lblType.isHidden = false
                cell.lblType.text = (LoadDetails?[indexPath.row].isFragile == 1) ? "Fragile" : "Sensetive to odour"
            }
            
        }
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}
