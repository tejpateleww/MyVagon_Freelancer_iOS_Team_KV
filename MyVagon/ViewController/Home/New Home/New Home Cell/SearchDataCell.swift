//
//  SearchDataCell.swift
//  MyVagon
//
//  Created by Tej P on 01/02/22.
//

import UIKit

class SearchDataCell: UITableViewCell {
    
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
    @IBOutlet weak var btnMainTap: UIButton!
    
    var arrLocations : [SearchLocation] = []
    var tblHeight:((CGFloat)->())?
    var btnMainTapCousure : (()->())?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let radius = self.vWStatus.frame.height / 2
        self.vWStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
        self.vWContents.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.vWContents.layer.masksToBounds = false
        self.vWContents.layer.shadowRadius = 4
        self.vWContents.layer.borderColor = UIColor.black.cgColor
        self.vWContents.layer.cornerRadius = 15
        self.vWContents.layer.shadowOpacity = 0.1
        
        self.tblSearchLocation.delegate = self
        self.tblSearchLocation.dataSource = self
        self.tblSearchLocation.separatorStyle = .none
        self.tblSearchLocation.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.registerNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - ====== Observer methods ========
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblSearchLocationHeight.constant = newsize.height
               
                
//                if let getHeight  = tblHeight.self {
//                    self.tblSearchLocation.layoutSubviews()
//                    self.tblSearchLocation.layoutIfNeeded()
//                    getHeight(self.tblSearchLocation.contentSize.height)
//                }
            }
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: SearchLocationCell.className, bundle: nil)
        self.tblSearchLocation.register(nib, forCellReuseIdentifier: SearchLocationCell.className)
    }
    
    @IBAction func btnMainTapAction(_ sender: Any) {
        if let obj = self.btnMainTapCousure{
            obj()
        }
    }
    
    
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension SearchDataCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblSearchLocation.dequeueReusableCell(withIdentifier: SearchLocationCell.className) as! SearchLocationCell
        cell.selectionStyle = .none
        
        cell.viewLine.isHidden = false
        cell.viewHorizontalLine.isHidden = true
        
        cell.lblCompanyName.text = self.arrLocations[indexPath.row].companyName
//        cell.lblDateTime.text = self.arrLocations[indexPath.row].createdAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: DateFormatForDisplay)
        cell.lblAddress.text = self.arrLocations[indexPath.row].dropLocation
        var StringForDateTime = ""
        StringForDateTime.append("\(self.arrLocations[indexPath.row].deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
        StringForDateTime.append(" ")
        
        if (self.arrLocations[indexPath.row].deliveryTimeTo ?? "") == (self.arrLocations[indexPath.row].deliveryTimeFrom ?? "") {
            StringForDateTime.append("\(self.arrLocations[indexPath.row].deliveryTimeTo ?? "")")
        } else {
            StringForDateTime.append("\(self.arrLocations[indexPath.row].deliveryTimeTo ?? "")-\(self.arrLocations[indexPath.row].deliveryTimeFrom ?? "")")
        }
        cell.lblDateTime.text = StringForDateTime
        
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
