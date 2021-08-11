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
          
//        tblMultipleLocation.register(UINib(nibName: "HeaderTblViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTblViewCell")
        
        tblMultipleLocation.register(UINib(nibName: "HeaderOfLocationsTbl", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderOfLocationsTbl")
        

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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        conHeightOfTbl.constant = tblMultipleLocation.contentSize.height
        print(conHeightOfTbl.constant)

        let TblDataDict:[String: Any] = ["TblHeight": conHeightOfTbl.constant , "indexPath" : indexPath]
        cell.viewLine.isHidden = indexPath.row == 1 ? true : false
        cell.imgLocation.image = indexPath.row == 1 ? UIImage(named: "ic_DropOff") : UIImage(named: "ic_PickUp")
        cell
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil, userInfo: TblDataDict)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderOfLocationsTbl") as! HeaderOfLocationsTbl
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

