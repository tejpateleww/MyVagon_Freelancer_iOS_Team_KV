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
    
    var tblHeight:((CGFloat)->())?
    var isFromBidRequest = false
    var SelectedFilterOfBid = BidStatus.all.rawValue
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
            self.tblMultipleLocation.reloadData()//reloadDataWithAutoSizingCellWorkAround()
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
                print("ATDebug :: \(newsize.height)")
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
        print(conHeightOfTbl.constant)
       // let TblDataDict:[String: Any] = ["TblHeight": conHeightOfTbl.constant , "indexPath" : indexPath]
        
        if isFromBidRequest == false {
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
           
            cell.viewLine.isHidden = indexPath.row == 2 ? true : false
            cell.imgLocation.image = indexPath.row == 2 ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil, userInfo: TblDataDict)
           
            return cell
        }
        else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BidRequestTblCell", for: indexPath) as! BidRequestTblCell
           
            cell.btnBidRequest.isHidden = indexPath.row == 2 ? false : true
            cell.conHeightOfButton.constant = cell.btnBidRequest.isHidden == false ? 40 : 0
            cell.viewLine.isHidden = indexPath.row == 2 ? true : false
            cell.bottomHeightBtn.constant = cell.btnBidRequest.isHidden == false ? 15 : 0
            cell.imgLocation.image = indexPath.row == 2 ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderOfLocationsTbl") as! HeaderOfLocationsTbl
       
            header.lblBidStatus.isHidden = !isFromBidRequest
            header.viewStatusBid.isHidden = !isFromBidRequest
        
        switch SelectedFilterOfBid {
        case BidStatus.all.rawValue:
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
            header.ViewStatusBidText.text = "All"
        case BidStatus.pending.rawValue:
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)
            header.ViewStatusBidText.text = "Pending"
        case BidStatus.scheduled.rawValue:
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
            header.ViewStatusBidText.text = "Scheduled"
        case BidStatus.inProgress.rawValue:
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.3038921356, green: 0.5736817122, blue: 0.8892048597, alpha: 1)
            header.ViewStatusBidText.text = "In-Progress"
        case BidStatus.past.rawValue:
            header.viewStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
            header.ViewStatusBidText.text = "Past"
        default:
            break
        }
        
        //header.conHeightOfViewBidStatus.constant = isFromBidRequest ? 30 : 0
       
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isFromBidRequest == true ? 130 : 110
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

