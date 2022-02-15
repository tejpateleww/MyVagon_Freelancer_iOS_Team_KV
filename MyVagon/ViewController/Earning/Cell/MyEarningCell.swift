//
//  MyEarningCell.swift
//  MyVagon
//
//  Created by Tej P on 28/01/22.
//

import UIKit

class MyEarningCell: UITableViewCell {
    
    @IBOutlet weak var viewContents: UIView!
    @IBOutlet weak var lblCompanyNAme: themeLabel!
    @IBOutlet weak var lblAmount: themeLabel!
    @IBOutlet weak var lblTripID: themeLabel!
    @IBOutlet weak var lblTon: themeLabel!
    @IBOutlet weak var lblDeadhead: themeLabel!
    
    @IBOutlet weak var tblEarningLocation: UITableView!
    @IBOutlet weak var tblEarningLocationHeight: NSLayoutConstraint!
    
    var arrLocations : [Locations] = []
    var tblHeight:((CGFloat)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContents.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viewContents.layer.masksToBounds = false
        self.viewContents.layer.shadowRadius = 4
        self.viewContents.layer.borderColor = UIColor.black.cgColor
        self.viewContents.layer.cornerRadius = 15
        self.viewContents.layer.shadowOpacity = 0.1
        
        self.tblEarningLocation.delegate = self
        self.tblEarningLocation.dataSource = self
        self.tblEarningLocation.separatorStyle = .none
        self.tblEarningLocation.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
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
                self.tblEarningLocationHeight.constant = newsize.height
               
                
                if let getHeight  = tblHeight.self {
                    self.tblEarningLocation.layoutSubviews()
                    self.tblEarningLocation.layoutIfNeeded()
                    getHeight(self.tblEarningLocation.contentSize.height)
                }
            }
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: EarningLocationCell.className, bundle: nil)
        self.tblEarningLocation.register(nib, forCellReuseIdentifier: EarningLocationCell.className)
    }
    
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension MyEarningCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblEarningLocation.dequeueReusableCell(withIdentifier: EarningLocationCell.className) as! EarningLocationCell
        cell.selectionStyle = .none
        cell.viewLine.isHidden = false
        
        cell.lblCompanyName.text = self.arrLocations[indexPath.row].companyName
        cell.lblDateTime.text = self.arrLocations[indexPath.row].createdAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: DateFormatForDisplay)
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
